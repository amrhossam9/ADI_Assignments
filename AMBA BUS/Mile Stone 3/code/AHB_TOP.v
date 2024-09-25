module AHB_TOP (
    input wire HCLK,
    input wire HRESTn
);

        wire         HREADY, HRESP;
        wire [31:0]  HRDATA;
        wire [31:0]  HADDR, HWDATA;
        wire         HWRITE, HBURST;
        wire [2:0]   HSIZE;
        wire [1:0]   HTRANS;
        wire         HSELx_RAM, HSELx_ROM, mux_select;
        wire         HREADYOUT_RAM, HREADYOUT_ROM;
        wire         RAM_HREADY, RAM_HRESP;
        wire         ROM_HREADY, ROM_HRESP;
        wire  [31:0] RAM_HRDATA, ROM_HRDATA;

    MASTER_TOP u_master (
        .HREADY(HREADY), 
        .HRESP(HRESP), 
        .HRESTn(HRESTn), 
        .HCLK(HCLK),
        .HRDATA(HRDATA),
        .HADDR(HADDR), 
        .HWDATA(HWDATA),
        .HWRITE(HWRITE), 
        .HBURST(HBURST),
        .HSIZE(HSIZE), 
        .HTRANS(HTRANS)
    );
    
    RAM u_ram (
        .HWRITE(HWRITE), 
        .HBURST(HBURST), 
        .HSELx(HSELx_RAM), 
        .HREADY(1'b1),
        .HRESTn(HRESTn), 
        .HCLK(HCLK),
        .HSIZE(HSIZE), 
        .HTRANS(HTRANS),
        .HADDR(HADDR), 
        .HWDATA(HWDATA),
        .HRDATA(RAM_HRDATA), 
        .HREADYOUT(HREADYOUT_RAM), 
        .HRESP(RAM_HRESP)
    );

    ROM u_rom (
        .HWRITE(HWRITE), 
        .HBURST(HBURST), 
        .HSELx(HSELx_ROM), 
        .HREADY(1'b1),
        .HRESTn(HRESTn), 
        .HCLK(HCLK),
        .HSIZE(HSIZE), 
        .HTRANS(HTRANS),
        .HADDR(HADDR), 
        .HWDATA(HWDATA),
        .HRDATA(ROM_HRDATA), 
        .HREADYOUT(HREADYOUT_ROM), 
        .HRESP(ROM_HRESP)
    );

    decoder u_decoder (
        .HADDR(HADDR[3:0]),       
        .HSELx_RAM(HSELx_RAM),
        .HSELx_ROM(HSELx_ROM),
        .mux_select(mux_select)
    );

    MUX u_mux (
        .mux_select(mux_select),
        .RAM_HREADY(HREADYOUT_RAM),
        .RAM_HRESP(RAM_HRESP),
        .ROM_HREADY(HREADYOUT_ROM),
        .ROM_HRESP(ROM_HRESP),
        .RAM_HRDATA(RAM_HRDATA),
        .ROM_HRDATA(ROM_HRDATA),
        .HRDATA(HRDATA),
        .HREADY(HREADY),
        .HRESP(HRESP)
    );

endmodule
