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

    // Initialization of Signals
    initial begin
        ena = 0;
        matrixA_in = 8'b00000000; // Initial value: all zeros
        matrixB_in = 8'b00000000; // Initial value: all zeros
    end

    // Test Vectors for the design
    initial begin
        #15;
        ena = 1;
        matrixA_in = 8'b01101110; // Example value: 1, 1, -1, 2
        matrixB_in = 8'b11010101; // Example value: -1, 1, -1, 1
        #10;
        matrixA_in = 8'b10011001; // Another example value: 2, -1, -1, -1
        matrixB_in = 8'b01100110; // Another example value: 1, 0, 1, 2
        #10;
        ena = 0;
        #10;
        ena = 1;
        matrixA_in = 8'b10110101; // Yet another example value: 2, 1, -1, 1
        matrixB_in = 8'b01101101; // Yet another example value: 1, 1, 1, -1
        #100;
        $finish;  // End the simulation after some time
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
