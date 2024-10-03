`timescale 1us/1ns

module cordic_vectoring_TB#(parameter WIDTH= 16)();

    localparam CLK_PERIOD = 10;
    
    reg clk_TB;
    reg rst_TB;
    reg start_TB;            
    reg signed [WIDTH-1:0] x_in_TB;
    reg signed [WIDTH-1:0] y_in_TB; 
    wire valid_TB;                    
    wire signed [WIDTH-1:0] x_out_TB;
    wire signed [WIDTH-1:0] z_out_TB;

    initial
    begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
        initialize();
		
        test('d1024, 'd1536); // x = 4, y = 6
        checkout('d1846, 'd14415, 'd0); // x_n = 7.211102550927978, theta = 56.309932474020215
        test('d256, 'd512); // x = 1, y = 2
        checkout('d572, 'd16239, 'd0); // x_n = 2.23606797749979, theta = 63.43494882292201
        test('d768, 'd1024); // x = 3, y = 4
        checkout('d1280, 'd13601, 'd0); // x_n = 5.0, theta = 53.13010235415598
        test('d1280, 'd2304); // x = 5, y = 9
        checkout('d2635, 'd15602, 'd0); // x_n = 10.295630140987, theta = 60.94539590092286
        test('d1536, 'd1792); // x = 6, y = 7
        checkout('d2360, 'd12646, 'd0); // x_n = 9.219544457292887, theta = 49.398705354995535
        test('d427, 'd0); // x = 1.67, y = 0
        checkout('d427, 'd0, 'd0); // x_n = 1.67, theta = 0.0
        test('d256, 'd0); // x = 1, y = 0
        checkout('d256, 'd0, 'd0); // x_n = 1.0, theta = 0.0

        #1000 $finish;
    end

    task initialize;
    begin
        clk_TB = 0;
        rst_TB = 1;
        start_TB = 0;            
        x_in_TB = 0;
        y_in_TB = 0; 
    end
    endtask

    task rest;
    begin
        rst_TB = 'b1;
        #CLK_PERIOD;
        rst_TB = 'b0;
        #CLK_PERIOD;
        rst_TB = 'b1;
    end
    endtask

    task test;
    input [WIDTH - 1:0] x_in, y_in;
    begin
        rest();
        start_TB = 1;
        x_in_TB = x_in;  
        y_in_TB = y_in;    

        $display("x_in = %d, y_in = %d", x_in_TB, y_in_TB);
    end
    endtask

    task checkout;
      input signed [WIDTH - 1:0] expected_x, expected_z;
      input [WIDTH - 1:0] tolerance;
    begin
        @(posedge valid_TB);
      	#CLK_PERIOD;
        start_TB = 0;

        if ((x_out_TB >= expected_x - tolerance && x_out_TB <= expected_x + tolerance) &&
            (z_out_TB >= expected_z - tolerance && z_out_TB <= expected_z + tolerance))
          $display("Test passed x_out = %d, z_out = %d", x_out_TB,z_out_TB);
        else 
          $display("Test Failed x_out = %d, z_out = %d, expected = %d, expected = %d", x_out_TB, z_out_TB, expected_x, expected_z);
    end
    endtask

    always #(CLK_PERIOD/2) clk_TB = ~clk_TB;

    cordic_vectoring DUT(
        .clk(clk_TB),
        .rst(rst_TB),
        .start(start_TB),            
        .x_in(x_in_TB), 
        .y_in(y_in_TB), 
        .valid(valid_TB),                    
        .x_out(x_out_TB),
        .z_out(z_out_TB) 
    );

endmodule