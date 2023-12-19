module IRR (
  //Inputs from Control Logic
  input level_or_edge_flag , 
  input [7:0] mask,
  
  input i0,
  input i1,
  input i2,
  input i3,
  input i4,
  input i5,
  input i6,
  input i7,

  output reg[7:0] IRR
  );
  
reg prev_i0,prev_i1,prev_i2,prev_i3,prev_i4,prev_i5,prev_i6,prev_i7;  

  always @* begin
	if(level_or_edge_flag) begin
    IRR[0] <= i0 & ~mask[0];
    IRR[1] <= i1 & ~mask[1];
    IRR[2] <= i2 & ~mask[2];
    IRR[3] <= i3 & ~mask[3];
    IRR[4] <= i4 & ~mask[4];
    IRR[5] <= i5 & ~mask[5];
    IRR[6] <= i6 & ~mask[6];
    IRR[7] <= i7 & ~mask[7];
  end else begin
 // Edge-sensitive logic for each input
      if (i0 == 1'b1 && prev_i0 == 1'b0) begin
         IRR[0] <= 1'b1; 
      end else begin
         IRR[0] <= 1'b0;
      end
      if (i1 == 1'b1 && prev_i1 == 1'b0) begin
         IRR[1] <= 1'b1; 
      end else begin
         IRR[1] <= 1'b0;
      end
      if (i2 == 1'b1 && prev_i2 == 1'b0) begin
         IRR[2] <= 1'b1; 
      end else begin
         IRR[2] <= 1'b0;
      end
      if (i3 == 1'b1 && prev_i3 == 1'b0) begin
         IRR[3] <= 1'b1; 
      end else begin
         IRR[3] <= 1'b0;
      end	
      if (i4 == 1'b1 && prev_i4 == 1'b0) begin
         IRR[4] <= 1'b1; 
      end else begin
         IRR[4] <= 1'b0;
      end
      if (i5 == 1'b1 && prev_i5 == 1'b0) begin
         IRR[5] <= 1'b1;
      end else begin
         IRR[5] <= 1'b0;
      end
      if (i6 == 1'b1 && prev_i6 == 1'b0) begin
         IRR[6] <= 1'b1;
      end else begin
         IRR[6] <= 1'b0;
      end	 
      if (i7 == 1'b1 && prev_i7 == 1'b0) begin
         IRR[7] <= 1'b1; 
      end else begin
         IRR[7] <= 1'b0;
      end

 
   // Update the previous signals for the next iteration
      prev_i0 <= i0;
      prev_i1 <= i1;
      prev_i2 <= i2;
      prev_i3 <= i3;
      prev_i4 <= i4;
      prev_i5 <= i5;
      prev_i6 <= i6;
      prev_i7 <= i7;
      
   end
 end
endmodule

module Priority_Resolver (input reg [7:0] IRR, input Automatic_Rotate, output chosen_interrupt );
  
  
  
  
  
  
  
  
  
endmodule
