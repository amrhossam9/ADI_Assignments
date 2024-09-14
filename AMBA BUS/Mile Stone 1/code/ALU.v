module ALU_16bit(
    input wire [31:0] A,B,
    input wire [7:0]  ALU_FUN,
    input wire        CLK,
    output reg [31:0] ALU_OUT
    );
            
    always @(*)
    begin
        case(ALU_FUN)
            8'b0000_0000: begin
                        ALU_OUT <= A+B;
                     end
            8'b0000_0001: begin
                        ALU_OUT <= A-B;
                     end
            8'b0000_0010: begin
                        ALU_OUT <= A*B;
                     end
            8'b0000_0011: begin
                        ALU_OUT <= A/B;
                     end
            8'b0000_0100: begin
                        ALU_OUT <= A&B;
                     end
            8'b0000_0101: begin
                        ALU_OUT <= A|B;
                     end
            8'b0000_0110: begin
                        ALU_OUT <= ~(A&B);
                     end
            8'b0000_0111: begin
                        ALU_OUT <= ~(A|B);
                     end   
            8'b0000_1000: begin
                        ALU_OUT <= A^B;
                     end
            8'b0000_1001: begin
                        ALU_OUT <= ~(A^B);
                     end
            8'b0000_1010: begin
                        ALU_OUT <= (A==B);
                     end
            8'b0000_1011: begin
                        ALU_OUT <= (A>B);
                     end
            8'b0000_1100: begin
                        ALU_OUT <= (A<B);
                     end                               
             default: begin
                        ALU_OUT <= 0'b0; 
                    end 
        endcase
    end
endmodule
