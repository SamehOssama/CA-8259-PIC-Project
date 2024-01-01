module pic8259 (
    input RD_, WR_, CS_, A0,
    input [7:0] data_bus,
    input [7:0] IR,

    input INTA_, SP_,
    input [2:0] CAS_IN,
    output INT,
    output [2:0] CAS_OUT
);
    // RWL
    wire RD_enable;
    wire WR_enable;
    wire Ao_out;

    // DATA BUS
    wire [7:0] internal_bus;

    // Interrupt
    wire INTERNAL_INT;  
    wire [2:0] IR_NUM_INTERNAL;

    // Control
    wire [7:0] INTERRUPT_MASK;
    wire AEOI_tb;  
    wire [1:0] INTA_COUNT;
    wire ROTATE;				// 0 >> fully-nested
    wire LEVEL;
    wire sngl_internal;			    // 0 >> cascaded  // OUTPUT?  
    wire RIRR_tb;
    wire RISR_tb;





    // Instantiate the module
    Read_Write_Logic RWL (
        .RD_(RD_),
        .WR_(WR_),
        .A0(A0),
        .CS_(CS_),
        .RD(RD_enable),
        .WR(WR_enable),
        .A0_out(Ao_out)
    );

    data_bus_buffer DBB (
        .data(data_bus),
        .internal(internal_bus),
        .r(RD_enable),
        .w(WR_enable)
    );

    InterruptBlock INTERRUPT (
        //from control
        .level_or_edge_flag(LEVEL) ,  
        .mask(INTERRUPT_MASK),
        
        .set(ROTATE),
        .reset(!ROTATE),
        
        .aeoi(AEOI_tb),
        .eoi(!AEOI_tb),
        .intAcounter(INTA_COUNT),
        
        //from peripherals
        .i0(IR[0]),
        .i1(IR[1]),
        .i2(IR[2]),
        .i3(IR[3]),
        .i4(IR[4]),
        .i5(IR[5]),
        .i6(IR[6]),
        .i7(IR[7]),

        //Outputs
        .INTtocontrol(INTERNAL_INT),
        .ISRtocontrol(IR_NUM_INTERNAL)
    );

    Control_Unit CL (
        .RD_ENABLE(RD_enable),   		// from read-write logic
        .WR_ENABLE(WR_enable), 
        .DATA(internal_bus),   					// data bus
        .A0(Ao_out),           
        .INTERNAL_INT(INTERNAL_INT),  
        .INTA_(INTA_),       			// ack from processor
        .SP_(SP_),					 	// 1 >> master , 0 >> slave
        .CAS_IN(CAS_IN), 				// for slave 
        .CAS_OUT(CAS_OUT), 				//  for master
        .IR_NUM(IR_NUM_INTERNAL),
        .interrupt_mask(INTERRUPT_MASK),
        .INT(INT),
        .AEOI(AEOI_tb),  
        .INTA_COUNT(INTA_COUNT),
        .R(ROTATE),							    // 0 >> fully-nested
        .sngl(sngl_internal), 					// 0 >> cascaded  
        .LEVEL(LEVEL),
        .RIRR(RIRR_tb),
        .RISR(RISR_tb)
    );

    // WAITING FOR R / SNGL / RIRR / RISR
    // WAITING FOR EOI in interrupt???
endmodule