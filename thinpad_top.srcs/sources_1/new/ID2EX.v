`default_nettype wire

module ID2EX(
    input wire CLK,

    input ALUSrc1,
    output reg ALUSrc1Out,
    
    input ALUSrc2,
    output reg ALUSrc2Out,

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

    input [31:0] RegReadData1,
    output reg [31:0] RegReadData1Out,

    input [31:0] RegReadData2,
    output reg [31:0] RegReadData2Out,

    input [31:0] Immediate,
    output reg [31:0] ImmediateOut,

    input [3:0] Bytelength,
    output reg [3:0] BytelengthOut,

    input [4:0] Reg1,
    output reg [4:0] Reg1Out,

    input [4:0] Reg2,
    output reg [4:0] Reg2Out,

    input [4:0] Reg3,
    output reg [4:0] Reg3Out,

    input [5:0] Func,
    output reg [5:0] FuncOut
    );

    always @(posedge CLK) begin
        ALUSrc1Out <= ALUSrc1;
        ALUSrc2Out <= ALUSrc2;
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
        BytelengthOut <= Bytelength;
        Reg1Out <= Reg1;
        Reg2Out <= Reg2;
        Reg3Out <= Reg3;
        FuncOut <= Func;
    end
endmodule