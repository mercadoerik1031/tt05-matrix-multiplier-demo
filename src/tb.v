`timescale 1ns/1ps
module tb;

    reg [7:0] ui_in;
    wire [7:0] uo_out;
    reg [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg ena;
    reg clk;
    reg rst_n;

    // Instantiate the Unit Under Test (UUT)
    tt_um_seven_segment_seconds uut (
        .ui_in(ui_in), 
        .uo_out(uo_out), 
        .uio_in(uio_in), 
        .uio_out(uio_out), 
        .uio_oe(uio_oe), 
        .ena(ena), 
        .clk(clk), 
        .rst_n(rst_n)
    );

    initial begin
        // Initialize Inputs
        ui_in = 0;
        uio_in = 0;
        ena = 0;
        clk = 0;
        rst_n = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        ena = 1;
        
        // Add your stimulus here

        // Finish simulation
        #1000;
        $finish;
    end
      
    always #10 clk = !clk; // Clock generator

endmodule
