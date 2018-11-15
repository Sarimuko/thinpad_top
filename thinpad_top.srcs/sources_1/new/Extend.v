`default_nettype wire

module Extend(
    input [15:0] extInput,
    input sign,
    output [31:0] S
    );
    
    assign S = (((sign == 1'b1) && (extInput[15] == 1'b1)) ? {16'b1, extInput} : {16'b0, extInput});

endmodule
