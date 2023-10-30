`default_nettype none
`timescale 1ns/1ps

module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // Generate a clock signal
    initial clk = 0;
    always #5 clk = ~clk;

    // Generate a reset signal (active low for a short duration, then remains high)
    initial begin
        rst_n = 0;
        #10;
        rst_n = 1;
    end

    // wire up the inputs and outputs
    reg  clk;
    reg  rst_n;
    reg  ena;
    reg  [7:0] matrixA_in;
    reg  [7:0] matrixB_in;

    wire [7:0] matrixC_uo_out;
    wire [7:0] matrixC_uio_out;
    wire [7:0] matrixC_uio_oe;

    tt_um_seven_segment_seconds tt_um_seven_segment_seconds (
        .ui_in      (matrixA_in),     // Dedicated inputs for Matrix A
        .uo_out     (matrixC_uo_out), // Dedicated outputs for Matrix C elements
        .uio_in     (matrixB_in),     // IOs: Input path for Matrix B
        .uio_out    (matrixC_uio_out),// IOs: Output path for Matrix C elements
        .uio_oe     (matrixC_uio_oe), // IOs: Enable path 
        .ena        (ena),            // enable - goes high when design is selected
        .clk        (clk),            // clock
        .rst_n      (rst_n)           // not reset
        );

endmodule
