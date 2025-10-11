// APB Master TB

module day16_tb ();

  logic        clk;
  logic        reset;

  logic[1:0]   cmd_i;

  logic        psel_o;
  logic        penable_o;
  logic[31:0]  paddr_o;
  logic        pwrite_o;
  logic[31:0]  pwdata_o;
  
  logic        pready_i;
  logic[31:0]  prdata_i;

  day16 DAY16 (.*);

  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end


  // Generate the stimulus
  initial begin
    reset <= 1'b1;
    cmd_i <= 2'b00;
    prdata_i <= 32'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<10; i++) begin
      cmd_i <= i%2 ? 2'b10 : 2'b01;
      prdata_i <= $urandom_range(0, 4'hF);
      repeat(3) @(posedge clk);
     
      pready_i <= 1'b1;
      repeat(3) @(posedge clk);
      pready_i <= 1'b0;      
    end
  end

endmodule
