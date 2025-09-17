module day10_tb ();

  logic        clk;
  logic        reset;
  logic load_i;
  logic [3:0] load_val_i;
  

  logic[3:0]  count_o;
  logic [127:0] status;
	
  day10 DUT (.*);
  
  initial clk = 1'b0;
  always begin
    clk = ~clk;
    #2;
  end
  
  initial begin
    status = "NORMAL COUNT";
  	reset = 1'b1;
    load_i = 0;
    load_val_i = 0;
    repeat(2) @(posedge clk);
    reset = 1'b0;
    
    repeat(20) @(posedge clk);
    
    status = "RANDOM LOAD";
    for (int i=0; i<6; i++) begin
      load_i   = $urandom_range (0, 1);
      load_val_i = $urandom_range (0, 4'b1111);
      if (load_i) begin
        @(posedge clk);
      	load_i   = 1'b0;
      end
      repeat(10) @(posedge clk);
    end
    
    status = "CHECK MAX LOAD";
    load_i   = 1'b1;
    load_val_i = 4'b1111;
    @(posedge clk);
    load_i   = 1'b0;
    repeat(10) @(posedge clk);
    
  end
  
endmodule
