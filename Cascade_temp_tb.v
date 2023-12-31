module cascade_tb;
  //waiting time
  parameter WAIT_CYCLES = 5;
  
  //signals
    reg SP,SNGL;
    reg [2:0] slaveReg;
    reg pulse1,pulse2;
    reg [2:0] intrID;
    wire [2:0] casc;
    reg  [2:0] tempCasc;
    wire vecFlag;
    assign casc=(!SP && !SNGL)?tempCasc:3'bzzz;
    cascade inst(SP,SNGL,slaveReg,pulse1,pulse2,intrID,casc,vecFlag); 
    

    // Stimulus
    initial begin
       
       //testcases
       //test master work while single pin is high
        SNGL=1'b1; SP=1'b1;pulse1=1'b0;pulse2=1'b0;
        slaveReg=3'b011;  
        #WAIT_CYCLES;
        pulse1=1'b1;intrID=3'b111;
        #WAIT_CYCLES;
        pulse2=1'b1;pulse1=1'b0;
        #WAIT_CYCLES;
        pulse2=1'b0;pulse1=1'b0;
        #WAIT_CYCLES;
        
       //test slave work while single pin is high
        SNGL=1'b1; SP=1'b0;pulse1=1'b0;slaveReg=3'b011;
        pulse2=1'b0;
        #WAIT_CYCLES;
        pulse1=1'b1;intrID=3'b111;
        #WAIT_CYCLES;
        pulse2=1'b1;pulse1=1'b0;
        #WAIT_CYCLES;
        pulse2=1'b0;pulse1=1'b0;
        #WAIT_CYCLES;
        
         //test master work when single pin is low
        SNGL=1'b0; SP=1'b1;pulse1=1'b0;pulse2=1'b0;  
        #WAIT_CYCLES;
        pulse1=1'b1;intrID=3'b111;
        #WAIT_CYCLES;
        pulse2=1'b1;pulse1=1'b0;
        #WAIT_CYCLES;
        pulse2=1'b0;pulse1=1'b0;
        #WAIT_CYCLES;
        
        
        //test slave work when single pin is low
        SNGL=1'b0; SP=1'b0;pulse1=1'b0;slaveReg=3'b011;tempCasc=3'bzzz;
        pulse2=1'b0;
        #WAIT_CYCLES;
        pulse1=1'b1;tempCasc=3'b011;
        #WAIT_CYCLES;
        pulse1=1'b0;pulse2=1'b1;tempCasc=3'bzzz;
        #WAIT_CYCLES;
        pulse2=1'b0;pulse1=1'b0;
        #WAIT_CYCLES;

         SNGL=1'b0; SP=1'b0;pulse1=1'b0;slaveReg=3'b011;
        pulse2=1'b0;
        #WAIT_CYCLES;
        pulse1=1'b1;tempCasc=3'b001;
        #WAIT_CYCLES;
        pulse1=1'b0;pulse2=1'b1;tempCasc=3'bzzz;
        #WAIT_CYCLES;
        pulse2=1'b0;pulse1=1'b0;
        #WAIT_CYCLES;
        $finish;
        
     end
   endmodule
