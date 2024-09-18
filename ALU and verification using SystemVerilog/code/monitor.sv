class monitor;

    virtual ALU_if alu_if;
    mailbox scb_mbx;
  	ALU_item alu_item = new;
    task run();
        forever begin
          	@(posedge alu_if.CLK);
            alu_item.A = alu_if.A;
            alu_item.B = alu_if.B;
            alu_item.ALU_FUN = alu_if.ALU_FUN;
            alu_item.ALU_OUT = alu_if.ALU_OUT;

            scb_mbx.put(alu_item);

        end
    endtask 

endclass 