`default_nettype wire

module ID2EX(
    input wire CLK,

    input ALUSrc,
    output reg ALUSrcOut,

    input [2:0] ALUOp,
    output reg [2:0] ALUOpOut,

    input RegDst,
    output reg RegDstOut,

    input Branch,
    output reg BranchOut,

    input MemRead,
    output reg MemReadOut,

    input MemWrite,
    output reg MemWriteOut,

    input MemtoReg,
    output reg MemtoRegOut,

    input RegWrite,
    output reg RegWriteOut,

    /*input JumpTarget,
    output reg JumpTargetOut,*/

    input RegReadData1,
    output reg RegReadData1Out,

    input RegReadData2,
    output reg RegReadData2Out,

    input [31:0] Immediate,
    output reg [31:0] ImmediateOut,

    input [4:0] Reg2,
    output reg [4:0] Reg2Out,

    input [4:0] Reg3,
    output reg [4:0] Reg3Out,

    input [5:0] Func,
    output reg [5:0] FuncOut,
    );

    always @(posedge CLK) begin
        ALUSrcOut <= ALUSrc;
        ALUOpOut <= ALUOp;
        RegDstOut <= RegDst;
        BranchOut <= Branch;
        MemReadOut <= MemRead;
        MemWriteOut <= MemWrite;
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        RegReadData1Out <= RegReadData1;
        RegReadData2Out <= RegReadData2;
        ImmediateOut <= Immediate;
        Reg2Out <= Reg2;
        Reg3Out <= Reg3;
        FuncOut <= Func;
    end
  end
endmodule