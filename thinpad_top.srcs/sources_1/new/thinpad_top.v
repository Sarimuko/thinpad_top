`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz 时钟输入
    input wire reset_btn,         //BTN6手动复位按钮�?关，带消抖电路，按下时为1
    output wire[7:0] OutReg0,
    output wire[7:0] OutReg1,
    output wire[7:0] OutReg2,
    output wire[7:0] OutReg3,
    output wire[7:0] OutReg4,
    output wire[7:0] OutMem0,
    output wire[7:0] OutMem1,
    output wire[7:0] OutMem2,
    output wire[7:0] OutMem3,
    output wire[7:0] OutMem4,
    output wire[7:0] OutMem5,
    output wire[7:0] OutMem6,
    output wire[7:0] OutMem7,
    output wire [31:0] outPC,
    output wire [31:0] outInstruction,
    inout wire RegDst,
    inout wire ALUSrc,
    inout wire MemtoReg,
    inout wire RegWrite,
    inout wire MemWrite,
    inout wire MemRead,
    inout wire Branch,
    inout wire Jump,
    inout wire ExtOp,
    inout wire [2:0] ALUOp
);

wire CLK;
assign CLK = clk_50M;

wire [31:0] CurPC, DefaultNxtPC, Instruction;
wire [31:0] ALUResult;

wire [31:0] RegReadData1, RegReadData2, RegWriteData, Immediate;
wire [4:0] Reg1, Reg2, Reg3, RegWriteAddr;
wire [31:0] ALUInput1, ALUInput2, RAMWriteData, RAMReadData;

wire ALUzero;
wire [31:0] JumpTarget, BeqTarget, BranchResult, PCResult;
wire [5:0] Func;

assign Reg1 = Instruction[25:21];
assign Reg2 = Instruction[20:16];
assign Reg3 = Instruction[15:11];
assign Func = Instruction[5:0];

assign outPC = CurPC;
assign outInstruction = Instruction;

/* =========== Pipeline CPU =========== */


/* =========== PC & InstMEM =========== */

//MUX32 MUX_Jump(BranchResult, JumpTarget, Jump, PCResult);

assign PCResult = DefaultNxtPC;

PC PC(CLK, reset_btn, PCResult, CurPC);

assign DefaultNxtPC = CurPC + 4;

InstMEM InstMEM(CurPC, Instruction);

// assign IF2ID = {DefaultNxtPC, Instruction};

/* =========== Reg & Control =========== */

ControlUnit ControlUnit(
    .CLK(CLK), 
    .Instruction(Instruction),
    .RegDst(exRegDst),
    .ALUSrc(exALUSrc),
    .MemtoReg(exMemtoReg),
    .RegWrite(exRegWrite),
    .MemWrite(exMemWrite),
    .MemRead(exMemRead),
    .Branch(exBranch),
    .Jump(exJump),
    .ExtOp(exExtOp),
    .ALUOp(exALUOp)
);

Register Register(
    .CLK(CLK),
    .ReadReg1(Reg1),
    .ReadReg2(Reg2),
    .WriteReg(RegWriteAddr),
    .RegWe(RegWrite),
    .WriteData(RegWriteData),
    .ReadData1(RegReadData1),
    .ReadData2(RegReadData2),
    .Reg0(OutReg0),
    .Reg1(OutReg1),
    .Reg2(OutReg2),
    .Reg3(OutReg3),
    .Reg4(OutReg4)
);

Extend Extend(
    .CLK(CLK),
    .extInput(Instruction[15:0]),
    .sign(ExtOp),
    .S(Immediate)
);

ID2EX ID2EX(
    .CLK(CLK),
    .DefaultNxtPC(DefaultNxtPC),
    .DefaultNxtPCOut(exDefaultNxtPC),
    .Reg2(Instruction[20:16]),
    .Reg2Out(exReg2),
    .Reg3(Instruction[20:16]),
    .Reg3Out(exReg3)
);

/*
assign ID2EX = {
    RegWrite,
    MemtoReg,
    Branch,
    MemRead,
    MemWrite,
    RegDst,
    ALUOp,
    ALUSrc,
    defaultPC,
    RegReadData1,
    RegReadData2,
    Immediate,
    Reg2,
    Reg3
}
*/

/* =========== ALU =========== */


MUX32 MUX_ALUSrc(RegReadData2, Immediate, ALUSrc, ALUInput2);

ALU ALU(
    .CLK(CLK),
    .A(RegReadData1),
    .B(ALUInput2),
    .ALUOp(ALUOp),
    .func(Func),
    .result(ALUResult),
    .zero(ALUzero)
);

//assign BeqTarget = DefaultNxtPC + (Immediate << 2);
BeqJumper BeqJumper(
    .CLK(CLK),
    .DefaultNxtPC(exDefaultNxtPC),
    .Immediate(Immediate),
    .BeqTarget(BeqTarget)
)

MUX5 MUX_RegDst(Reg2, Reg3, RegDst, RegWriteAddr);

//assign JumpTarget = {CurPC[31:28], Instruction[25:0], 2'b00};

EX2MEM EX2MEM(
    .CLK(CLK),
    .RegWrite(exRegWrite),
    .RegWriteOut(memRegWrite),
    .MemtoReg(exMemtoReg),
    .MemtoRegOut(memMemtoReg),
    .Branch(exBranch),
    .BranchOut(memBranch),
    .MemRead(exMemRead),
    .MemReadOut(memMemRead),
    .MemWrite(exMemWrite),
    .MemWriteOut(memMemWrite),
    .JumpTarget(JumpTarget),
    .JumpTargetOut(memJumpTarget),
    .RegReadData2(RegReadData2),
    .RegReadData2Out(memRegReadData2)
);

/*
assign EX2MEM = {
    RegWrite,
    MemtoReg,
    Branch,
    MemRead,
    MemWrite,
    JumpTarget,
    Zero,
    ALUResult,
    RegReadData2,
    Reg23
}
*/

/* =========== Data =========== */

DataMem DataMem(CLK, MemWrite, MemRead, ALUResult, RegReadData2, RAMReadData, OutMem0, OutMem1, OutMem2, OutMem3, OutMem4, OutMem5, OutMem6, OutMem7);

MUX32 MUX_Branch(DefaultNxtPC, BeqTarget, ALUzero & Branch, BranchResult);

MEM2WB MEM2WB(
    .CLK(CLK),
    .MemtoReg(memMemtoReg),
    .MemtoRegOut(wbMemtoReg),
    .RegWrite(memRegWrite),
    .RegWriteOut(wbRegWrite),
    .ALUResult(memALUResult),
    .ALUResultOut(wbALUResult)
);

/*
assign MEM2WB = {
    RegWrite,
    MemtoReg,
    RAMReadData,
    ALUResult
}
*/

/* =========== Write Back =========== */

MUX32 MUX_MemtoReg(ALUResult, RAMReadData, MemtoReg, RegWriteData);

endmodule
