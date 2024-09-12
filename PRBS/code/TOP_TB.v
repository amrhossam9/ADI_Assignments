`timescale 1us/1ns

module TOP_TB();

    reg [7:0]  IN_TB;
    reg        CLK_TB, RST_TB;
    reg  [7:0] n_pattern_TB;
    wire Pattern_Found_TB;
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
        n_pattern_TB = 8'b10;
        IN_TB = 8'h10;
        #CLK_PERIOD;
        IN_TB = 8'hAB;
        #CLK_PERIOD;
        IN_TB = 8'hCD;
        #CLK_PERIOD;
        IN_TB = 8'hEF;

        #(CLK_PERIOD*10);

        if(Pattern_Found_TB == 1)
            $display("Test passed successfully output = %h", Pattern_Found_TB);
        else
            $display("Test failed output = %h", Pattern_Found_TB);
            
        #CLK_PERIOD;

    end
    endtask
    
    TOP DUT(
        .IN(IN_TB),
        .CLK(CLK_TB),
        .RST(RST_TB),
        .n_pattern(n_pattern_TB),
        .Pattern_Found(Pattern_Found_TB)
    );

endmodule