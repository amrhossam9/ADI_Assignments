module ALU(
    input wire [3:0]  A, B,
    input wire [1:0]  ALU_FUN,
    input wire        CLK,
    output reg [7:0]  ALU_OUT
);


    always @(*) begin
        case(ALU_FUN)
            2'b00:  ALU_OUT = A + B;
            2'b01:  ALU_OUT = A - B;
            2'b10:  ALU_OUT = A * B;
            2'b11:  ALU_OUT = A / B; 
            default: ALU_OUT = 8'b0;
        endcase
    end

endmodule
