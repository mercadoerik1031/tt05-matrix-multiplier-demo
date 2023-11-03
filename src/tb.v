`default_nettype none
`timescale 1ns/1ps

module tb ();

    // Variables declaration and initialization
    reg clk = 0;
    reg rst_n = 0;
    reg ena = 0;
    reg [7:0] ui_in = 0;
    reg [7:0] uio_in = 0;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // dumps a vcd file
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // Generate a clock signal
    always #5 clk = ~clk;

    tt_um_matrix_multiplier tt_um_matrix_multiplier (
        .ui_in      (ui_in),
        .uo_out     (uo_out),
        .uio_in     (uio_in),
        .uio_out    (uio_out),
        .uio_oe     (uio_oe),
        .ena        (ena),
        .clk        (clk),
        .rst_n      (rst_n)
    );

endmodule