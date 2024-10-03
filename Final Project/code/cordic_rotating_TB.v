`timescale 1us/1ns

module cordic_rotating_TB#(parameter WIDTH= 16)();

    localparam CLK_PERIOD = 10;
    
    reg clk_TB;
    reg rst_TB;
    reg start_TB;            
    reg signed [WIDTH-1:0] x_in_TB;
    reg signed [WIDTH-1:0] y_in_TB; 
    reg signed [WIDTH-1:0] theta_in_TB;         
    wire valid_TB;                    
    wire signed [WIDTH-1:0] x_out_TB;
    wire signed [WIDTH-1:0] y_out_TB;

    initial
    begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
        initialize();
		
        test('d256, 'd0, 'd11520); // x = 1, y = 0, theta = 45
        checkout('d181, 'd181, 'd2); // x_n = 0.7071067811865476, y_n = 0.7071067811865476
        test('d256, 'd0, 'd7680); // x = 1, y = 0, theta = 30
        checkout('d221, 'd127, 'd2); // x_n = 0.8660254037844387, y_n = 0.49999999999999994
        test('d256, 'd0, 'd15360); // x = 1, y = 0, theta = 60
        checkout('d128, 'd221, 'd2); // x_n = 0.5000000000000001, y_n = 0.8660254037844386
        test('d256, 'd0, 'd23040); // x = 1, y = 0, theta = 90
        test('d256, 'd32, 'd17152); // x = 1, y = 0.125, theta = 67
        checkout('d70, 'd248, 'd2); // x_n = 0.27566802180771866, y_n = 0.9693462445135996
        test('d256, 'd0, 'd7680); // x = 1, y = 0, theta = 30
        checkout('d221, 'd127, 'd2); // x_n = 0.8660254037844387, y_n = 0.49999999999999994
        test('d32, 'd256, 'd7680); // x = 0.125, y = 1, theta = 30
        checkout(-'d100, 'd237, 'd2); // x_n = -0.3917468245269451, y_n = 0.9285254037844387
        test('d1280, 'd3072, 'd7680); // x = 5, y = 12, theta = 30
        checkout(-'d427, 'd3300, 'd2); // x_n = -1.6698729810778055, y_n = 12.892304845413264

        #1000 $finish;
    end

    task initialize;
    begin
        clk_TB = 0;
        rst_TB = 1;
        start_TB = 0;            
        x_in_TB = 0;
        y_in_TB = 0; 
        theta_in_TB = 0; 
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
    input [WIDTH - 1:0] x_in, y_in, theta;
    begin
        rest();
        start_TB = 1;
        x_in_TB = x_in;  
        y_in_TB = y_in;    
        theta_in_TB = theta; 

        $display("x_in = %d, y_in = %d, theta = %d", x_in_TB, y_in_TB, theta_in_TB);
    end
    endtask

    task checkout;
      input signed [WIDTH - 1:0] expected_x, expected_y;
      input [WIDTH - 1:0] tolerance;
    begin
        @(posedge valid_TB);
      	#CLK_PERIOD;
        start_TB = 0;

        if ((x_out_TB >= expected_x - tolerance && x_out_TB <= expected_x + tolerance) &&
            (y_out_TB >= expected_y - tolerance && y_out_TB <= expected_y + tolerance))
          $display("Test passed x_out = %d, y_out = %d", x_out_TB,y_out_TB);
        else 
          $display("Test Failed x_out = %d, y_out = %d, expected = %d, expected = %d", x_out_TB, y_out_TB, expected_x, expected_y);
    end
    endtask

    always #(CLK_PERIOD/2) clk_TB = ~clk_TB;

    cordic_rotating DUT(
        .clk(clk_TB),
        .rst(rst_TB),
        .start(start_TB),            
        .x_in(x_in_TB), 
        .y_in(y_in_TB), 
        .theta_in(theta_in_TB),         
        .valid(valid_TB),                    
        .x_out(x_out_TB),
        .y_out(y_out_TB) 
    );

endmodule