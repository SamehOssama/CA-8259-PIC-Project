module initialize_ICW1(
  input wire IC4, // 1 if ICW4 needed
  input wire SNGL, // 1 Single_mode 0 Cascade
  input wire ADI, // 1 interval of 4 - 0 interval of 8
  input wire LTIM, // 1 Level trigger 0 Edge trigger
  input wire d4,  // Must be 1 if you want to use ICW1
  input wire d5, // X in 8086
  input wire d6, // X in 8086
  input wire d7, // X in 8086
  input wire A0 // Must be 0 if you want to use ICW1
);
  
  // Output wire for ICW1
  wire [8:0] icw1;

  // ICW1 generation logic
  assign icw1 = {A0, d7,d6, d5, d4, LTIM, ADI, SNGL, IC4};

  // Display ICW1 on console for verification
  initial begin
    $display("ICW1: %b", icw1);
  end

endmodule

module initialize_ICW2(
  input wire A8, // A10A9A8 -->  to know interrupt number 
  input wire A9, // 000 IR0 111 IR7
  input wire A10,
  input wire T3, // bit 4 in interrupt vector adderss (Mode 8068)
  input wire T4, // bit 5 in interrupt vector adderss (Mode 8068)
  input wire T5, // bit 6 in interrupt vector adderss (Mode 8068)
  input wire T6, // bit 7 in interrupt vector adderss (Mode 8068)
  input wire T7, // bit 8 in interrupt vector adderss (Mode 8068)
  input wire A0  // Must be 1 to Enable ICW2 (The control word is recognized as ICW2 when A0= 1.)
);
  
  // Output wire for ICW2
  wire [8:0] icw2;

  // ICW2 generation logic
  assign icw2 = {A0,T7, T6, T5, T4, T3, A10, A9, A8};

  // Display ICW2 on console for verification
  initial begin
    $display("ICW2: %b", icw2);
  end

endmodule
