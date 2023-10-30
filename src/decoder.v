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
    input [1:0] counter,
    output reg [6:0] segments
);

    always @(*) begin
        case(counter)
            2'b00: segments = 7'b0111111;  // 0
            2'b01: segments = 7'b0000110;  // 1
            2'b10: segments = 7'b1011011;  // 2
            2'b11: segments = 7'b1001111;  // 3
            default: segments = 7'b0000000; // Default to off
        endcase
    end

endmodule

module matrixC_to_segments(
    input [7:0] matrixC,  
    output [6:0] seg1,  
    output [6:0] seg2,  
    output [6:0] seg3,  
    output [6:0] seg4,  
    output isNegative1, 
    output isNegative2, 
    output isNegative3, 
    output isNegative4  
);

    wire [1:0] element1 = matrixC[1:0];
    wire [1:0] element2 = matrixC[3:2];
    wire [1:0] element3 = matrixC[5:4];
    wire [1:0] element4 = matrixC[7:6];
    
    // Extract absolute values and signs
    wire [3:0] absElement1 = (element1 < 0) ? -element1 : element1;
    wire [3:0] absElement2 = (element2 < 0) ? -element2 : element2;
    wire [3:0] absElement3 = (element3 < 0) ? -element3 : element3;
    wire [3:0] absElement4 = (element4 < 0) ? -element4 : element4;

    assign isNegative1 = (element1 < 0);
    assign isNegative2 = (element2 < 0);
    assign isNegative3 = (element3 < 0);
    assign isNegative4 = (element4 < 0);
    
    // Instantiate the 7-segment decoders
    seg7_decoder decoder1(.counter(absElement1), .segments(seg1));
    seg7_decoder decoder2(.counter(absElement2), .segments(seg2));
    seg7_decoder decoder3(.counter(absElement3), .segments(seg3));
    seg7_decoder decoder4(.counter(absElement4), .segments(seg4));

endmodule
