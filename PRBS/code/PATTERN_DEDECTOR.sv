module PATTERN_DEDECTOR (
    input  wire       CLK, RST,
    input wire [7:0] IN,
    input  wire [7:0] n_pattern,
    output reg Pattern_Found
);

    typedef enum bit [2:0] {
            IDLE          = 3'b000,
            WAIT_STATE    = 3'b001,
            TAKING_PATTERN  = 3'b010,
            CHECKING_PATTERN = 3'b011,
            SUCCEDD = 3'b100
    } states;
    
    states PS, NS;

    reg  [1:0]  counter, counter_output;
    reg  [31:0]  pattern;
    reg [7:0] pattern_counter;
    reg flag;

    always @(posedge CLK or negedge RST) 
    begin
        if (!RST)
            PS <= IDLE;
        else
            PS <= NS;
    end

    always @(posedge CLK or negedge RST) 
    begin
        flag <= 0;
        if (!RST) begin
                counter <= 0;
				pattern <= 32'd0;
		end
		
        else if (counter == 2'b00 && PS == TAKING_PATTERN && flag == 0)
        begin
            pattern[7:0] <= IN;
            pattern_counter <= n_pattern;
            counter <= counter + 1;
        end
        else if (counter == 2'b01 && PS == TAKING_PATTERN)
        begin
            pattern[15:8] <= IN;
            counter <= counter + 1;
        end
        else if (counter == 2'b10 && PS == TAKING_PATTERN)
        begin
            pattern[23:16] <= IN;
            counter <= counter + 1;
            flag <= 1;
        end
        else if(PS == TAKING_PATTERN)
        begin
            pattern[31:24] <= IN;
            counter <= 0;
            pattern_counter <= pattern_counter - 1'b1;
        end
    end

    always @(posedge CLK or negedge RST) 
    begin
        if (!RST)
		begin
                counter_output <= 0;
		end
        else if (counter_output == 2'b00 && PS == CHECKING_PATTERN && IN == pattern[7:0])
        begin
            counter_output <= counter_output + 1'b1;
        end
        else if (counter_output == 2'b01 && PS == CHECKING_PATTERN && IN == pattern[15:8])
        begin
            counter_output <= counter_output + 1'b1;
        end
        else if (counter_output == 2'b10 && PS == CHECKING_PATTERN && IN == pattern[23:16])
        begin
            counter_output <= counter_output + 1'b1;
        end
        else if(PS == CHECKING_PATTERN && IN == pattern[31:24])
        begin
            counter_output <= counter_output + 1'b1;
            // pattern_counter <= pattern_counter - 1'b1;
        end
    end

    always @(*) 
        begin
            case (PS) 
                IDLE: 
                begin
                    // counter = 2'b00;
                    // pattern_counter = n_pattern;
                    // Pattern_Found = 0;
                    // pattern = 0;
                    NS = WAIT_STATE;
                end
                WAIT_STATE:
                begin
                    NS = TAKING_PATTERN;
                end
                TAKING_PATTERN:
                begin
                    if (flag)
                    begin
                        NS = CHECKING_PATTERN;
                    end
                    else 
                        NS = TAKING_PATTERN;
                end

                CHECKING_PATTERN:
                begin
                    if (pattern_counter == 1)
                    begin
                        NS = SUCCEDD;
                    end
                    else 
                        NS = CHECKING_PATTERN;
                end

                SUCCEDD:
                begin         
                    Pattern_Found = 1;
                end
                default:
                    NS = IDLE;
            endcase
        end
endmodule