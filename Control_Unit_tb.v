module Control_Unit_tb;

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

    //INTERNAL SIGNAL
    reg [7:0]DATA_internal_REG;
    assign DATA_internal = (WR_ENABLE_internal) ? DATA_internal_REG : DATA_internal;
    
    
    // Registers for all the wires to use in begin block
    // use anything with the suffix _tb
    
    /*wire RD_ENABLE_tb;   // from read-write logic
    wire WR_ENABLE_tb;
    wire [7:0] DATA_tb;   // data bus
    wire A0_tb;           
    wire INTERNAL_INT_tb;  
    wire INTA__tb;       // ack from processor
    wire SP__tb; // 1 >> master , 0 >> slave
    wire R_tb;  // 0 >> fully-nested
    wire sngl_tb; // 0 >> cascaded  
    wire LEVEL_tb;
    */
    
/* 	assign INTERNAL_INT_internal = INTERNAL_INT_tb
    assign WR_ENABLE_internal = WR_ENABLE_tb
    assign RD_ENABLE_internal = RD_ENABLE_tb
    assign DATA_internal = DATA_tb
    assign A0_internal = A0_tb
    assign INTA__internal = INTA_tb
    assign SP__internal = SP_tb
    assign R_internal = R_tb
    assign sngl_internal = sngl_tb
    assign LEVEL_internal = LEVEL_tb */
    
    // Instantiate the module
    Control_Unit cu (
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


    // Test stimulus
    initial begin
        // Initialize inputs
        #0 WR_ENABLE_internal = 1'b0;
        #0 RD_ENABLE_internal = 1'b0;
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'bzzzzzzzz;
        // Test Case 1:
        #0 A0_internal = 1'b0;
        #0 DATA_internal_REG = 8'b00010001;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;
        // Test Case 2: 
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b11111000;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;
        #0 A0_internal = 1'b0;
        // Test Case 3: 
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b00111100;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;
        //Test Case 4: 
        #0 A0_internal = 1'b1;
        #0 DATA_internal_REG = 8'b00100001;
        #5 WR_ENABLE_internal = 1'b1;
        #5 WR_ENABLE_internal = 1'b0;

    end


    initial begin
        // End simulation
        $dumpfile("uvm.vcd");
        $dumpvars;
        #1000 $finish; 
    end

endmodule
