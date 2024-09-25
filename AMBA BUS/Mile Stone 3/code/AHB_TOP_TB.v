module AHB_TOP_TB ();

    // Signals for master control
    reg HCLK_TB, HRESTn_TB;

    parameter CLK_PERIOD = 10;

    initial 
    begin
        $dumpfile("AHB_TOP_Dump.vcd");
        $dumpvars;
        initialize();
        TEST();
        #200;
        $finish;
    end

    task initialize;
    begin
        HCLK_TB = 0; 
        HRESTn_TB = 1'b0;
    end
    endtask

    task reset;
    begin
        HRESTn_TB = 1'b0;
        #CLK_PERIOD;
        HRESTn_TB = 1'b1;
    end
    endtask

    task TEST;
    begin
        reset(); 

        #(100*CLK_PERIOD);
    end
    endtask

    always #(CLK_PERIOD/2) HCLK_TB = ~HCLK_TB;

    AHB_TOP uut (
        .HCLK(HCLK_TB),
        .HRESTn(HRESTn_TB)
    );

endmodule
