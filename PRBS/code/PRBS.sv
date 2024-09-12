module PRBS(
    input  wire [7:0] IN,
    input  wire       CLK, RST,
    input  wire [7:0] n_pattern,
    output reg  [7:0] out
    );
    
    typedef enum bit [1:0] {
            IDLE          = 2'b00,
            TAKING_PATTERN  = 2'b01,
            OUTPUT_PATTERN = 2'b10,
            OUTPUT_RANDOM = 2'b11
    } states;
    
    states PS, NS;
    
    reg flag;
    reg  [1:0]  counter, counter_output;
    reg  [7:0]  pattern_counter;
    reg  [31:0]  pattern;
    reg  [14:0] PRBS_BLOCKS;
    reg       xor_output; 
	
    
    assign xor_output = PRBS_BLOCKS[13] ^ PRBS_BLOCKS[14];
    
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
		
        else if (counter == 2'b00 && PS == TAKING_PATTERN)
        begin
            pattern[7:0] <= IN;
            out <= IN;
            counter <= counter + 1;
        end
        else if (counter == 2'b01 && PS == TAKING_PATTERN)
        begin
            pattern[15:8] <= IN;
            out <= IN;
            counter <= counter + 1;
        end
        else if (counter == 2'b10 && PS == TAKING_PATTERN)
        begin
            pattern[23:16] <= IN;
            out <= IN;
            counter <= counter + 1;
            flag <= 1;
        end
        else if(PS == TAKING_PATTERN)
        begin
            pattern[31:24] <= IN;
            out <= IN;
            counter <= 0;
        end
    end

    always @(posedge CLK or negedge RST) 
    begin
        if (!RST)
		begin
                counter_output <= 0;
				out<='d0;
		end
        else if (counter_output == 2'b00 && PS == OUTPUT_PATTERN)
        begin
			pattern_counter <= n_pattern - 1'b1;
            out <= pattern[7:0];
            counter_output <= counter_output + 1'b1;
        end
        else if (counter_output == 2'b01 && PS == OUTPUT_PATTERN)
        begin
            out <= pattern[15:8];
            counter_output <= counter_output + 1'b1;
        end
        else if (counter_output == 2'b10 && PS == OUTPUT_PATTERN)
        begin
            out <= pattern[23:16];
            counter_output <= counter_output + 1'b1;
        end
        else if(PS == OUTPUT_PATTERN)
        begin
            out <= pattern[31:24];
            counter_output <= counter_output + 1'b1;
            pattern_counter <= pattern_counter - 1'b1;
        end
		else if (PS==OUTPUT_RANDOM)
        begin
            out <= {xor_output, PRBS_BLOCKS[6:0]};
            PRBS_BLOCKS <= {PRBS_BLOCKS[13:0], xor_output};
        end
    end
    
    always @(*) 
        begin
            case (PS) 
                IDLE: 
                begin
                    PRBS_BLOCKS = 15'b1110_1110_1010_111;
                    NS = TAKING_PATTERN;
                end

                TAKING_PATTERN:
                begin
                    if (flag)
                    begin
                        NS = OUTPUT_PATTERN;
                    end
                    else 
                        NS = TAKING_PATTERN;
                end

                OUTPUT_PATTERN:
                begin
                    if (pattern_counter == 0)
                    begin
                        NS = OUTPUT_RANDOM;
                    end
                    else
                    begin
                        NS = OUTPUT_PATTERN;
                    end
                end
				
                OUTPUT_RANDOM:
                begin         
                    NS = OUTPUT_RANDOM;
                end
                default:
                    NS = IDLE;
            endcase
        end


endmodule
