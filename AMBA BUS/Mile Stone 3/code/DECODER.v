module decoder (
    input wire [3:0] HADDR,  // 4-bit address input
    output reg HSELx_RAM,    // Select signal for RAM
    output reg HSELx_ROM,    // Select signal for ROM
    output reg mux_select    // Mux control signal
);

    always @(*) begin
        case (HADDR[3])
            1'b0: begin  // Address range 1000 - 1111: Select ROM
                HSELx_RAM = 1'b0;
                HSELx_ROM = 1'b1;
                mux_select = 1'b0;
            end
            1'b1: begin  // Address range 0000 - 0111: Select RAM
                HSELx_RAM = 1'b1;
                HSELx_ROM = 1'b0;
                mux_select = 1'b1;
            end
        endcase
    end

endmodule
