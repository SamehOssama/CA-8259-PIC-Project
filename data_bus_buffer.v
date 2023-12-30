module data_bus_buffer (
    inout [7:0] data,
    inout [7:0] internal,
    input r,
    input w
);

    /* reg [7:0] data_reg, internal_reg;

    always @(*) begin
        if (r == 1)
            data_reg <= internal;
        else if (w == 1)
            internal_reg <= data;
        else begin
            data_reg <= data_reg;
            internal_reg <= internal_reg;
        end

    end */

    assign data = r ? internal : 8'bzzzzzzzz;
    assign internal = w ? data : 8'bzzzzzzzz;

endmodule
