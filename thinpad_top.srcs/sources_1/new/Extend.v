`default_nettype wire

module Extend(
    input CLK,
    input [15:0] extInput,
    input sign,
    output reg [31:0] S
    );
    always @(posedge CLK) begin
        S <= (((sign == 1'b1) && (extInput[15] == 1'b1)) ? {16'b1, extInput} : {16'b0, extInput});
    end
endmodule
