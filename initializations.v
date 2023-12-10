module initialize_ICW1(
  input wire IC4, // 1 if ICW4 needed
  input wire SNGL, // 1 Single_mode 0 Cascade
  input wire ADI, // 1 interval of 4 - 0 interval of 8
  input wire LTIM, // 1 Level trigger 0 Edge trigger
  input wire d4,  // Must be 1 if you want to use ICW1
  input wire d5, // X in 8086
  input wire d6, // X in 8086
  input wire d7, // X in 8086
  input wire A0, // Must be 0 if you want to use ICW1
  output reg [8:0] icw1   // Output reg for ICW1
);

  // ICW1 generation logic
  always @* begin
    icw1 = {A0, d7, d6, d5, d4, LTIM, ADI, SNGL, IC4};
  end

  // Display ICW1 on console for verification
  initial begin
    $display("ICW1: %b", icw1);
  end

endmodule

module initialize_ICW2(
  input wire A8, // A10A9A8 -->  to know interrupt number 
  input wire A9, // 000 IR0 111 IR7
  input wire A10,
  input wire T3, // bit 4 in interrupt vector address
  input wire T4, // bit 5 in interrupt vector address
  input wire T5, // bit 6 in interrupt vector address
  input wire T6, // bit 7 in interrupt vector address
  input wire T7, // bit 8 in interrupt vector address
  input wire A0,  // Must be 1 to Enable ICW2 (The control word is recognized as ICW2 when A0= 1.)
  output reg [8:0] icw2   // Output reg for ICW2
);
  
  // ICW2 generation logic
  always @* begin
    icw2 = {A0, T7, T6, T5, T4, T3, A10, A9, A8};
  end

  // Display ICW2 on console for verification
  initial begin
    $display("ICW2: %b", icw2);
  end

endmodule

module initialize_ICW3(
  input wire SNGL,
  input wire SP,
  input wire [7:0] D,
  input wire [2:0] ID,
  input wire A0,
  output reg [8:0] icw3   // Output reg for ICW3
);

  // ICW3 generation logic
  always @* begin
    // Cascade mode SNGL==0
    if (SNGL == 1'b0) begin
      if (SP == 1'b1) begin
        // Master mode
        icw3 = {A0, D[7:0]};
      end else begin
        // Slave mode
        icw3 = {A0, 3'b0, ID};
      end
    end else begin
      // Single mode mode
      icw3 = 9'bx;
    end
  end

endmodule

module initialize_ICW4(
  input wire IC4,
  input wire [7:0] D,
  input wire UPM,    // 1 8086
  input wire AEOI,   // auto EOI 1 - Normal EOI = 0
  input wire M_S,    // master or slave
  input wire BUF,    // Non-buffered or buffered mode
  input wire SFNM,   // Special fully nested 1 - not special 0
  input wire A0,
  output reg [8:0] icw4   // Output reg for ICW4
);

  // Internal signal for A0 value
  reg internal_A0;

  // ICW4 generation logic
  always @* begin
    // IC4 = 1, we Use ICW4
    if (IC4 == 1'b1) begin
      internal_A0 = 1'b1;
      icw4 = {internal_A0, D[7:0]};
    end else begin
      internal_A0 = 1'bx;
      icw4 = 9'bx;
    end
  end

endmodule
