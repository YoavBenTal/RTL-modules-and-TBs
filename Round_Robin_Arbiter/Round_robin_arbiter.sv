// Round robin arbiter

module day15 (
  input     wire        clk,
  input     wire        reset,

  input     wire[3:0]   req_i,
  output    logic[3:0]  gnt_o
);
	
  // Mask logic, 
  logic [3:0] mask;
  logic [3:0] mask_nxt;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) mask <= 4'b1111;
    else mask <= mask_nxt;
  end
  
  always_comb begin
    mask_nxt = mask;
    case (gnt_o)
      4'b1000: mask_nxt = 4'b0111;
      4'b0100: mask_nxt = 4'b0011;
      4'b0010: mask_nxt = 4'b0001;
      4'b0001: mask_nxt = 4'b0000;
      default: ;
    endcase
  end
  
  logic [3:0] masked_req;
  assign masked_req = req_i & mask;
  
  logic [3:0] masked_gnt;
  first_set_4bits masked_GNT (.req_i(masked_req), .gnt_o(masked_gnt));
	
  logic [3:0] raw_gnt;
  first_set_4bits raw_GNT (.req_i(req_i), .gnt_o(raw_gnt));
  
  assign gnt_o = |masked_gnt ? masked_gnt : raw_gnt;
  // assert property (@(posedge clk) $onehot0(gnt_o));

endmodule



// Priority arbiter
// port[3] - highest priority
module first_set_4bits (
  input       wire[3:0] req_i,
  output      wire[3:0] gnt_o   // One-hot grant signal
);
  assign gnt_o[3] = req_i[3];
  assign gnt_o[2] = ~req_i[3] & req_i[2];
  assign gnt_o[1] = ~req_i[3] & ~req_i[2] & req_i[1];
  assign gnt_o[0] = ~req_i[3] & ~req_i[2] & ~req_i[1] & req_i[0];
endmodule