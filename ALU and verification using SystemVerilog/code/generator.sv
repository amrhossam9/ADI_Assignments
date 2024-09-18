class generator;

    mailbox mbx;
    event drv_done;
    int num = 20;

    task run();
      //Following verification Plan
      custom_tests(4'b0001,4'b0010,2'b00);
      custom_tests(4'b1111,4'b0001,2'b00);
      
      custom_tests(4'b0100,4'b0011,2'b01);
      custom_tests(4'b0001,4'b0100,2'b01);
      
      custom_tests(4'b0010,4'b0011,2'b10);
      custom_tests(4'b1111,4'b0010,2'b10);
      
      custom_tests(4'b0100,4'b0010,2'b11);
      custom_tests(4'b1111,4'b0001,2'b11);
      
      custom_tests(4'b1111,4'b1111,2'b00);
      custom_tests(4'b1111,4'b1111,2'b01);
      custom_tests(4'b1111,4'b1111,2'b10);
      custom_tests(4'b1111,4'b1111,2'b11);
      
      custom_tests(4'b0,4'b1111,2'b00);
      custom_tests(4'b0,4'b1111,2'b01);
      custom_tests(4'b0,4'b1111,2'b10);
      custom_tests(4'b0,4'b1111,2'b11);
      
      //Randomizing 
      
        for (int i = 0; i < num; i++) begin
            ALU_item ALU_item = new;
            ALU_item.randomize();
            $display ("T=%t [Generator] Loop:%0d/%0d create next item", $time, i+1, num);
            mbx.put(ALU_item);
            @(drv_done);
        end

        $display ("T=%t [Generator] Done generation of %0d items", $time, num);
    endtask
	
      task custom_tests(
        input reg [3:0] A,
        input reg [3:0] B,
        input reg [1:0] fun
    );
    begin
      ALU_item ALU_item = new;
            ALU_item.A = A;
      		ALU_item.B = B;
      		ALU_item.ALU_FUN = fun;
      $display ("T=%t [Generator] Custom", $time);
            mbx.put(ALU_item);
            @(drv_done);
    end
  endtask;
endclass