// Counter with a load
module day10 (
  input     wire          clk,
  input     wire          reset,
  input     wire          load_i,
  input     wire[3:0]     load_val_i,

  output    wire[3:0]     count_o
);

  logic [3:0] count;
  logic [3:0] load_val;
  
  wire wrap_around;
  assign wrap_around = &count_o;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      count <= 4'b0;
    else if (load_i)
      count <= load_val_i;
    else if (wrap_around)
      count <= load_val;
    else
      count <= count + 1;
  end
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      load_val <= 4'b0;
    else if (load_i)
      load_val <= load_val_i;
  end
  
  assign count_o = count;
    
endmodule
