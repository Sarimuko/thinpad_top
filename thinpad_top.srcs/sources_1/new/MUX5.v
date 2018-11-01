`default_nettype wire

module MUX5
    (
    input [4:0] Input0,
    input [4:0] Input1,
    input Control,
    output [4:0] S
);
    assign S = (Control == 1'b0 ? Input0 : Input1);
endmodule
