`timescale 1ns/1ps

module Filter_TB ();

    reg [7:0] x_TB;
    reg CLK_TB, RST_TB;
    wire [7:0] y_TB;

    parameter CLK_PERIOD = 10;
    parameter N = 100;
    parameter DATA_LENGTH = 8; 
    integer operations;

    reg [DATA_LENGTH - 1:0] Test_Inputs [N - 1:0];
    reg [DATA_LENGTH - 1:0] Expec_Outs [N - 1:0];

    initial begin
        $dumpfile("Filter_DUMP.vcd") ;       
        $dumpvars; 
        
        $readmemh("input.txt", Test_Inputs);
        $readmemh("output.txt", Expec_Outs);

        initialize();

        for (operations = 0; operations < N; operations = operations + 1) 
        begin
            do_operation(Test_Inputs[operations], operations);
            checkout(Expec_Outs[operations], operations);
        end

        #100;
        $finish;
    end

    task initialize;
    begin
        CLK_TB = 0;
        x_TB = 0;
        rest();
    end
    endtask

    task rest;
    begin
        RST_TB = 'b1;
        #CLK_PERIOD;
        RST_TB = 'b0;
        #CLK_PERIOD;
        RST_TB = 'b1;
    end
    endtask

    task do_operation;
    input reg [DATA_LENGTH - 1:0] INPUT_TEST;
    input integer operation_number;
    begin
        x_TB = INPUT_TEST;
        #CLK_PERIOD;

        $display("input = %h", INPUT_TEST);
    end
    endtask

    task checkout;
    input reg [DATA_LENGTH - 1:0] expected_output;
    input integer operation_number;
    reg [DATA_LENGTH - 1:0] general_output;
    begin
        general_output = y_TB;

        if (expected_output == general_output)
        begin
            $display("Test %d succedded %h", operation_number + 1,general_output);
        end
        else
        begin
            $display("Test %d failed %h", operation_number + 1,general_output);
        end
    end
    endtask

    always #(CLK_PERIOD/2) CLK_TB = ~CLK_TB;

    Filter DUT(
        .x(x_TB),
        .CLK(CLK_TB),
        .RST(RST_TB),
        .y(y_TB)
    );


endmodule