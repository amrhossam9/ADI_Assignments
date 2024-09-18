class env;

    driver d0;
    monitor m0;
    score_board sb0;
    generator g0;
    mailbox mbx, scb_mbx;
    event drv_done;
    virtual ALU_if alu_if;

    function new();
        d0 = new();
        m0 = new();
        sb0 = new();
        g0 = new();
      	mbx = new;
        scb_mbx = new;

        d0.mbx = mbx;
        g0.mbx = mbx;

        m0.scb_mbx = scb_mbx;
        sb0.scb_mbx = scb_mbx;

        d0.drv_done = drv_done;
        g0.drv_done = drv_done;
    endfunction 

    virtual task run();
        d0.alu_if = alu_if;
        m0.alu_if = alu_if;
        fork
            d0.run();
            m0.run();
            sb0.run();
            g0.run();
        join

    endtask
endclass 