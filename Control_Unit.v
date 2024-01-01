module Control_Unit (
input WR_ENABLE,
input RD_ENABLE,
inout [7:0] DATA,           // data bus
input A0,           
input INTERNAL_INT,  
input INTA_,                // ack from processor
input SP_,                  // 1 >> master , 0 >> slave
input [2:0] CAS_IN,         // for slave 
input [2:0]IR_NUM,
output reg [2:0] CAS_OUT,   //  for master
output reg [7:0] interrupt_mask,
output reg INT,
output reg AEOI,  
output reg  [1:0] INTA_COUNT,
output wire R,              // 0 >> fully-nested
output wire sngl,           // 0 >> cascaded  
output wire LEVEL,
output reg RIRR,
output reg RISR
);

    parameter [2:0] ICW1 = 3'b000;
    parameter [2:0] ICW2 = 3'b001;
    parameter [2:0] ICW3 = 3'b010;
    parameter [2:0] ICW4 = 3'b011;
    parameter [2:0] ready = 3'b111;
    parameter [2:0] interrupt_state = 3'b101;

    reg [2:0] state = ICW1;
    reg t;

    reg [7:0] ICW1_REG;
    reg [7:0] ICW2_REG;
    reg [7:0] ICW3_REG;
    reg [7:0] ICW4_REG; 
    reg [7:0] OCW2_REG;
    reg [7:0] OCW3_REG;
    reg [7:0] DATA_REG;

    reg got_ocw2 = 1'b0;
    parameter [1:0] OCW1 = 2'b00;
    parameter [1:0] OCW2 = 2'b01;
    parameter [1:0] OCW3 = 2'b10;

    assign DATA = (RD_ENABLE)? DATA_REG : 8'bzzzzzzzz;

    // ICW
    always @(posedge WR_ENABLE) begin
        case (state)
            ICW1: begin
                if (!A0 && DATA[4]) begin 
                    state <= ICW2;
                    ICW1_REG <= DATA;
                    ICW3_REG <= 8'b1000000;
                    interrupt_mask <= 8'b00000000;
                    OCW3_REG <= 8'b00001010;
                    if (!DATA[0]) ICW4_REG <= 8'b00000000;
                end else state <= ICW1;            
            end
            ICW2: begin
                if (A0) begin
                    if (!ICW1_REG[1]) state <= ICW3;
                    else if (ICW1_REG[0]) state <= ICW4;
                    else state <= ready;
                    ICW2_REG <= DATA;
                end else state <= ICW2;
            end
            ICW3: begin
                if (A0) begin
                    if (ICW1_REG[0]) state <= ICW4;
                    else state <= ready;
                    ICW3_REG <= DATA;
                end else state <= ICW3;
            end
            ICW4: begin
                if (A0) begin
                    state <= ready;
                    ICW4_REG <= DATA;
                end else state <= ICW3;
            end
            default: t <= t;
        endcase
    end

    // ICW1 data
    assign sngl = ICW1_REG[1];
    assign LEVEL = ICW1_REG[3];

    // ICW2 data
    wire [4:0] upper_address;
    assign upper_address = ICW2_REG[7:3];


    // ICW4 data
    wire ocw2_EOI,ICW4_AEOI;
    assign ICW4_AEOI = ICW4_REG[1];


    // OCW
    always @(posedge WR_ENABLE) begin
        if(state == ready) begin
            if (A0 == 1) begin
                interrupt_mask <= DATA;
            end
            else begin
                if(DATA[4] == 0) begin
                    if(DATA[3]==0) begin
                        OCW2_REG <= DATA;
                        got_ocw2 <= 1'b1;
                    end 
                    else begin
                        OCW3_REG <= DATA;
                    end
                end
                else
                    state <= state;
            end
        end else
            t <= t;
    end



    assign R = OCW2_REG[7];
    assign ocw2_EOI = OCW2_REG[5];

    wire RR,RIS;
    assign RR = OCW3_REG[1];
    assign RIS = OCW3_REG[0];


    // start interrupt
    always @(INTERNAL_INT) begin
        if(state == ready) begin
            if(INTERNAL_INT == 1) begin
                state <= interrupt_state;
                INT <= 1;
                INTA_COUNT <= 2'b00;
            end 
        end else
            t <= t;
    end



    // interrupt acknowledge
    always @(negedge INTA_) begin
        if(state == interrupt_state) begin
            if(INTA_COUNT == 2'b00) begin
                INTA_COUNT <= 2'b01;
                DATA_REG <= 8'bzzzzzzzz;
            end
            else begin
                if(sngl)
                    DATA_REG <= {upper_address,IR_NUM};
                else if(CAS_IN == ICW3_REG[2:0] && SP_ == 1'b1)
                    DATA_REG <= {upper_address,IR_NUM};
                state <= ready;
                INT <= 0;
                INTA_COUNT <= 2'b10;
                if(got_ocw2)
                    AEOI <= !ocw2_EOI;
                else
                    AEOI <= ICW4_AEOI;
            end
        end 
        else 
            t <= t;
    end


    // read block
    always @(posedge RD_ENABLE) begin
        if(state == ready) begin
            if(A0 == 1) begin
                DATA_REG <= interrupt_mask;
            end
            else begin
                if(RR) begin
                    if(RIS) begin
                        RIRR <= 1'b0;
                        RISR <= 1'b1;
                    end
                    else begin
                        RIRR <= 1'b1;
                        RISR <= 1'b0;
                    end
                end
                else
                    DATA_REG <= DATA_REG;
            end
        end
        else 
        t <= t;
    end

    always @(posedge INTA_) begin
        if(INTA_COUNT == 2'b01 && SP_ == 1'b0) 
            CAS_OUT <= IR_NUM;
        else if(INTA_COUNT == 2'b10 && SP_ == 1'b0) 
            CAS_OUT <= 0'b000;
        else
            CAS_OUT <= CAS_OUT;
    end

endmodule
