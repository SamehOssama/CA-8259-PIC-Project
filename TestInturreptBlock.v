module TestIntteruptBlock;
  
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
  reg set;
  reg reset;
  reg aeoi;
  reg eoi;
  reg [1:0] intAcounter;
  
wire INTtocontrol;
wire [2:0] ISRtocontrol;
  
 



 InterruptBlock testing (.level_or_edge_flag(level_or_edge_flag),.i0(i0),.i1(i1),.i2(i2),.i3(i3),.i4(i4),.i5(i5),.i6(i6),.i7(i7),
 .mask(mask),.set(set),.reset(reset),.aeoi(aeoi),.eoi(eoi),.intAcounter(intAcounter),
 .INTtocontrol(INTtocontrol),.ISRtocontrol(ISRtocontrol)
  );

 
  initial begin
   i0=0;
   i1=0;
   i2=0;
   i3=0;
   i4=0;
   i5=0;
   i6=0;
   i7=0;
   
   level_or_edge_flag = 0;
   mask = 8'b0000_0000;
   set=0;
   reset=0;
   aeoi=1;
   eoi=0;
   //intAcounter = 2b'00;
   
   //first trying with automatic eoi and edge sensitive
   
   #10 i1=1;
   #5  i0=1;
   #5  i7=1;
   #5 intAcounter = 2'b01;
   #5 intAcounter = 2'b10;
   #5 i1=0;
   
   
    
    
    
    
    
    
    
    
    
    
  end
endmodule

