module Filter (
    input  wire [7:0] x,
    input  wire CLK, RST,
    output reg  [7:0] y
);

    reg [7:0] registers [2:0];
    wire [7:0] val0, val1, val2;

    assign val0 = registers[0] >> 1;
    assign val1 = registers[1] >> 2;
    assign val2 = registers[2] >> 3;

    always @(posedge CLK or negedge RST) 
    begin

        if(!RST)
        begin
            registers[0] <= 0;
            registers[1] <= 0;
            registers[2] <= 0;
            y <= 0;
        end
        else
        begin
            y <= (x + val0 + val1 + val2);
            registers[2] <= registers[1];
            registers[1] <= registers[0];
            registers[0] <= x;
        end
    end

endmodule