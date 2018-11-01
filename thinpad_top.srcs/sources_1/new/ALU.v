`default_nettype wire

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    input [5:0] func,
    output reg [31:0] result,
    output zero
    );
    initial begin
        result = 0;
    end
    // if result = 0 then zero = 1 otherwise zero = 0
    // assign is Continuous Assignments
    assign zero = (result? 0 : 1);
    // if A or B or ALUOp change then result change
    always @(A or B or ALUOp or func) begin
        case(ALUOp)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = A | B;
            3'b011: result = (func == 6'b100000 ? A + B : A - B);
            default: result = 0;
        endcase
    end
endmodule
