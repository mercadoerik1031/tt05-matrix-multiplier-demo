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
    
    // Split ui_in for Matrix A elements (unsigned 2-bit numbers)
    wire [1:0] a11 = ui_in[1:0];
    wire [1:0] a12 = ui_in[3:2];
    wire [1:0] a21 = ui_in[5:4];
    wire [1:0] a22 = ui_in[7:6];

    // Split uio_in for Matrix B elements (unsigned 2-bit numbers)
    wire [1:0] b11 = uio_in[1:0];
    wire [1:0] b12 = uio_in[3:2];
    wire [1:0] b21 = uio_in[5:4];
    wire [1:0] b22 = uio_in[7:6];

    // Check all aij & bij in range [0, 2]
    assign error_flag = (a11 > 2'b10) || (a12 > 2'b10) || (a21 > 2'b10) || (a22 > 2'b10) ||
                    (b11 > 2'b10) || (b12 > 2'b10) || (b21 > 2'b10) || (b22 > 2'b10);


    // Synchronous operations with clock
    always @(posedge clk) begin
        if (reset) begin
            uo_out <= 8'b0;
            uio_out <= 8'b0;
        end else if (ena) begin
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

    // Set uio_oe as outputs after multiplication
    assign uio_oe = (ena) ? 8'b11111111 : 8'b00000000;

endmodule
