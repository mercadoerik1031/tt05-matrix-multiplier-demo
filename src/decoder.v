
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

module seg7(
    input [7:0] matrixC,    // Assuming this is the result from your matrix multiplier
    output reg [6:0] seg1,  // 7-segment pattern for first matrix element
    output reg [6:0] seg2,  // 7-segment pattern for second matrix element
    output reg [6:0] seg3,  // 7-segment pattern for third matrix element
    output reg [6:0] seg4,  // 7-segment pattern for fourth matrix element
    output reg isNegative1, // '1' if first matrix element is negative
    output reg isNegative2, 
    output reg isNegative3, 
    output reg isNegative4  
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
    seg7 decoder1(.counter(absElement1), .segments(seg1));
    seg7 decoder2(.counter(absElement2), .segments(seg2));
    seg7 decoder3(.counter(absElement3), .segments(seg3));
    seg7 decoder4(.counter(absElement4), .segments(seg4));

endmodule
