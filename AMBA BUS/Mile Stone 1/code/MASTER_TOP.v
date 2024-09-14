module MASTER_TOP (
input wire         HREADY, HRESP, 
input wire         HRESTn, HCLK,
input wire [31:0]  HRDATA,
output wire [31:0] HADDR, HWDATA,
output wire        HWRITE, HBURST,
output wire [2:0]  HSIZE, 
output wire [1:0]  HTRANS
);

wire [7:0] opcode;
wire [31:0] Arg1, Arg2, ALU_OUTPUT;

FSM FSM_BLOCK(
.HREADY(HREADY), 
.HRESP(HRESP), 
.HRESTn(HRESTn), 
.HCLK(HCLK),
.HRDATA(HRDATA), 
.ALU_OUTPUT(ALU_OUTPUT),
.HADDR(HADDR), 
.HWDATA(HWDATA),
.HWRITE(HWRITE), 
.HBURST(HBURST),
.HSIZE(HSIZE), 
.HTRANS(HTRANS),
.opcode(opcode),
.Arg1(Arg1), 
.Arg2(Arg2)
);

ALU_16bit ALU_BLOCK(
.A(Arg1),
.B(Arg2),
.ALU_FUN(opcode),
.CLK(HCLK),
.ALU_OUT(ALU_OUTPUT)
);
endmodule