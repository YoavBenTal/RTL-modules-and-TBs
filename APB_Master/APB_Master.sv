// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE

// APB Hand shake protocol:
// IDLE → SETUP (PSEL=1,PENABLE=0) → ACCESS (PSEL=1,PENABLE=1) — wait for PREADY=1 → IDLE



module day16 (
  input       wire        clk,
  input       wire        reset,
  
  input       wire[1:0]   cmd_i,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);
  
  
  typedef enum logic[1:0] {
    IDLE 				   = 2'b00,
    SETUP					 = 2'b01,
    ACCESS				 = 2'b10
  } state_type;
  
  state_type state_q, nxt_state;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) state_q <= IDLE;
    else state_q <= nxt_state;
  end
  
  always_comb begin
    nxt_state = state_q;
    unique case (state_q)
      IDLE: if (|cmd_i) nxt_state = SETUP;
      			else nxt_state = IDLE;
      
      SETUP: nxt_state = ACCESS;
      ACCESS: if (pready_i) nxt_state = IDLE;
      			 else nxt_state = ACCESS;
      default: nxt_state = state_q;
    endcase
  end    
  
  logic [31:0] rdata;
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata <= 32'h0;
    else if (penable_o && pready_i)
      rdata <= prdata_i;
  
  assign psel_o = (state_q == SETUP) | (state_q == ACCESS);
  assign penable_o = (state_q == ACCESS);
  assign pwrite_o = cmd_i[1];
  assign paddr_o = 32'hDEAD_CAFE;
  assign pwdata_o = rdata + 32'd1;

 
endmodule
