module RAM (
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

    // Define a 32-bit wide memory with 8 words (size can be adjusted as needed)
    reg [31:0] memory [7:0];

    // Initialize memory to zero or some known state (optional)
    initial 
    begin
        memory[0] = 32'b01;
        memory[1] = 32'b10;
        memory[2] = 32'b11;
    end

    // State Machine: Handles transitioning between IDLE and OPERATE
    always @(posedge HCLK or negedge HRESTn) 
    begin
        if (!HRESTn)
            PS <= IDLE;
        else
            PS <= NS;
    end

    // Next State and Output Logic
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
                    HREADYOUT = 0;  // Indicate the RAM is processing
                end
                else 
                begin
                    NS = IDLE;
                    HREADYOUT = 1;  // Ready for a new transaction
                end
            end

            OPERATE:
            begin
                if (HWRITE && HSIZE == HSIZE_one_word && HTRANS != HTRANS_BUSY && HTRANS != HTRANS_IDLE && HREADY) 
                begin
                    // Write to memory when HWRITE is asserted
                    memory[HADDR[2:0]] = HWDATA;  // Use lower address bits to index memory
                    HRESP = 1'b0;  // OKAY response
                    HREADYOUT = 1; // Indicate transaction complete
                end
                else if (!HWRITE && HSIZE == HSIZE_one_word && HTRANS != HTRANS_BUSY && HTRANS != HTRANS_IDLE && HREADY) 
                begin
                    // Read from memory when HWRITE is de-asserted
                    HRDATA = memory[HADDR[2:0]];  // Use lower address bits to index memory
                    HRESP = 1'b0;  // OKAY response
                    HREADYOUT = 1; // Indicate transaction complete
                end
                else 
                begin
                    HREADYOUT = 0; // RAM is busy
                end

                // Handle burst transactions
                if (HBURST == HBURST_state_INCR && HTRANS != HTRANS_IDLE) 
                begin
                    NS = OPERATE; // Continue during burst
                end
                else 
                begin
                    NS = IDLE;  // Return to IDLE after single transaction
                end
            end

            default: 
                NS = IDLE;
        endcase
    end
endmodule
