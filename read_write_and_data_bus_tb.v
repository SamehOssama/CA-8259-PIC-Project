module Data_With_Read_Write_Logic_tb;
    // READ WRITE LOGIC
    // Inputs
    reg Ao_tb;
    reg reset_tb;
    reg read_flag_tb;
    reg write_flag_tb;
    // Outputs
    wire read_enable_tb;
    wire write_enable_tb;
    reg chip_select_tb;

    // DATA BUS
    // Outputs
    wire [7:0] tb_data_bus;
    wire [7:0] tb_internal_bus;
    // Internal signals for testing
    reg [7:0] tb_data_reg;
    reg [7:0] tb_internal_reg;

    // Instantiate the module
    Read_Write_Logic RWL (
        .RD_(read_flag_tb),
        .WR_(write_flag_tb),
        .A0(Ao_tb),
        .CS_(chip_select_tb),
        .RD(read_enable_tb),
        .WR(write_enable_tb)
    );

    data_bus_buffer DBB (
        .data(tb_data_bus),
        .internal(tb_internal_bus),
        .r(read_enable_tb),
        .w(write_enable_tb)
    );

    // Testing
    assign tb_internal_bus = tb_internal_reg;
    assign tb_data_bus = tb_data_reg;

    // Test stimulus
    initial begin
        // Initialize inputs
        read_flag_tb = 1'b1;
        write_flag_tb = 1'b1;
        chip_select_tb = 1'b1;
        Ao_tb = 1'b1;
        tb_data_reg = 8'bzzzzzzzz;
        tb_internal_reg = 8'bzzzzzzzz;

        // Test Case 1: Perform a read operation
        #10 tb_internal_reg = 8'b00010001;
        #10 chip_select_tb = 1'b0;
        #10 read_flag_tb = 1'b0;
        #10;
        #10 read_flag_tb = 1'b1;
        #10 chip_select_tb = 1'b1;
        #10 tb_internal_reg = 8'bzzzzzzzz;

        // Test Case 2: Perform a write operation
        #10 tb_data_reg = 8'b10101010;
        #10 chip_select_tb = 1'b0;
        #10 write_flag_tb = 1'b0;
        #10;
        #10 write_flag_tb = 1'b1;
        #10 chip_select_tb = 1'b1;
        #10 tb_data_reg = 8'bzzzzzzzz;

        //Test Case 3: Test read and write with high CS
        //Read operation
        #10 tb_data_reg = 8'b10101010;
            tb_internal_reg = 8'b00010001;
        #10 chip_select_tb = 1'b1;
        #10 read_flag_tb = 1'b0;
        #10;
        #10 read_flag_tb = 1'b1;

        //Write operation
        #10 chip_select_tb = 1'b1;
        #10 write_flag_tb = 1'b0;
        #10;
        #10 write_flag_tb = 1'b1;
        #10 tb_data_reg = 8'bzzzzzzzz;
            tb_internal_reg = 8'bzzzzzzzz;
    end


    initial begin
    // End simulation
    $dumpfile("uvm.vcd");
    $dumpvars;
    #1000 $finish;

  end

endmodule