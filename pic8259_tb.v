module pic_8259_tb;

    // INPUTS
    wire [7:0] data_tb;	        // data bus
    reg WR_tb;
    reg RD_tb;		            // from read-write logic
    reg CS__tb;
    reg A0_tb;
    reg [7:0] IR_tb;
    reg SP__tb;			        // 1 >> master , 0 >> slave
    reg INTA__tb;			    // ack from processor
    reg [2:0] CAS_IN_tb;		// for slave 

    // OUTPUTS
    wire [2:0] CAS_OUT_tb;		//  for master
    wire INT_tb;

    //INTERNAL SIGNAL
    reg [7:0] data_reg_tb;
    assign data_tb = (WR_tb) ? data_reg_tb : 8'bzzzzzzzz;
    
    

    
    // Instantiate the module
    pic8259 pic (
        .RD_(!RD_tb),
        .WR_(!WR_tb),
        .CS_(CS__tb),
        .A0(A0_tb),
        .data_bus(data_tb),
        .IR(IR_tb),
        .SP_(SP__tb),
        .INTA_(INTA__tb),
        .CAS_IN(CAS_IN_tb),

        .INT(INT_tb),
        .CAS_OUT(CAS_OUT_tb)
    );


    // Test stimulus
    initial begin
        // Initialize inputs
        #0 WR_tb = 1'b0;
        #0 RD_tb = 1'b0;
        #0 CS__tb = 1'b0;
        #0 A0_tb = 1'b1;
        #0 SP__tb = 1'b0;
        #0 data_reg_tb = 8'bzzzzzzzz;

        // Test ICW1 :
        #5 A0_tb = 1'b0;
        #0 data_reg_tb = 8'b00011011;
        #0 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;

        // Test ICW2 :
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b10011000;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;
        #0 A0_tb = 1'b0;
        
        // Test ICW4 :
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b00100001;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;
        
        // Test OCW1 :
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b10000001;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;


        // Test interrupt :
        #0 A0_tb = 1'b0;
        // Step 1-> detect INT:
        #0 IR_tb = 8'b00111000;
        // Step 2-> 1st INTA:
        #5 INTA__tb = 1'b0;
        #5 INTA__tb = 1'b1;
        // Step 3-> 2nd INTA:
        #5 INTA__tb = 1'b0;
        #0 RD_tb = 1'b1;
        #5 INTA__tb = 1'b1;
        #0 RD_tb = 1'b0;
    end


    initial begin
        // End simulation
        $dumpfile("uvm.vcd");
        $dumpvars;
        #1000 $finish; 
    end

endmodule
