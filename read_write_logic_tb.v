module Read_Write_Logic_tb;

    reg read_flag_tb;
    reg write_flag_tb;
    reg Ao_tb;
    reg chip_select_tb;
    wire read_enable_tb;
    wire write_enable_tb;
    wire A0_out_tb;


    // Instantiate the module
    Read_Write_Logic dut (
        .RD_(read_flag_tb),
        .WR_(write_flag_tb),
        .A0(Ao_tb),
        .CS_(chip_select_tb),
        .RD(read_enable_tb),
        .WR(write_enable_tb),
        .A0_out(A0_out_tb)
    );


    // Test stimulus
    initial begin
        // Initialize inputs
        read_flag_tb = 1'b1;
        write_flag_tb = 1'b1;
        chip_select_tb = 1'b1;
        Ao_tb = 1'b1;

        // Test Case 1: Perform a read operation
        #10 chip_select_tb = 1'b0;
        #10 read_flag_tb = 1'b0;
        #10;
        #10 read_flag_tb = 1'b1;

        // Test Case 2: Perform a write operation
        #10 chip_select_tb = 1'b0;
        #10 write_flag_tb = 1'b0;
        #10 write_flag_tb = 1'b1;
        #10 write_flag_tb = 1'b0;
        #10 write_flag_tb = 1'b1;
        #10 chip_select_tb = 1'b1;
        
        // Test Case 3: Perform write and read operations together
        #10 chip_select_tb = 1'b0;
        #10 write_flag_tb = 1'b0;
            read_flag_tb = 1'b0;
        #10;
        #10 read_flag_tb = 1'b1;
        #10 write_flag_tb = 1'b1;

        //Test Case 4: Test read and write with high CS 
        //Read operation 
        #10 chip_select_tb = 1'b1;
        #10 read_flag_tb = 1'b0;
        #10;
        #10 read_flag_tb = 1'b1;

        //Write operation
        #10 chip_select_tb = 1'b1;
        #10 write_flag_tb = 1'b0;
        #10;
        #10 write_flag_tb = 1'b1;
    end


    initial begin
        // End simulation
        $dumpfile("uvm.vcd");
        $dumpvars;
        #1000 $finish; 
    end

endmodule
