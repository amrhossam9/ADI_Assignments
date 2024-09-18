class driver;

    virtual ALU_if alu_if;
    mailbox mbx;
    ALU_item item;
    event drv_done;
    task run();
      @(posedge alu_if.CLK)

        forever begin
            mbx.get(item);
            alu_if.A <= item.A;
            alu_if.B <= item.B;
            alu_if.ALU_FUN <= item.ALU_FUN;
          @(posedge alu_if.CLK)
          
            ->drv_done; 
        end
    endtask 

endclass 