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
