`timescale 1us/1ns

module TOP_TB#(parameter DATA_WIDTH= 32)();

    localparam CLK_PERIOD = 10;
    
    reg clk_TB;
    reg rst_TB;
    reg start_TB;            
	reg  [DATA_WIDTH-1:0]  ip_matrix_TB [0:2] [0:2];
    wire [DATA_WIDTH-1:0]  op_matrix_TB [0:2] [0:2];
	wire done_TB;

    reg [DATA_WIDTH-1:0]  op_tmp [0:2] [0:2];

    initial
    begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
        initialize();
        rest();

        ip_matrix_TB[0][0] = 256;
        ip_matrix_TB[0][1] = 256;
        ip_matrix_TB[0][2] = 256;
        ip_matrix_TB[1][0] = 0;
        ip_matrix_TB[1][1] = 256;
        ip_matrix_TB[1][2] = 256;
        ip_matrix_TB[2][0] = 256;
        ip_matrix_TB[2][1] = 256;
        ip_matrix_TB[2][2] = 0;

        op_tmp[0][0] = 256;
        op_tmp[0][1] = -256;
        op_tmp[0][2] = 0;
        op_tmp[1][0] = -256;
        op_tmp[1][1] = 256;
        op_tmp[1][2] = 256;
        op_tmp[2][0] = 256;
        op_tmp[2][1] = 0;
        op_tmp[2][2] = -256;

        checkout(op_tmp, 10);

        ip_matrix_TB[0][0] = 256;
        ip_matrix_TB[0][1] = 0;
        ip_matrix_TB[0][2] = 0;
        ip_matrix_TB[1][0] = 0;
        ip_matrix_TB[1][1] = 256;
        ip_matrix_TB[1][2] = 0;
        ip_matrix_TB[2][0] = 0;
        ip_matrix_TB[2][1] = 0;
        ip_matrix_TB[2][2] = 256;

        op_tmp[0][0] = 256;
        op_tmp[0][1] = 0;
        op_tmp[0][2] = 0;
        op_tmp[1][0] = 0;
        op_tmp[1][1] = 256;
        op_tmp[1][2] = 0;
        op_tmp[2][0] = 0;
        op_tmp[2][1] = 0;
        op_tmp[2][2] = 256;

        checkout(op_tmp, 10);

        ip_matrix_TB[0][0] = 256;
        ip_matrix_TB[0][1] = 0;
        ip_matrix_TB[0][2] = 0;
        ip_matrix_TB[1][0] = 0;
        ip_matrix_TB[1][1] = 256;
        ip_matrix_TB[1][2] = 256;
        ip_matrix_TB[2][0] = 0;
        ip_matrix_TB[2][1] = 0;
        ip_matrix_TB[2][2] = 256;

        op_tmp[0][0] = 256;
        op_tmp[0][1] = 0;
        op_tmp[0][2] = 0;
        op_tmp[1][0] = 0;
        op_tmp[1][1] = 256;
        op_tmp[1][2] = -256;
        op_tmp[2][0] = 0;
        op_tmp[2][1] = 0;
        op_tmp[2][2] = 256;

        checkout(op_tmp, 10);

        ip_matrix_TB[0][0] = 512;
        ip_matrix_TB[0][1] = 0;
        ip_matrix_TB[0][2] = 0;
        ip_matrix_TB[1][0] = 0;
        ip_matrix_TB[1][1] = 768;
        ip_matrix_TB[1][2] = 256;
        ip_matrix_TB[2][0] = 0;
        ip_matrix_TB[2][1] = 0;
        ip_matrix_TB[2][2] = 256;

        op_tmp[0][0] = 128;
        op_tmp[0][1] = 0;
        op_tmp[0][2] = 0;
        op_tmp[1][0] = 0;
        op_tmp[1][1] = 85;
        op_tmp[1][2] = -85;
        op_tmp[2][0] = 0;
        op_tmp[2][1] = 0;
        op_tmp[2][2] = 256;

        checkout(op_tmp, 10);

        #100 $finish;
    end

    task initialize;
    begin
        clk_TB = 0;
        rst_TB = 1;
        start_TB = 0;            
        for (integer i=0; i<3; ++i) begin
				ip_matrix_TB[0][i] <= 0;
				ip_matrix_TB[1][i] <= 0;
				ip_matrix_TB[2][i] <= 0;
			end
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

    task checkout;
        input [DATA_WIDTH-1:0]  op_matrix [0:2] [0:2];
        input [DATA_WIDTH - 1:0] tolerance;

        reg flag;
    begin
        flag = 1;
        start_TB = 1;
        @(posedge done_TB)
        start_TB = 0;

        #(CLK_PERIOD);

        for(integer i = 0; i < 3; i = i + 1)
        begin
            for (integer j = 0; j < 3; j = j + 1) 
            begin
                if (op_matrix_TB[i][j] < op_matrix[i][j] - tolerance && op_matrix_TB[i][j] > op_matrix[i][j] + tolerance)
                    flag = 0;
            end
        end

        if (flag)
            $display("Test passed");
        else 
            $display("Test Failed");
    end
    endtask

    always #(CLK_PERIOD/2) clk_TB = ~clk_TB;

    TOP DUT(
        .CLK(clk_TB),
        .RST(rst_TB),
        .start(start_TB),            
        .ip_matrix(ip_matrix_TB), 
        .op_matrix(op_matrix_TB), 
        .done(done_TB)
    );

endmodule