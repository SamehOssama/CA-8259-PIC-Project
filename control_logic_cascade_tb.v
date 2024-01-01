module Control_Unit_Cascade_tb;

    // INPUTS
    reg WR_ENABLE_internal;
    reg RD_ENABLE_internal;		// from read-write logic
    wire [7:0] DATA_internal;	// data bus
    reg A0_internal;           
    reg INTERNAL_INT_internal;  
    reg INTA__internal;			// ack from processor
    reg SP__internal;			// 1 >> master , 0 >> slave
    reg [2:0] CAS_IN_tb;		// for slave 
    reg [2:0] IR_NUM_tb;

    // OUTPUTS
    wire [2:0] CAS_OUT_tb;		//  for master
    wire [7:0] interrupt_mask_tb;
    wire INT_tb;
    wire AEOI_tb;  
    wire [1:0] INTA_COUNT_tb;
    wire R_internal;				// 0 >> fully-nested
    wire sngl_internal;			// 0 >> cascaded  // OUTPUT?  
    wire LEVEL_internal;
    wire RIRR_tb;
    wire RISR_tb;

    // Slave

    // INPUTS
    reg WR_ENABLE_internal_S;
    reg RD_ENABLE_internal_S;		// from read-write logic
    reg INTERNAL_INT_internal_S;  
    reg INTA__internal_S;			// ack from processor
    reg SP__internal_S;			// 1 >> master , 0 >> slave
    reg [2:0] IR_NUM_tb_S;

    // OUTPUTS
    wire [2:0] CAS_OUT_tb_S;		//  for master
    wire [7:0] interrupt_mask_tb_S;
    wire AEOI_tb_S;  
    wire [1:0] INTA_COUNT_tb_S;
    wire R_internal_S;				// 0 >> fully-nested
    wire sngl_internal_S;			// 0 >> cascaded  // OUTPUT?  
    wire LEVEL_internal_S;
    wire RIRR_tb_S;
    wire RISR_tb_S;


    //INTERNAL SIGNAL
    reg [7:0]DATA_internal_REG;
    assign DATA_internal = (WR_ENABLE_internal || WR_ENABLE_internal_S) ? DATA_internal_REG : 8'bzzzzzzzz;

    
    // Instantiate the module
    Control_Unit master (
        .RD_ENABLE(RD_ENABLE_internal),   		// from read-write logic
        .WR_ENABLE(WR_ENABLE_internal), 
        .DATA(DATA_internal),   					// data bus
        .A0(A0_internal),           
        .INTERNAL_INT(INTERNAL_INT_internal),  
        .INTA_(INTA__internal),       			// ack from processor
        .SP_(SP__internal),					 	// 1 >> master , 0 >> slave
        .CAS_IN(CAS_IN_tb), 				// for slave 
        .CAS_OUT(CAS_OUT_tb), 				//  for master
        .IR_NUM(IR_NUM_tb),
        .interrupt_mask(interrupt_mask_tb),
        .INT(INT_tb),
        .AEOI(AEOI_tb),  
        .INTA_COUNT(INTA_COUNT_tb),
        .R(R_internal),							// 0 >> fully-nested
        .sngl(sngl_internal), 					// 0 >> cascaded  
        .LEVEL(LEVEL_internal),
        .RIRR(RIRR_tb),
        .RISR(RISR_tb)
    );

    Control_Unit slave (
        .RD_ENABLE(RD_ENABLE_internal_S),   		// from read-write logic
        .WR_ENABLE(WR_ENABLE_internal_S), 
        .DATA(DATA_internal),   					// data bus
        .A0(A0_internal),           
        .INTERNAL_INT(INTERNAL_INT_internal_S),  
        .INTA_(INTA__internal),       			// ack from processor
        .SP_(SP__internal_S),					 	// 1 >> master , 0 >> slave
        .CAS_IN(CAS_OUT_tb), 				// for slave 
        .CAS_OUT(CAS_OUT_tb_S), 				//  for master
        .IR_NUM(IR_NUM_tb_S),
        .interrupt_mask(interrupt_mask_tb_S),
        .INT(INT_tb),
        .AEOI(AEOI_tb_S),  
        .INTA_COUNT(INTA_COUNT_tb_S),
        .R(R_internal_S),							// 0 >> fully-nested
        .sngl(sngl_internal_S), 					// 0 >> cascaded  
        .LEVEL(LEVEL_internal_S),
        .RIRR(RIRR_tb_S),
        .RISR(RISR_tb_S)
    );


    // Test stimulus
    initial begin
        // Initialize inputs
        #0 WR_ENABLE_internal = 1'b0;
        #0 RD_ENABLE_internal = 1'b0;
        #0 WR_ENABLE_internal_S = 1'b0;
        #0 RD_ENABLE_internal_S = 1'b0;
        #0 A0_internal = 1'b1;
        #0 SP__internal = 1'b0;
        #0 SP__internal_S = 1'b1;
        #0 DATA_internal_REG = 8'bzzzzzzzz;

        // Both
        // Test ICW1 :
        #5 A0_internal = 1'b0;
        #0 DATA_internal_REG = 8'b00011000;
        #0 WR_ENABLE_internal = 1'b1;
        #0 WR_ENABLE_internal_S = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;
        #0 WR_ENABLE_internal_S = 1'b0;

        // Test ICW2 :
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b11111000;
        #5 WR_ENABLE_internal = 1'b1;
        #0 WR_ENABLE_internal_S = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;
        #0 WR_ENABLE_internal_S = 1'b0;
        #0 A0_internal = 1'b0;

        // Test ICW3 MASTER: (Slave on pin 1)
        #5 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b00000010;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;

        // Test ICW3 SLAVE: (Slave ID = 1)
        #5 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b00000001;
        #5 WR_ENABLE_internal_S = 1'b1;
        #5 WR_ENABLE_internal_S = 1'b0;


        /* // Test ICW4 :
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b00100001;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0; */








        // Test interrupt :
        // Step 1-> detect INT:
        #5 IR_NUM_tb_S = 3'b011;
        #0 INTERNAL_INT_internal_S = 1'b1;
        #0 IR_NUM_tb = 3'b001;
        #0 INTERNAL_INT_internal = 1'b1;
        // Step 2-> 1st INTA:
        #5 INTA__internal = 1'b0;
        #5 INTA__internal = 1'b1;
        // Step 3-> 2nd INTA:
        #5 INTA__internal = 1'b0;
        #0 RD_ENABLE_internal = 1'b1;
        #0 RD_ENABLE_internal_S = 1'b1;
        #5 INTA__internal = 1'b1;
        #0 RD_ENABLE_internal = 1'b0;
        #0 RD_ENABLE_internal_S = 1'b0;
        #0 INTERNAL_INT_internal_S = 1'b0;
        #0 INTERNAL_INT_internal = 1'b0;
        // Step 4 ->End
        #5 IR_NUM_tb_S = 3'bxxx;
        #0 INTERNAL_INT_internal_S = 1'b0;
        #0 IR_NUM_tb = 3'bxxx;
        #0 INTERNAL_INT_internal = 1'b0;

        /*// Test read :
        #5 A0_internal = 1'b1;
        #0 RD_ENABLE_internal = 1'b1;
        #5 RD_ENABLE_internal = 1'b0; */
    end


    initial begin
        // End simulation
        $dumpfile("uvm.vcd");
        $dumpvars;
        #1000 $finish; 
    end

endmodule
