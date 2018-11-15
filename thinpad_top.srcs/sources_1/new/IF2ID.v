`default_nettype wire

module IF2ID(
    input wire CLK,
    input wire [31:0] DefaultNxtPC,
    output reg [31:0] DefaultNxtPCOut,

    input wire [31:0] Instruction,
    output reg [31:0] InstructionOut

    );

    always @(posedge CLK) begin
        InstructionOut <= Instruction;
        DefaultNxtPCOut <= DefaultNxtPC;
    end
endmodule