module Read_Write_Logic (
    input A0, CS_, WR_, RD_,
    output reg WR, RD, A0_out
);

    always @(*) begin
        A0_out <= A0;

        if (!CS_ && !WR_ && !RD_) begin
            WR <= 1'b0;
            RD <= 1'b0;
        end else if (!CS_ && !WR_) begin
            WR <= 1'b1;
            RD <= 1'b0;
        end else if (!CS_ && !RD_) begin
            WR <= 1'b0;
            RD <= 1'b1;
        end else begin
            WR <= 1'b0;
            RD <= 1'b0;
        end
    end
endmodule
