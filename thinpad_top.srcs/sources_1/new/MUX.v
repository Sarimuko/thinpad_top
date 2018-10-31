module MUX
    #(parameter WIDTH=32)
    (
    input [WIDTH - 1:0] Input0,
    input [WIDTH - 1:0] Input1,
    input Control,
    output [WIDTH - 1:0] S
);
    assign S = (Control == 1'b0 ? Input0 : Input1);
endmodule
