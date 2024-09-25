module MASTER_TOP_TB ();
    reg         HREADY_TB, HRESP_TB;
    reg         HRESTn_TB, HCLK_TB;
    reg [31:0]  HRDATA_TB;
    wire [31:0] HADDR_TB, HWDATA_TB;
    wire        HWRITE_TB, HBURST_TB;
    wire [2:0]  HSIZE_TB;
    wire [1:0]  HTRANS_TB;
    
    parameter CLK_PERIOD = 10;

    typedef enum bit [4:0] {
        IDLE         = 5'b00000,
        ROM_Address  = 5'b00001,
        FETCH_OPCODE = 5'b00010,
        FETCH_ARG1   = 5'b00011,
        FETCH_ARG2   = 5'b00100,
        FETCH_DEST   = 5'b00101,
        GET_Arg1     = 5'b00110,
        GET_Arg2     = 5'b00111,
        EXECUTE      = 5'b01000,
        WRITE_BACK   = 5'b01001,
        WAIT_FOR_OPCODE = 5'b01010,
        WAIT_FOR_ARG1 = 5'b01011,
        WAIT_FOR_ARG2 = 5'b01100,
        WAIT_FOR_DEST = 5'b01101,
        WAIT_FOR_GET_ARG1 = 5'b01110,
        WAIT_FOR_GET_ARG2 = 5'b01111,
        WAIT_FOR_WRITE_BACK = 5'b10000
    } states;

    initial 
    begin
        $dumpfile("MASTER_Dump.vcd");
        $dumpvars; 
        initialize();
        TEST();
        rest();
        $finish;
    end

    task initialize;
    begin
        HREADY_TB = 0; 
        HRESP_TB = 0;
        HRESTn_TB = 0;
        HCLK_TB = 0;
        HRDATA_TB = 0;
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

    task TEST;
    begin
        rest();
        HREADY_TB = 1; // Start with HREADY high to allow fetch
        HRESP_TB = 0;

        // Test 1: Fetch Opcode
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_OPCODE)
        HREADY_TB = 0;
        #CLK_PERIOD;
        HRDATA_TB = 8'b0000_0010;  // Simulate fetching opcode
        HREADY_TB = 1;
        #CLK_PERIOD;

        if (DUT.FSM_BLOCK.opcode == 8'b0000_0010)
            $display("Test 1: Opcode fetch succeeded %b", DUT.opcode);
        else
            $display("Test 1: Opcode fetch failed %b", DUT.opcode);
        #CLK_PERIOD;


        // Test 2: Fetch ARG1
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_ARG1)
        HREADY_TB = 0; // Simulate wait state
        #CLK_PERIOD;
        HRDATA_TB = 8'b1000_0001; // ARG1 address
        HREADY_TB = 1;
        #CLK_PERIOD;

        if (DUT.FSM_BLOCK.Arg_A == 8'b1000_0001)
            $display("Test 2: ARG1 fetch succeeded %b", DUT.FSM_BLOCK.Arg_A);
        else
            $display("Test 2: ARG1 fetch failed %b", DUT.FSM_BLOCK.Arg_A);

        // Test 3: Fetch ARG2
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_ARG2)
        HREADY_TB = 0; // Wait state
        #CLK_PERIOD;
        HRDATA_TB = 8'b1000_0010; // ARG2 address
        HREADY_TB = 1;
        #CLK_PERIOD;
        if (DUT.FSM_BLOCK.Arg_B == 8'b1000_0010)
            $display("Test 3: ARG2 fetch succeeded %b", DUT.FSM_BLOCK.Arg_A);
        else
            $display("Test 3: ARG2 fetch failed %b", DUT.FSM_BLOCK.Arg_A);

        // Test 4: Fetch DEST
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_DEST)
        HREADY_TB = 0;
        #CLK_PERIOD;
        HRDATA_TB = 8'b1000_0011; // DEST address
        HREADY_TB = 1;
        #CLK_PERIOD;
        if (DUT.FSM_BLOCK.DEST == 8'b1000_0011)
            $display("Test 4: DEST fetch succeeded %b", DUT.FSM_BLOCK.DEST);
        else
            $display("Test 4: DEST fetch failed %b", DUT.FSM_BLOCK.DEST);

        // Test 5: Fetch ARG1 data from RAM
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_GET_ARG1)
        HREADY_TB = 0;
        #CLK_PERIOD;
        HRDATA_TB = 8'b0000_0001; // ARG1 value
        HREADY_TB = 1;
        #CLK_PERIOD;
        if (DUT.Arg1 == 8'b0000_0001)
            $display("Test 5: ARG1 value fetch succeeded %b", DUT.Arg1);
        else
            $display("Test 5: ARG1 value fetch failed %b", DUT.Arg1);

        // Test 6: Fetch ARG2 data from RAM
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_GET_ARG2)
        HREADY_TB = 0;
        #CLK_PERIOD;
        HRDATA_TB = 8'b0000_0011; // ARG2 value
        HREADY_TB = 1;
        #CLK_PERIOD;
        if (DUT.Arg2 == 8'b0000_0011)
            $display("Test 6: ARG2 value fetch succeeded %b", DUT.Arg2);
        else
            $display("Test 6: ARG2 value fetch failed %b", DUT.Arg2);

        // Test 7: Write the result to the destination
        wait (DUT.FSM_BLOCK.NS == WAIT_FOR_WRITE_BACK)
        HREADY_TB = 0;
        #CLK_PERIOD;
        HREADY_TB = 1;
        #CLK_PERIOD;
        if (HWDATA_TB == 8'b0000_0011 && HADDR_TB == 8'b1000_0011)
            $display("Test 7: Write result succeeded %b", HWDATA_TB);
        else
            $display("Test 7: Write result failed %b", HWDATA_TB);
    end
    endtask

    always #(CLK_PERIOD/2) HCLK_TB = ~HCLK_TB;

    MASTER_TOP DUT (
        .HREADY(HREADY_TB), 
        .HRESP(HRESP_TB), 
        .HRESTn(HRESTn_TB), 
        .HCLK(HCLK_TB),
        .HRDATA(HRDATA_TB), 
        .HADDR(HADDR_TB), 
        .HWDATA(HWDATA_TB),
        .HWRITE(HWRITE_TB), 
        .HBURST(HBURST_TB),
        .HSIZE(HSIZE_TB), 
        .HTRANS(HTRANS_TB)
    );
endmodule
