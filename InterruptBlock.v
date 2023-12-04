module IRR (
  //Inputs from Control Logic
  input level_or_edge_flag , 
  input freeze , 
  input [7:0] clear_interrupt_request,
  input [7:0] mask,
  
  input i0,
  input i1,
  input i2,
  input i3,
  input i4,
  input i5,
  input i6,
  input i7,

  output reg[7:0] IRR);
  
  always @* begin
  IRR[0] <= i0 & ~mask[0];
  IRR[1] <= i1 & ~mask[1];
  IRR[2] <= i2 & ~mask[2];
  IRR[3] <= i3 & ~mask[3];
  IRR[4] <= i4 & ~mask[4];
  IRR[5] <= i5 & ~mask[5];
  IRR[6] <= i6 & ~mask[6];
  IRR[7] <= i7 & ~mask[7];
  end
endmodule
