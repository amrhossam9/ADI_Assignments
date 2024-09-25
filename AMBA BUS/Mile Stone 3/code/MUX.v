module MUX (
    input wire mux_select,
    input wire RAM_HREADY, RAM_HRESP,
    input wire ROM_HREADY, ROM_HRESP,
    input wire  [31:0] RAM_HRDATA, ROM_HRDATA,
    output reg  [31:0] HRDATA,
    output reg HREADY, HRESP
);

    always @(*) begin

        HRDATA = 32'b0;
        HREADY = 1'b0;
        HRESP = 1'b0;

        case (mux_select)
            1'b0: begin 
                HREADY = ROM_HREADY;
                HRESP = ROM_HRESP;
                HRDATA = ROM_HRDATA;
            end
            1'b1: begin  
                HREADY = RAM_HREADY;
                HRESP = RAM_HRESP;
                HRDATA = RAM_HRDATA;
            end
        endcase

    end

endmodule