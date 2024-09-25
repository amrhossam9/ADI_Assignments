module FSM (
    input wire        HREADY, HRESP, 
    input wire        HRESTn, HCLK,
    input wire [31:0] HRDATA, ALU_OUTPUT,
    output reg [31:0] HADDR, HWDATA,
    output reg        HWRITE, HBURST,
    output reg [2:0]  HSIZE, 
    output reg [1:0]  HTRANS,
    output reg [7:0]  opcode,
    output reg [31:0] Arg1, Arg2
);

    typedef enum bit [4:0] {
        IDLE         = 5'b00000,
        ROM_Address  = 5'b00001,
        FETCH_OPCODE = 5'b00010,
        FETCH_ARG1   = 5'b00011,
        FETCH_ARG2   = 5'b00100,
        FETCH_DEST   = 5'b00101,
        GET_Arg1     = 5'b00110,
        GET_Arg2     = 5'b00111,
        EXECUTE      = 5'b01000,
        WRITE_BACK   = 5'b01001,
        WAIT_FOR_OPCODE = 5'b01010,
        WAIT_FOR_ARG1 = 5'b01011,
        WAIT_FOR_ARG2 = 5'b01100,
        WAIT_FOR_DEST = 5'b01101,
        WAIT_FOR_GET_ARG1 = 5'b01110,
        WAIT_FOR_GET_ARG2 = 5'b01111,
        WAIT_FOR_WRITE_BACK = 5'b10000
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

    reg [7:0] inst_counter;
    reg [7:0] DEST, Arg_A, Arg_B;

    always @(posedge HCLK or negedge HRESTn) 
    begin
        if (!HRESTn)
        begin
            PS <= IDLE;
            inst_counter <= 0;
        end
        else
            PS <= NS;
    end

    always @(*) 
    begin
        case (PS) 
            IDLE: 
            begin
                HADDR <= 0;
                HWDATA <= 0;
                HWRITE <= 1'b0;
                HBURST <= HBURST_state_single;
                HSIZE <= 3'b000; 
                HTRANS <= HTRANS_IDLE; 
                opcode <=  0;
                Arg1 <= 0;
                Arg2 <= 0;
                if (HREADY)
                begin
                    NS <= FETCH_OPCODE;
                end
                else
                    NS <= IDLE;
            end

            FETCH_OPCODE:
            begin
                HADDR <= inst_counter;    // Set address for opcode
                HWRITE <= 0;              // Read operation
                HSIZE <= HSIZE_Byte;      // Byte-sized transfer
                HBURST <= HBURST_state_INCR;
                HTRANS <= HTRANS_NONSEQ;  // Non-sequential transfer
                
                NS <= WAIT_FOR_OPCODE;     // Move to next state to wait for HREADY
            end

            WAIT_FOR_OPCODE:
            begin
                if (HREADY)               // Wait for HREADY to go HIGH
                begin
                    opcode <= HRDATA[7:0]; // Capture opcode from HRDATA
                    NS <= FETCH_ARG1;      // Move to the next state
                end
                else
                begin
                    NS <= WAIT_FOR_OPCODE;  // Stay in this state until HREADY is HIGH
                end
            end

            FETCH_ARG1:
            begin
                HADDR <= inst_counter + 8'b1;  // Set address for Arg1
                HWRITE <= 0;                   // Read operation
                HSIZE <= HSIZE_Byte;            // Byte-sized transfer
                HBURST <= HBURST_state_INCR;
                HTRANS <= HTRANS_SEQ;           // Sequential transfer
                NS <= WAIT_FOR_ARG1;            // Wait for HREADY
            end

            WAIT_FOR_ARG1:
            begin
                if (HREADY)
                begin
                    Arg_A <= HRDATA[7:0];       // Capture Arg1
                    NS <= FETCH_ARG2;           // Move to next state
                end
                else
                begin
                    NS <= WAIT_FOR_ARG1;        // Stay in this state until HREADY is HIGH
                end
            end

            FETCH_ARG2:
            begin
                HADDR <= inst_counter + 8'b10;  // Set address for Arg2
                HWRITE <= 0;                    // Read operation
                HSIZE <= HSIZE_Byte;            // Byte-sized transfer
                HBURST <= HBURST_state_INCR;
                HTRANS <= HTRANS_SEQ;           // Sequential transfer
                NS <= WAIT_FOR_ARG2;            // Wait for HREADY
            end

            WAIT_FOR_ARG2:
            begin
                if (HREADY)
                begin
                    Arg_B <= HRDATA[7:0];       // Capture Arg2
                    NS <= FETCH_DEST;           // Move to next state
                end
                else
                begin
                    NS <= WAIT_FOR_ARG2;        // Stay in this state until HREADY is HIGH
                end
            end

            FETCH_DEST:
            begin
                HADDR <= inst_counter + 8'b11;  // Set address for destination
                HWRITE <= 0;                    // Read operation
                HSIZE <= HSIZE_Byte;            // Byte-sized transfer
                HBURST <= HBURST_state_INCR;
                HTRANS <= HTRANS_SEQ;           // Sequential transfer
                NS <= WAIT_FOR_DEST;            // Wait for HREADY
            end

            WAIT_FOR_DEST:
            begin
                if (HREADY)
                begin
                    DEST <= HRDATA[7:0];        // Capture destination address
                    NS <= GET_Arg1;             // Move to next state
                end
                else
                begin
                    NS <= WAIT_FOR_DEST;        // Stay in this state until HREADY is HIGH
                end
            end

            GET_Arg1:
            begin
                HADDR <= Arg_A;                 // Set address for Arg1
                HWRITE <= 0;                    // Read operation
                HSIZE <= HSIZE_one_word;        // Word-sized transfer
                HBURST <= HBURST_state_single;
                HTRANS <= HTRANS_NONSEQ;        // Non-sequential transfer
                NS <= WAIT_FOR_GET_ARG1;        // Wait for HREADY
            end

            WAIT_FOR_GET_ARG1:
            begin
                if (HREADY)
                begin
                    Arg1 <= HRDATA[31:0];       // Capture full word for Arg1
                    NS <= GET_Arg2;             // Move to next state
                end
                else
                begin
                    NS <= WAIT_FOR_GET_ARG1;    // Stay in this state until HREADY is HIGH
                end
            end

            GET_Arg2:
            begin
                HADDR <= Arg_B;                 // Set address for Arg2
                HWRITE <= 0;                    // Read operation
                HSIZE <= HSIZE_one_word;        // Word-sized transfer
                HBURST <= HBURST_state_single;
                HTRANS <= HTRANS_NONSEQ;        // Non-sequential transfer
                NS <= WAIT_FOR_GET_ARG2;        // Wait for HREADY
            end

            WAIT_FOR_GET_ARG2:
            begin
                if (HREADY)
                begin
                    Arg2 <= HRDATA[31:0];       // Capture full word for Arg2
                    NS <= EXECUTE;              // Move to next state
                end
                else
                begin
                    NS <= WAIT_FOR_GET_ARG2;    // Stay in this state until HREADY is HIGH
                end
            end

            EXECUTE:
            begin
                if (HREADY)
                    NS <= WRITE_BACK;           // Proceed to WRITE_BACK when ready
                else
                    NS <= EXECUTE;              // Stay in EXECUTE until HREADY is HIGH
            end

            WRITE_BACK:
            begin
                HADDR <= DEST;                  // Set destination address
                HWRITE <= 1;                    // Write operation
                HSIZE <= HSIZE_one_word;        // Word-sized transfer
                HBURST <= HBURST_state_single;
                HTRANS <= HTRANS_NONSEQ;        // Non-sequential transfer
                HWDATA <= ALU_OUTPUT;           // Write ALU result
                NS <= WAIT_FOR_WRITE_BACK;      // Wait for HREADY
            end

            WAIT_FOR_WRITE_BACK:
            begin
                if (HREADY)
                begin
                    NS <= IDLE;                 // Return to IDLE after write
                end
                else
                begin
                    NS <= WAIT_FOR_WRITE_BACK;  // Stay until HREADY is HIGH
                end
            end
            default: 
                NS <= IDLE;
        endcase
    end
endmodule