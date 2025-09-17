// Parallel to serial with valid and empty

module day11 (
  input     wire      clk,
  input     wire      reset,

  output    wire      empty_o,
  input     wire[3:0] parallel_i,
  input 		wire			valid_i,
  
  output    wire      serial_o,
  output    wire      valid_o
);

  // 3-bit counter for PISO states:
  logic [2:0] count;
  
  wire equal_4;
  assign equal_4 = (count == 3'd4);
  assign empty_o = (count == 3'd0);
    
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      count <= 0;
    else if (equal_4)
      count <= 0;
    else if ((valid_i && empty_o) || (~empty_o))
      count <= count + 1;
  end
  
  
  // SR logic:
  logic [3:0] sr;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      sr <= '0;
    else if (valid_i && empty_o)
      sr <= parallel_i;
    else if (~empty_o)
      sr <= sr >> 1;
  end
  
  
  assign serial_o = sr[0];
  assign valid_o = (~empty_o);
      
endmodule
