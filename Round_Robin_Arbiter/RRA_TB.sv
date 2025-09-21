// TB for round robin

module day15_tb ();

	logic        clk;
  logic        reset;
  
  logic[3:0] req_i;
  logic[3:0] gnt_o;
  
  day15 DUT (.*);
  
  initial clk = 0;
  always begin
    #3;
    clk = ~clk;
  end
  
  initial begin
    reset = 1;
    req_i = 0;
    @(posedge clk);
    reset = 0;
    @(posedge clk);
    
    repeat (10) begin
      req_i = 4'b1111;
      @(posedge clk);
    end
    
    repeat (50) begin
      req_i = $urandom_range (0, 4'b1111);
      @(posedge clk);
    end
  end
endmodule
