`include "ALU_item.sv"
`include "interface.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "score_board.sv"
`include "env.sv"

module tb;
    reg CLK;

    always #10 CLK = ~CLK;
    ALU_if alu_if (CLK);
    env e;

    ALU DUT ( 
        .CLK (CLK),
        .A (alu_if.A),
        .B(alu_if.B),
        .ALU_FUN (alu_if.ALU_FUN),
      	.ALU_OUT (alu_if.ALU_OUT)
    );

    initial begin        
        $dumpvars;
        $dumpfile("dump.vcd");

        CLK = 0;

        e = new();
        e.alu_if = alu_if;
        e.run();

        #200 $finish;
    end

endmodule