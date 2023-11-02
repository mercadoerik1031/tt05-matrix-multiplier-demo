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

    reg [3:0] result11, result12, result21, result22;

    reg [3:0] result11, result12, result21, result22;

    always @(posedge clock) begin
        if (reset) begin
            // Reset logic
        end
        else begin
            // Compute intermediate results
            result11 = matrix_a[0] * matrix_b[0] + matrix_a[1] * matrix_b[2];
            result12 = matrix_a[0] * matrix_b[1] + matrix_a[1] * matrix_b[3];
            result21 = matrix_a[2] * matrix_b[0] + matrix_a[3] * matrix_b[2];
            result22 = matrix_a[2] * matrix_b[1] + matrix_a[3] * matrix_b[3];

            // Concatenate results
            uo_out = {result11, result12};
            uio_out = {result21, result22};
        end
    end

endmodule



    // Set uio_oe as outputs after multiplication
    assign uio_oe = (ena) ? 8'b11111111 : 8'b00000000;

endmodule
