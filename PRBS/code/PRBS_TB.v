`timescale 1us/1ns

module PRBS_TB();

    reg [7:0]  IN_TB;
    reg        CLK_TB, RST_TB;
    reg  [7:0] n_pattern_TB;
    wire [7:0] out_TB;
    parameter CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB;

    initial 
    begin
        $dumpfile("PRBS_Dump.vcd") ;       
        $dumpvars; 
        initialize();
        TEST();
        #100
        $finish;
    end

    task initialize;
    begin
        IN_TB = 8'b0;
        CLK_TB= 0;
        n_pattern_TB = 8'b0;
    end
    endtask

    task rest;
    begin
        RST_TB = 1'b0; 
        #CLK_PERIOD;
        RST_TB = 1'b1; 
        #CLK_PERIOD;
    end
    endtask
    task TEST;
    begin
        rest();
        n_pattern_TB = 8'b01;
        IN_TB = 8'h10;
        #CLK_PERIOD;
        IN_TB = 8'hAB;
        #CLK_PERIOD;
        IN_TB = 8'hCD;
        #CLK_PERIOD;
        IN_TB = 8'hEF;

        #CLK_PERIOD;
        #CLK_PERIOD;
        
        if(out_TB == 8'h10)
            $display("Byte 1 generated successfully output = %h", out_TB);
        else
            $display("Byte 1 generated unsuccessfully output = %h", out_TB);
            
        #CLK_PERIOD;
            
        if(out_TB == 8'hAB)
            $display("Byte 2 generated successfully output = %h", out_TB);
        else
            $display("Byte 2 generated unsuccessfully output = %h", out_TB);
            
        #CLK_PERIOD;
                        
        if(out_TB == 8'hCD)
            $display("Byte 3 generated successfully output = %h", out_TB);
        else
            $display("Byte 3 generated unsuccessfully output = %h", out_TB);
            
        #CLK_PERIOD;
                            
        if(out_TB == 8'hEF)
            $display("Byte 4 generated successfully output = %h", out_TB);
        else
            $display("Byte 4 generated unsuccessfully output = %h", out_TB);
            
        #CLK_PERIOD;

    end
    endtask
    
    PRBS DUT(
        .IN(IN_TB),
        .CLK(CLK_TB),
        .RST(RST_TB),
        .n_pattern(n_pattern_TB),
        .out(out_TB)
    );

endmodule