`timescale 1ns/1ps

module tb ();

reg clk;
reg rst_n;
reg ena;
reg [15:0] a;
reg [15:0] b;
wire [7:0] uo_out;
wire [7:0] uio_out;
wire error_flag_out;

// Instance of top module
tt_um_seven_segment_seconds tt_um_seven_segment_seconds_inst (
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena),
    .a(a),
    .b(b),
    .uo_out(uo_out),
    .uio_out(uio_out),
    .error_flag_out(error_flag_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// Reset logic
initial begin
    rst_n = 0;
    #100;
    rst_n = 1;
end

// Test sequence
initial begin
    ena = 0;
    a = 16'h1234;
    b = 16'h5678;
    #200;
    ena = 1;
    #20;
    ena = 0;
    #100;
    a = 16'hFFFF;
    b = 16'h0001;
    #200;
    ena = 1;
    #20;
    ena = 0;
    
    #1000;
    $finish;
end

endmodule
