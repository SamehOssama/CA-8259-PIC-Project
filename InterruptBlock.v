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

module Priority_Resolver (input [7:0] IRR, input Automatic_Rotate, output reg [7:0] chosen_interrupt );
	 reg [7:0] priority_status [0:7];  // Array for priority status
	
	  // Initial block to initialize priority status
	  initial begin
	    priority_status[0] = 0;
	    priority_status[1] = 1;
	    priority_status[2] = 2;
	    priority_status[3] = 3;
	    priority_status[4] = 4;
	    priority_status[5] = 5;
	    priority_status[6] = 6;
	    priority_status[7] = 7;
	  end
	initial begin
		if(IRR[0] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0001;
		  end else if(IRR[1] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0010;
		  end else if(IRR[2] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0100;
		  end else if(IRR[3] == 1'b1) begin
			  chosen_interrupt = 8'b0000_1000;
		  end else if(IRR[4] == 1'b1) begin
			  chosen_interrupt = 8'b0001_0000;
		  end else if(IRR[5] == 1'b1) begin
			  chosen_interrupt = 8'b0010_0000;
		  end else if(IRR[6] == 1'b1) begin
			  chosen_interrupt = 8'b0100_0000;
		  end else if(IRR[7] == 1'b1) begin
			  chosen_interrupt = 8'b1000_0000;
		  end else begin
		  //default no interrupt
		          chosen_interrupt = 8'b0000_0000;
		  end
	end
		

	  
  always @* begin
	  if(Automatic_Rotate) begin
		  
	


		  
	  end else begin
		  //fully nested mode
		  if(IRR[0] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0001;
		  end else if(IRR[1] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0010;
		  end else if(IRR[2] == 1'b1) begin
			  chosen_interrupt = 8'b0000_0100;
		  end else if(IRR[3] == 1'b1) begin
			  chosen_interrupt = 8'b0000_1000;
		  end else if(IRR[4] == 1'b1) begin
			  chosen_interrupt = 8'b0001_0000;
		  end else if(IRR[5] == 1'b1) begin
			  chosen_interrupt = 8'b0010_0000;
		  end else if(IRR[6] == 1'b1) begin
			  chosen_interrupt = 8'b0100_0000;
		  end else if(IRR[7] == 1'b1) begin
			  chosen_interrupt = 8'b1000_0000;
		  end else begin 
			  //default no interrupt
		          chosen_interrupt = 8'b0000_0000;
		  end

	  end
  end
endmodule
