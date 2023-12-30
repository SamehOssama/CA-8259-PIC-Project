module data_bus_buffer_tb;
    // Inputs
    reg tb_r;
    reg tb_w;


    // Outputs
    wire [7:0] tb_data_bus;
    wire [7:0] tb_internal_bus;

    // Internal signals for testing
    reg [7:0] tb_data_reg = 8'b10101010;
    reg [7:0] tb_internal_reg = 8'b00010001;
    reg set_data = 0;
    reg set_internal = 1;


    // Instantiate the module under test
    data_bus_buffer dut (
        .data(tb_data_bus),
        .internal(tb_internal_bus),
        .r(tb_r),
        .w(tb_w)
    );

    assign tb_internal_bus = set_internal? tb_internal_reg : 8'bzzzzzzzz;
    assign tb_data_bus = set_data? tb_data_reg : 8'bzzzzzzzz;

    // Initialize signals
    initial begin
        tb_r = 0;
        tb_w = 0;
    end

    always begin
    // Test read operation
        #5 tb_r = 1;
        #5 tb_r = 0;
        #0 set_internal = 0;

    // Test write operation
        #5 set_data = 1;
        #5 tb_w = 1;
        #5 tb_w = 0;
        #0 set_data = 0;
        #5 set_internal = 1;
    end

    // Monitor
    always @(*) begin
        $display("data = %b : internal = %b", tb_data_bus, tb_internal_bus);
    end

endmodule
