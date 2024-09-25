module RAM_TB ();
    reg         HWRITE_TB, HBURST_TB, HSELx_TB, HREADY_TB;
    reg         HRESTn_TB, HCLK_TB;
    reg  [2:0]  HSIZE_TB;
    reg  [1:0]  HTRANS_TB;
    reg  [31:0] HADDR_TB, HWDATA_TB;
    wire [31:0] HRDATA_TB;
    wire        HREADYOUT_TB, HRESP_TB;
    
    parameter CLK_PERIOD = 10;

    typedef enum bit {
        IDLE = 1'b0,
        SEND = 1'b1
    } states;

    states PS, NS;

    typedef enum bit [2:0] {
        HSIZE_Byte = 3'b000,
        HSIZE_one_word = 3'b010
    } HSIZE_STATES;

    typedef enum bit [1:0] {
        HTRANS_IDLE = 2'b00,
        HTRANS_BUSY = 2'b01,
        HTRANS_NONSEQ = 2'b10,
        HTRANS_SEQ = 2'b11
    } HTRANS_STATES;

    typedef enum bit {
        HBURST_state_single = 0,
        HBURST_state_INCR = 1
    } HBURST_STATES;

    initial 
    begin
        $dumpfile("RAM_Dump.vcd");
        $dumpvars; 
        initialize();
        TEST_READ_INCR();
        #CLK_PERIOD;
        TEST_READ_single();
        #CLK_PERIOD;
        TEST_WRITE_INCR();
        #CLK_PERIOD;
        TEST_WRITE_single();
        #100;
        $finish;
    end

    task initialize;
    begin
        HWRITE_TB = 0;
        HBURST_TB = HBURST_state_single;
        HSELx_TB = 0;
        HREADY_TB = 0;
        HRESTn_TB = 0;
        HCLK_TB = 0;
        HSIZE_TB = HSIZE_one_word; 
        HTRANS_TB = HTRANS_IDLE;
        HADDR_TB = 0; 
        HWDATA_TB = 0;
    end
    endtask

    task rest;
    begin
        HRESTn_TB = 'b1;
        #CLK_PERIOD;
        HRESTn_TB = 'b0;
        #CLK_PERIOD;
        HRESTn_TB = 'b1;
    end
    endtask

    task TEST_READ_INCR;
    begin
        $display("Test Increment read");
        rest();
        HWRITE_TB = 0;
        HSELx_TB = 1;
        HREADY_TB = 1;
        HTRANS_TB = HTRANS_NONSEQ;
        HADDR_TB = 32'b0000_0000; 
        HSIZE_TB = HSIZE_one_word;
        HBURST_TB = HBURST_state_INCR;

        #CLK_PERIOD;
        wait (HREADYOUT_TB);
        if(HRDATA_TB == 32'b0000_0001)
        begin
            $display("operation 1 %h succeeded", HRDATA_TB);
        end
        else
        begin
            $display("operation 1 %h Failed", HRDATA_TB);
        end
        HTRANS_TB = HTRANS_SEQ;
        HADDR_TB = 32'b0000_0001;

        #CLK_PERIOD;
        wait (HREADYOUT_TB);
        if(HRDATA_TB == 32'b0000_0010)
        begin
            $display("operation 2 %h succeeded", HRDATA_TB);
        end
        else
        begin
            $display("operation 2 %h Failed", HRDATA_TB);
        end
        HADDR_TB = 32'b0000_0010;

        #CLK_PERIOD;
        wait (HREADYOUT_TB);
        if(HRDATA_TB == 32'b0000_0011)
        begin
            $display("operation 3 %h succeeded", HRDATA_TB);
        end
        else
        begin
            $display("operation 3 %h Failed", HRDATA_TB);
        end

        #CLK_PERIOD;
        HTRANS_TB = HTRANS_IDLE;
    end
    endtask

    task TEST_READ_single;
    begin
        $display("Test single read");
        // Test non-sequential read
        HTRANS_TB = HTRANS_NONSEQ;
        HADDR_TB = 32'b0000_0000;
        HSIZE_TB = HSIZE_one_word;
        HREADY_TB = 1;
        HSELx_TB = 1;
        #CLK_PERIOD;

        // Check read data
        if (HRDATA_TB == 32'b0000_0001) 
            $display("Read operation %h succeeded", HRDATA_TB);
        else
            $display("Read operation %h failed", HRDATA_TB);
        HTRANS_TB = HTRANS_IDLE;
        #CLK_PERIOD;
    end
    endtask

    task TEST_WRITE_INCR;
    begin
        $display("Test Increment write");
        rest();
        HWRITE_TB = 1;
        HSELx_TB = 1;
        HREADY_TB = 1;
        HTRANS_TB = HTRANS_NONSEQ;
        HADDR_TB = 32'b0000_0000; 
        HSIZE_TB = HSIZE_one_word;
        HBURST_TB = HBURST_state_INCR;
        HWDATA_TB = 32'b1000;

        #CLK_PERIOD;
        if(DUT.memory[0] == 32'b0000_1000)
        begin
            $display("operation 1 %h succeeded", DUT.memory[0]);
        end
        else
        begin
            $display("operation 1 %h Failed", DUT.memory[0]);
        end
        HTRANS_TB = HTRANS_SEQ;
        HADDR_TB = 32'b0000_0001;
        HWDATA_TB = 32'b1001;

        #CLK_PERIOD;
        if(DUT.memory[1] == 32'b0000_1001)
        begin
            $display("operation 2 %h succeeded", DUT.memory[1]);
        end
        else
        begin
            $display("operation 2 %h Failed", DUT.memory[1]);
        end
        HADDR_TB = 32'b0000_0010;
        HWDATA_TB = 32'b1101;

        #CLK_PERIOD;
        if(DUT.memory[2] == 32'b0000_1101)
        begin
            $display("operation 3 %h succeeded", DUT.memory[2]);
        end
        else
        begin
            $display("operation 3 %h Failed", DUT.memory[2]);
        end
        HADDR_TB = 32'b0000_0011;
        HWDATA_TB = 32'b1111;

        #CLK_PERIOD;
        if(DUT.memory[3] == 32'b0000_1111)
        begin
            $display("operation 4 %h succeeded", DUT.memory[3]);
        end
        else
        begin
            $display("operation 4 %h Failed", DUT.memory[3]);
        end
        HTRANS_TB = HTRANS_IDLE;
    end
    endtask

    task TEST_WRITE_single;
    begin
        $display("Test single write");
        // Test non-sequential read
        HTRANS_TB = HTRANS_NONSEQ;
        HADDR_TB = 32'b0000_0000;
        HREADY_TB = 1;
        HSELx_TB = 1;
        HWDATA_TB = 32'b0010;
        #CLK_PERIOD;

        // Check read data
        if (DUT.memory[0] == 32'b0000_0010) 
            $display("Read operation %h succeeded", HRDATA_TB);
        else
            $display("Read operation %h failed", HRDATA_TB);
    end
    endtask

    always #(CLK_PERIOD/2) HCLK_TB = ~HCLK_TB;

    RAM DUT (
        .HWRITE(HWRITE_TB), 
        .HBURST(HBURST_TB),
        .HSELx(HSELx_TB),
        .HREADY(HREADY_TB), 
        .HRESTn(HRESTn_TB),
        .HCLK(HCLK_TB),
        .HSIZE(HSIZE_TB), 
        .HTRANS(HTRANS_TB),
        .HADDR(HADDR_TB), 
        .HWDATA(HWDATA_TB),
        .HRDATA(HRDATA_TB),
        .HREADYOUT(HREADYOUT_TB),
        .HRESP(HRESP_TB)
    );
endmodule
