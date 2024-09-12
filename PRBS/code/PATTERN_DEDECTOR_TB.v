`timescale 1us/1ns

module PATTERN_DEDECTOR_TB();

    reg [7:0]  IN_TB;
    reg        CLK_TB, RST_TB;
    reg  [7:0] n_pattern_TB;
    wire       Pattern_Found_TB;
    parameter CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB;

    initial 
    begin
        $dumpfile("PATTERN_DEDECTOR_Dump.vcd") ;       
        $dumpvars; 
        initialize();
        TEST1();
        TEST2();
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
    task TEST1;
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
        #CLK_PERIOD;
        IN_TB = 8'h10;
        #CLK_PERIOD;
        IN_TB = 8'hAB;
        #CLK_PERIOD;
        IN_TB = 8'hCD;
        #CLK_PERIOD;
        IN_TB = 8'hEF;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;

        if(Pattern_Found_TB == 1)
            $display("Test passed successfully output = %h", Pattern_Found_TB);
        else
            $display("Test failed output = %h", Pattern_Found_TB);
            
        
        #CLK_PERIOD;

    end
    endtask

    task TEST2;
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
        #CLK_PERIOD;        
        IN_TB = 8'h10;
        #CLK_PERIOD;
        IN_TB = 8'hAB;
        #CLK_PERIOD;
        IN_TB = 8'hCD;
        #CLK_PERIOD;
        IN_TB = 8'h1F;
        #CLK_PERIOD;
        #CLK_PERIOD;    
        #CLK_PERIOD;
    
        if(Pattern_Found_TB == 0)
            $display("Test passed successfully output = %h", Pattern_Found_TB);
        else
            $display("Test failed output = %h", Pattern_Found_TB);
            
        
        #CLK_PERIOD;

    end
    endtask
    
    PATTERN_DEDECTOR DUT(
        .IN(IN_TB),
        .CLK(CLK_TB),
        .RST(RST_TB),
        .n_pattern(n_pattern_TB),
        .Pattern_Found(Pattern_Found_TB)
    );

endmodule