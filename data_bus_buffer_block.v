module tri_state_buffer (
    input enable, in;
    output out;
);

    always @(enable) begin
        if (enable) out <= in;
        else out <= 1'bZ
    end

endmodule


module bidirectional_tri_state_buffer (
    input enable;
    inout A, B;
);

    tri_state_buffer rd (.enable(enable), .in(A) , .out(B));
    tri_state_buffer rd (.enable(!enable), .in(B) , .out(A));

endmodule


module data_bus_buffer (
    input enable;
    inout [7:0] D, I;
);

    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin: 
            bidirectional_tri_state_buffer buff (
                .enable(enable)
                ,.A(D[i])
                ,.B(I[i])
            );
        end
    endgenerate

endmodule