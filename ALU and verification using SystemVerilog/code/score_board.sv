class score_board;
    mailbox scb_mbx;
    int passed_test_cases;
    int failed_test_cases;
    bit [7:0] expected_ALU_OUT;
    task run();
        ALU_item item;
        forever begin
            scb_mbx.get(item);

            case (item.ALU_FUN)
                2'b00: expected_ALU_OUT = item.A + item.B;
                2'b01: expected_ALU_OUT = item.A - item.B;
                2'b10: expected_ALU_OUT = item.A * item.B;
                2'b11: expected_ALU_OUT = item.A / item.B;
                default: expected_ALU_OUT = 8'b0;
            endcase

            if (expected_ALU_OUT == item.ALU_OUT) begin
            passed_test_cases++;
            $display("Test Passed: A = %0d, B = %0d, ALU_FUN = %0d, Expected = %0d, Actual = %0d",
                      item.A, item.B, item.ALU_FUN, expected_ALU_OUT, item.ALU_OUT);
            end else begin
            failed_test_cases++;
            $display("Test Failed: A = %0d, B = %0d, ALU_FUN = %0d, Expected = %0d, Actual = %0d",
                      item.A, item.B, item.ALU_FUN, expected_ALU_OUT, item.ALU_OUT);
            end
        end
        
    endtask

endclass 