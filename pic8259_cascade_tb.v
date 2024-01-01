module pic_8259_cascade_tb;

    // INPUTS
    wire [7:0] data_tb;	        // data bus
    reg WR_tb;
    reg RD_tb;		            // from read-write logic
    reg CS__M;
    reg CS__S;
    reg A0_tb;
    reg INTA__tb;			    // ack from processor
    reg [7:0] IR_M;
    reg [7:0] IR_S;
    reg SP__M;
    reg SP__S;
    reg [2:0] CAS_IN_M;
    reg [2:0] CAS_IN_S;

    // OUTPUTS
    wire [2:0] CAS_OUT_M;
    wire [2:0] CAS_OUT_S;
    wire INT_M;
    wire INT_S;

    //INTERNAL SIGNAL
    reg [7:0] data_reg_tb;
    assign data_tb = (WR_tb) ? data_reg_tb : 8'bzzzzzzzz;
    
    

    
    // Instantiate the module
    pic8259 pic_M (
        .RD_(!RD_tb),
        .WR_(!WR_tb),
        .CS_(CS__M),
        .A0(A0_tb),
        .data_bus(data_tb),
        .IR(IR_M),
        .SP_(SP__M),
        .INTA_(INTA__tb),
        .CAS_IN(CAS_IN_M),
        .INT(INT_M),
        .CAS_OUT(CAS_OUT_M)
    );

    pic8259 pic_S (
        .RD_(!RD_tb),
        .WR_(!WR_tb),
        .CS_(CS__S),
        .A0(A0_tb),
        .data_bus(data_tb),
        .IR(IR_S),
        .SP_(SP__S),
        .INTA_(INTA__tb),
        .CAS_IN(CAS_OUT_M),
        .INT(INT_S),
        .CAS_OUT(CAS_OUT_S)
    );


    // Test stimulus
    initial begin
        // Initialize inputs
        #0 WR_tb = 1'b0;
        #0 RD_tb = 1'b0;
        #0 CS__M = 1'b0;
        #0 CS__S = 1'b0;
        #0 A0_tb = 1'b1;
        #0 SP__M = 1'b0;
        #0 SP__S = 1'b1;
        #0 data_reg_tb = 8'bzzzzzzzz;

        // Test ICW1 :
        #5 A0_tb = 1'b0;
        #0 data_reg_tb = 8'b00011000;
        #0 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;

        // Test ICW2 :
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b11111000;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;
        #0 A0_tb = 1'b0;
        #0 CS__M = 1'b1;
        #0 CS__S = 1'b1;

         // Test ICW3 MASTER:
        #5 CS__M = 1'b0;
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b00000010;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;
        #0 CS__M = 1'b1;

        // Test ICW3 SLAVE: (Slave ID = 1)
        #5 CS__S = 1'b0;
        #0 A0_tb = 1'b1;
        #0 data_reg_tb = 8'b00000001;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;
        #0 CS__S = 1'b1;

        // Test OCW2 :
        #5 A0_tb = 1'b0;
        #0 CS__M = 1'b0;
        #0 CS__S = 1'b0;
        #0 data_reg_tb = 8'b00100000;
        #5 WR_tb = 1'b1;
        #5 WR_tb = 1'b0;

        // Test interrupt :
        #5 CS__M = 1'b1;
        #0 CS__S = 1'b1;
        #0 A0_tb = 1'b0;
        #0 WR_tb = 1'b0;
        #0 RD_tb = 1'b0;
        // Step 1-> detect INT:
        #0 IR_S = 8'b00000100;
        #5 IR_M = {6'b000000, INT_S, 1'b0};

        // Step 2-> 1st INTA:
        #5 INTA__tb = 1'b0;
        #5 INTA__tb = 1'b1;
        // Step 3-> 2nd INTA:
        #5 INTA__tb = 1'b0;
        #0 CS__S = 1'b0;
        #0 RD_tb = 1'b1;
        #5 INTA__tb = 1'b1;
        #0 CS__S = 1'b1;
        #0 RD_tb = 1'b0;
    end


    initial begin
        // End simulation
        $dumpfile("uvm.vcd");
        $dumpvars;
        #1000 $finish; 
    end

endmodule
