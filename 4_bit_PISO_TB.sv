module day11_tb ();

  logic        clk;
	logic        reset;
  logic 			 valid_i;
  logic [3:0] parallel_i;
  
  logic 			empty_o;
  logic			  serial_o;
  logic 			valid_o;
  logic [255:0] status;
	
  day11 DUT (.*);
  
  initial clk = 1'b0;
  always begin
    clk = ~clk;
    #2;
  end
  
  initial begin
    status = "RESET";
  	reset = 1'b1;
    valid_i = 0;
    parallel_i = 0;
    repeat(2) @(posedge clk);
    reset = 1'b0;
    
    repeat(20) @(posedge clk);
    
    status = "RANDOM INPUTS EVERY 5 CYCLES";
    for (int i=0; i<6; i++) begin
      valid_i   <= 1;
      parallel_i <= $urandom_range (0, 4'b1111);
      @(posedge clk);
      valid_i   <= 1'b0;
      repeat(5) @(posedge clk);
    end

   status = "RANDOM INPUTS EVERY 4 CYCLES";
   for (int i=0; i<6; i++) begin
      valid_i   <= 1;
      parallel_i <= $urandom_range (0, 4'b1111);
      @(posedge clk);
      valid_i   <= 1'b0;
      repeat(4) @(posedge clk);
    end
    
    status = "RANDOM INPUTS EVERY 3 CYCLES";
    for (int i=0; i<6; i++) begin
      valid_i   <= 1;
      parallel_i <= $urandom_range (0, 4'b1111);
      @(posedge clk);
      valid_i   <= 1'b0;
      repeat(3) @(posedge clk);
    end
    
  end
endmodule


