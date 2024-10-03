module cordic_rotating #(
    parameter WIDTH = 32,        // Number of bits for fixed-point representation
    parameter ITERATIONS = 15    // Number of iterations
)(
    input wire clk,
    input wire rst,
    input wire start,            // Signal to start CORDIC operation
    input wire signed [WIDTH-1:0] x_in,  // Input vector X as fixed-point
    input wire signed [WIDTH-1:0] y_in,  // Input vector Y as fixed-point
    input wire signed [WIDTH-1:0] theta_in, // Angle in fixed-point radians
    output reg valid,             // valid signal during CORDIC operation
    output reg signed [WIDTH-1:0] x_out,   // Final X after rotation as fixed-point
    output reg signed [WIDTH-1:0] y_out    // Final Y after rotation as fixed-point
);

    // Precomputed arctangents in fixed-point representation (scaled by 2^16)
    reg signed [WIDTH-1:0] atan_table [0:ITERATIONS-1]; 

    reg signed [WIDTH-1:0] x_reg, y_reg;   // Registers to hold intermediate X, Y values
    reg signed [WIDTH-1:0] z_reg;          // Register for intermediate angle (theta)
    reg [3:0] iter;                        // Iteration counter
    reg busy;

    // Populate arctangent table with fixed-point values (scaled by 2^16)
    initial begin
        atan_table[0] = 16'd11520;     // atan(2^-0)
        atan_table[1] = 16'd6801;     // atan(2^-1)
        atan_table[2] = 16'd3593;     // atan(2^-2)
        atan_table[3] = 16'd1824;     // atan(2^-3)
        atan_table[4] = 16'd916;     // atan(2^-4)
        atan_table[5] = 16'd458;     // atan(2^-5)
        atan_table[6] = 16'd229;     // atan(2^-6)
        atan_table[7] = 16'd115;     // atan(2^-7)
        atan_table[8] = 16'd57;     // atan(2^-8)
        atan_table[9] = 16'd29;     // atan(2^-9)
        atan_table[10] = 16'd14;     // atan(2^-10)
        atan_table[11] = 16'd7;     // atan(2^-11)
        atan_table[12] = 16'd4;     // atan(2^-12)
        atan_table[13] = 16'd2;     // atan(2^-13)
        atan_table[14] = 16'd1;     // atan(2^-14)
    end

    // Sequential logic
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            valid <= 1'b0;
            busy <= 1'b0;
            iter <= 4'd0;
            x_out <= 0;
            y_out <= 0;
        end
        else if (start && !busy) begin
            busy <= 1'b1;
            iter <= 4'd0;
            x_reg <= x_in;    // Initialize X in fixed-point
            y_reg <= y_in;    // Initialize Y in fixed-point
            z_reg <= - theta_in; // Initialize angle in fixed-point
            valid <= 1'b0;
        end
        else if (busy) begin
            if (iter != ITERATIONS) begin // Loop until iterations are done
                if (z_reg >= 0) begin
                    // Rotate clockwise (positive)
                    x_reg <= x_reg - (y_reg >>> iter); // Right shift to divide by 2^iter
                    y_reg <= y_reg + (x_reg >>> iter); // Right shift to divide by 2^iter
                    z_reg <= z_reg - atan_table[iter]; // Update angle
                end
                else begin
                    // Rotate counterclockwise (negative)
                    x_reg <= x_reg + (y_reg >>> iter); // Right shift to divide by 2^iter
                    y_reg <= y_reg - (x_reg >>> iter); // Right shift to divide by 2^iter
                    z_reg <= z_reg + atan_table[iter]; // Update angle
                end
                iter <= iter + 1; // Increment iteration counter
            end
            else begin
                // CORDIC completed
                valid <= 1'b1;
                busy <= 1'b0;
                x_out <= (x_reg << 8) / 421;  
                y_out <= (y_reg << 8) / 421; 
            end
        end
        else begin
            valid <= 1'b0;
        end
    end
endmodule
