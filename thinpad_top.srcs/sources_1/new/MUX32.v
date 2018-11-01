`default_nettype wire

module MUX32
    (
    input [31:0] Input0,
    input [31:0] Input1,
    input Control,
    output [31:0] S
);
    assign S = (Control == 1'b0 ? Input0 : Input1);
endmodule
