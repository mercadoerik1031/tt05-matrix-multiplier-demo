/*
      -- 1 --
     |       |
     6       2
     |       |
      -- 7 --
     |       |
     5       3
     |       |
      -- 4 --
*/

module seg7_decoder(
    input [3:0] counter,
    output reg [6:0] segments
);

    always @(*) begin
        case(counter)
            4'b0000: segments = 7'b0111111;  // 0
            4'b0001: segments = 7'b0000110;  // 1
            4'b0010: segments = 7'b1011011;  // 2
            4'b0011: segments = 7'b1001111;  // 3
            4'b0100: segments = 7'b1100110;  // 4
            4'b0101: segments = 7'b1101101;  // 5
            4'b0110: segments = 7'b1111101;  // 6
            4'b0111: segments = 7'b0000111;  // 7
            4'b1000: segments = 7'b1111111;  // 8
            default: segments = 7'b0000000;  // Default to off
        endcase
    end

endmodule

module matrixC_to_segments(
    input [7:0] uio_out,  // Upper 8 bits of matrix C
    input [7:0] uo_out,   // Lower 8 bits of matrix C
    output [6:0] seg1,  
    output [6:0] seg2,  
    output [6:0] seg3,  
    output [6:0] seg4
);

    // Directly extract 4-bit elements from matrixC
    wire [3:0] element1 = uio_out[3:0];
    wire [3:0] element2 = uio_out[7:4];
    wire [3:0] element3 = uo_out[3:0];
    wire [3:0] element4 = uo_out[7:4];
    
    // Instantiate the 7-segment decoders
    seg7_decoder decoder1(.counter(element1), .segments(seg1));
    seg7_decoder decoder2(.counter(element2), .segments(seg2));
    seg7_decoder decoder3(.counter(element3), .segments(seg3));
    seg7_decoder decoder4(.counter(element4), .segments(seg4));

endmodule
