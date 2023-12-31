module TestIRR;
  reg i0;
  reg i1;
  reg i2;
  reg i3;
  reg i4;
  reg i5;
  reg i6;
  reg i7;
  reg level_or_edge_flag;
  reg [7:0] mask;
  reg [1:0] intAcounter;
  
wire INTtocontrol;
wire [7:0] OutputIRR;
reg [2:0] OutclearHighest;
wire OutspecialDeliveryFlag;
  
 IRR A (.level_or_edge_flag(level_or_edge_flag),.intAcounter(intAcounter),.mask(mask),.clearHighest(OutclearHighest),
  .i0(i0),.i1(i1),.i2(i2),.i3(i3),.i4(i4),.i5(i5),.i6(i6),.i7(i7),
  .specialDeliveryFlag(OutspecialDeliveryFlag),.IRR(OutputIRR),.INT(INTtocontrol));
  
  initial begin
    intAcounter=0;
   level_or_edge_flag = 0; 
   #5 intAcounter = 1;
   

   i0=0;
   i1=0;
   i2=0;
   i3=0;
   i4=0;
   i5=0;
   i6=0;
   i7=0;
   
   
   //setting all to 1 then clearing them with edge sensitive
   level_or_edge_flag = 0; 
   mask = 8'b0000_0000;
   #10 i0=1;
   #5  i0=0;
   #10 i1=0; i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;
   
   #5 intAcounter = 1;OutclearHighest=1;
   #5 intAcounter = 2;
   #5 intAcounter = 1;
   #5 OutclearHighest=0;
   #5 OutclearHighest=2;
   #5 OutclearHighest=3;
   #5 OutclearHighest=4;
   #5 OutclearHighest=5;
   #5 OutclearHighest=6;
   #5 OutclearHighest=7;
   
   
   // testing with mask set for i0 with edge sensitive
   #10 i0=0;i1=0; i2=0;i3=0;i4=0;i5=0;i6=0;i7=0;
   #5 intAcounter = 2;
   #5 mask = 8'b0000_0001;
   #10 i0=1; i1=1; i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;
   
   
   //setting all to 1 then clearing them with level sensitive
   level_or_edge_flag = 1; 
   mask = 8'b0000_0000;
   #10 i0=1;
   #5  i0=0;
   #10 i1=0; i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;
   
   #5 intAcounter = 1;OutclearHighest=1;
   #5 intAcounter = 2;
   #5 intAcounter = 1;
   #5 OutclearHighest=0;
   #5 OutclearHighest=2;
   #5 OutclearHighest=3;
   #5 OutclearHighest=4;
   #5 OutclearHighest=5;
   #5 OutclearHighest=6;
   #5 OutclearHighest=7;
   
   
   // testing with mask set for i0 with level sensitive
   #5 intAcounter = 2;
   #5 mask = 8'b0000_0001;
   #10 i0=1; i1=1; i2=1;i3=1;i4=1;i5=1;i6=1;i7=1;
  
  end
endmodule
