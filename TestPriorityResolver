module TestpriorityResolver;
reg [7:0] OutputIRR;
reg  clearFromISR;
reg set;
reg reset;
wire [2:0]  Outputchosen_interrupt;

  Priority_Resolver B (.IRR(OutputIRR),.clear(clearFromISR),.set(set),.reset(reset),
 .chosen_interrupt(Outputchosen_interrupt));
 
 initial begin
   OutputIRR = 8'b0000_0000;
   set=0;
   reset=0;
   
   // testing out without rotation
  #5 OutputIRR = 8'b1000_0000;
  #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1100_0000;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1110_0000;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1111_0000;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1111_1000;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1111_1100;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1111_1110;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b1111_1111;
    #5 clearFromISR=1;
  #5 clearFromISR=0;
  
  //with rotation
  set=1;
  #5 OutputIRR = 8'b0000_0000;
  #5 OutputIRR = 8'b1111_1111;
  #5 clearFromISR=1;
  #5 clearFromISR=0;
  #5 OutputIRR = 8'b0000_0000;
  #5 OutputIRR = 8'b1111_1111;
  #5 clearFromISR=1;
  #5 clearFromISR=0;
   
 end
endmodule

