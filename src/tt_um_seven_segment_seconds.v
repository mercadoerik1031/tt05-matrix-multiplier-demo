`default_nettype none

module tt_um_seven_segment_seconds(
    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,
    input  wire [7:0] uio_in,
    output reg  [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire reset = !rst_n;
    wire error_flag;
    
    // Split ui_in for Matrix A elements
    wire signed [1:0] a11 = ui_in[1:0];
    wire signed [1:0] a12 = ui_in[3:2];
    wire signed [1:0] a21 = ui_in[5:4];
    wire signed [1:0] a22 = ui_in[7:6];

    // Set uio_in as input initially
    // assign uio_in = 8'b00000000;

    // Split uio_in for Matrix B elements
    wire signed [1:0] b11 = uio_in[1:0];
    wire signed [1:0] b12 = uio_in[3:2];
    wire signed [1:0] b21 = uio_in[5:4];
    wire signed [1:0] b22 = uio_in[7:6];

    // Check all aij & bij in range (-2, 2)
    assign error_flag = (a11 <= -2 || a11 >= 2) ||
                        (a12 <= -2 || a12 >= 2) ||
                        (a21 <= -2 || a21 >= 2) ||
                        (a22 <= -2 || a22 >= 2) ||
                        (b11 <= -2 || b11 >= 2) ||
                        (b12 <= -2 || b12 >= 2) ||
                        (b21 <= -2 || b21 >= 2) ||
                        (b22 <= -2 || b22 >= 2);

    always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        uo_out <= 8'b0;
        uio_out <= 8'b0;
    end else if (ena) begin
        $display("a11=%b, a12=%b, b11=%b, b12=%b", a11, a12, b11, b12)
        if (error_flag) begin
            uo_out <= 8'b0;
            uio_out <= 8'b0;
        end else begin
            // 2 x 2 matrix multiplication logic
            uo_out[3:0] <= a11 * b11 + a12 * b21;
            uo_out[7:4] <= a11 * b12 + a12 * b22;
            uio_out[3:0] <= a21 * b11 + a22 * b21;
            uio_out[7:4] <= a21 * b12 + a22 * b22;
        end
    end
end

    // Set uio_eo as outputs after multiplication
    assign uio_oe = (ena) ? 8'b11111111 : 8'b00000000;

endmodule