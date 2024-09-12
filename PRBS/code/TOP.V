module TOP (
    input  wire [7:0] IN,
    input  wire       CLK, RST,
    input  wire [7:0] n_pattern,
    output wire  Pattern_Found
);

    wire [7:0] Inner_conn;
    PATTERN_DEDECTOR PATTERN_DEDECTOR_BLOCK(
        .CLK(CLK), 
        .RST(RST),
        .IN(Inner_conn),
        .n_pattern(n_pattern),
        .Pattern_Found(Pattern_Found)    
    );

    PRBS PRBS_BLOCK(
        .IN(IN),
        .CLK(CLK), 
        .RST(RST),
        .n_pattern(n_pattern),
        .out(Inner_conn)
    );
endmodule