module tt_um_seven_segment_seconds(
    input              clk,
    input              rst_n,
    input              ena,
    input      [15:0]  a,
    input      [15:0]  b,
    output reg [7:0]   uo_out,
    output reg [7:0]   uio_out,
    output reg         error_flag_out
);

reg [31:0] product;
reg error_flag;

always @(posedge clk) begin
    if (!rst_n) begin
        uo_out <= 8'b0;
        uio_out <= 8'b0;
        error_flag_out <= 0;
    end else if (ena) begin
        product = a * b;
        error_flag = product[31:16] ? 1'b1 : 1'b0;
        error_flag_out <= error_flag;

        if (!error_flag) begin
            uo_out <= product[15:8];
            uio_out <= product[7:0];
        end else begin
            uo_out <= 8'b0;
            uio_out <= 8'b0;
        end
    end
end

endmodule
