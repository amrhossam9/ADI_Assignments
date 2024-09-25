module ROM (
    input  wire        HWRITE, HBURST, HSELx, HREADY,
    input  wire        HRESTn, HCLK,
    input  wire [2:0]  HSIZE, 
    input  wire [1:0]  HTRANS,
    input  wire [31:0] HADDR, HWDATA,
    output reg  [31:0] HRDATA, 
    output reg         HREADYOUT, HRESP
);

    typedef enum bit {
        IDLE = 1'b0,
        OPERATE = 1'b1
    } states;

    states PS, NS;

    typedef enum bit [2:0] {
        HSIZE_Byte = 3'b000,
        HSIZE_one_word = 3'b010
    } HSIZE_STATES;

    typedef enum bit [1:0] {
        HTRANS_IDLE = 2'b00,
        HTRANS_BUSY = 2'b01,
        HTRANS_NONSEQ = 2'b10,
        HTRANS_SEQ = 2'b11
    } HTRANS_STATES;

    typedef enum bit {
        HBURST_state_single = 0,
        HBURST_state_INCR = 1
    } HBURST_STATES;

    // Define a 32-bit wide memory with 8 words
    reg [31:0] memory [7:0];

    // Initialize memory with some data
    initial 
    begin
        memory[0] = 32'b0000_0010;
        memory[1] = 32'b0000_1001;
        memory[2] = 32'b0000_1010;
        memory[3] = 32'b0000_1011;
    end

    always @(posedge HCLK or negedge HRESTn) 
    begin
        if (!HRESTn) begin
            PS <= IDLE;
        end
        else begin
            PS <= NS;
        end
    end

    always @(*) 
    begin
        case (PS) 
            IDLE: 
            begin
                HRDATA = 32'b0; 
                HRESP = 1'b0;  // OKAY response

                // If selected and HREADY is high
                if (HREADY && HSELx && HTRANS != HTRANS_IDLE) 
                begin
                    NS = OPERATE;
                    HREADYOUT = 0;
                end
                else begin
                    NS = IDLE;
                    HREADYOUT = 1;
                end
            end

            OPERATE:
            begin
                // Read from memory when not busy, HWRITE is 0, and a byte transfer
                if (HWRITE == 0 && HSIZE == HSIZE_Byte && HTRANS != HTRANS_BUSY && HTRANS != HTRANS_IDLE && HREADY) 
                begin
                    HREADYOUT = 1;
                    HRESP = 1'b0;  // OKAY response
                    HRDATA = memory[HADDR[2:0]]; // Use lower address bits to index memory
                end
                else 
                begin
                    HREADYOUT = 0; // ROM is busy
                    HRESP = 1'b1;  // ERROR response for unsupported operation
                    HRDATA = 0;
                end

                // Handle burst transfers
                if (HBURST == HBURST_state_INCR && HTRANS != HTRANS_IDLE) begin
                    NS = OPERATE; // Continue sending during burst
                end
                else begin
                    NS = IDLE; // Go back to IDLE after single transfer
                end
            end

            default: 
                NS = IDLE;
        endcase
    end
endmodule
