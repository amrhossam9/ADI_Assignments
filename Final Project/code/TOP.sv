    module TOP #(parameter DATA_WIDTH=32)(
        input RST,CLK,start,
        input [DATA_WIDTH-1:0]  ip_matrix [0:2] [0:2],
        output signed [DATA_WIDTH-1:0]  op_matrix [0:2] [0:2],
        output done
    );

    wire [DATA_WIDTH-1:0] x_vict,theta_vict;
    wire valid_vict;
    wire [DATA_WIDTH-1:0] x_rot,y_rot;
    wire valid_rot;
    wire [DATA_WIDTH-1:0] sin_rot,cos_rot;
    wire valid_angle;

    wire [DATA_WIDTH-1:0] x0_vict,y0_vict;
    wire start_vict;
    wire [DATA_WIDTH-1:0] x0_rot,y0_rot,theta_rot;
    wire start_rot;
    wire [DATA_WIDTH-1:0] theta_q;
    wire start_q;

    FSM FSM_U0 (
        .RST(RST),
        .CLK(CLK),
        .start(start),
        .ip_matrix(ip_matrix),

        .x_vict(x_vict),
        .theta_vict(theta_vict),
        .valid_vict(valid_vict),
        .x_rot(x_rot),
        .y_rot(y_rot),
        .valid_rot(valid_rot),
        .sin_rot(sin_rot),
        .cos_rot(cos_rot),
        .valid_angle(valid_angle),

        .op_matrix(op_matrix),
        .done(done),
        .x0_vict(x0_vict),
        .y0_vict(y0_vict),
        .start_vict(start_vict),
        .x0_rot(x0_rot),
        .y0_rot(y0_rot),
        .theta_rot(theta_rot),
        .start_rot(start_rot),
        .theta_q(theta_q),
        .start_q(start_q)
    );

    cordic_rotating cordic_rotating_U0(
        .clk(CLK),
        .rst(RST),
        .start(start_rot),           
        .x_in(x0_rot),  
        .y_in(y0_rot),  
        .theta_in(theta_rot),
        .valid(valid_rot),             
        .x_out(x_rot), 
        .y_out(y_rot)   
    );

    cordic_rotating cordic_rotating_U1(
        .clk(CLK),
        .rst(RST),
        .start(start_q),           
        .x_in(32'd256),  
        .y_in(32'b0),  
        .theta_in(theta_q),
        .valid(valid_angle),             
        .x_out(cos_rot), 
        .y_out(sin_rot)   
    );

    cordic_vectoring cordic_vectoring_U0(
        .clk(CLK),
        .rst(RST),
        .start(start_vict), 
        .x_in(x0_vict), 
        .y_in(y0_vict), 
        .valid(valid_vict),                   
        .x_out(x_vict), 
        .z_out(theta_vict)    
    );

endmodule