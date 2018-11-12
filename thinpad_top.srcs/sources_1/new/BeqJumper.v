`default_nettype wire

module BeqJumper
(
    input CLK,
    input [31:0] DefaultNxtPC,
    input [31:0] Immediate,
    output reg [31:0] BeqTarget
);
    always @(posedge CLK) begin
        BeqTarget <= DefaultNxtPC + (Immediate << 2);
    end
endmodule
