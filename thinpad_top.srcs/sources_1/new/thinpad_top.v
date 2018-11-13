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
);

wire CLK;
assign CLK = clk_50M;

//wire [31:0] CurPC, DefaultNxtPC, Instruction;
//wire [31:0] ALUResult;

//wire [31:0] RegReadData1, RegReadData2, RegWriteData, Immediate;
//wire [4:0] Reg1, Reg2, Reg3, RegWriteAddr;
//wire [31:0] ALUInput1, ALUInput2, RAMWriteData, RAMReadData;

//wire ALUZero;
//wire [31:0] JumpTarget, BeqTarget, BranchResult, PCResult;
//wire [5:0] Func;

//assign Reg1 = Instruction[25:21];
//assign Reg2 = Instruction[20:16];
//assign Reg3 = Instruction[15:11];
//assign Func = Instruction[5:0];

assign outPC = CurPC;
assign outInstruction = Instruction;

/* =========== Pipeline CPU =========== */





/* =========== PC & InstMEM =========== */

//MUX32 MUX_Jump(BranchResult, JumpTarget, Jump, PCResult);

wire [31:0] PCResult, CurPC;
wire [31:0] ifDefaultNxtPC, ifInstruction;
wire [31:0] idDefaultNxtPC, idInstruction;

assign PCResult = ifDefaultNxtPC;

//PC PC(CLK, reset_btn, PCResult, CurPC);

assign CurPC = reset_btn ? 0 : PCResult;

assign ifDefaultNxtPC = CurPC + 4;

InstMEM InstMEM(
    .addr(CurPC),
    .Instruction(ifInstruction)
);

ID2EX ID2EX(
    .CLK(CLK),
    .DefaultNxtPC(ifDefaultNxtPC),
    .DefaultNxtPCOut(idDefaultNxtPC),
    .Instruction(ifInstruction),
    .InstructionOut(idInstruction)
);





/* =========== Reg & Control =========== */

wire idRegDst, exRegDst;
wire idALUSrc, exALUSrc;
wire idMemtoReg, exMemtoReg;
wire idRegWrite, exRegWrite;
wire idMemWrite, exMemWrite;
wire idMemRead, exMemRead;
wire idBranch, exBranch;
wire idJump, exJump;
wire idExtOp, exExtOp;
wire [2:0] idALUOp, exALUOp;
wire [31:0] idImmediate, exImmediate;
wire [31:0] idRegReadData1, exRegReadData1;
wire [31:0] idRegReadData2, exRegReadData2;
wire [4:0] exReg2, exReg3;
wire [5:0] exFunc;

ControlUnit ControlUnit(
    .Instruction(idInstruction),
    .RegDst(idRegDst),
    .ALUSrc(idALUSrc),
    .MemtoReg(idMemtoReg),
    .RegWrite(idRegWrite),
    .MemWrite(idMemWrite),
    .MemRead(idMemRead),
    .Branch(idBranch),
    .Jump(idJump),
    .idtOp(idExtOp),
    .ALUOp(idALUOp)
);

assign idReg1 = idInstruction[25:21];
assign idReg2 = idInstruction[20:16];
assign idReg3 = idInstruction[15:11];
assign idFunc = idInstruction[5:0];

Register Register(
    .CLK(CLK),
    .ReadReg1(idReg1),
    .ReadReg2(idReg2),
    .WriteReg(idRegWriteAddr),
    .RegWe(idRegWrite),
    .WriteData(idRegWriteData),
    .ReadData1(idRegReadData1),
    .ReadData2(idRegReadData2),
    .Reg0(OutReg0),
    .Reg1(OutReg1),
    .Reg2(OutReg2),
    .Reg3(OutReg3),
    .Reg4(OutReg4)
);

Extend Extend(
    .extInput(idInstruction[15:0]),
    .sign(idExtOp),
    .S(idImmediate)
);

ID2EX ID2EX(
    .CLK(CLK),
    .ALUSrc(idALUSrc),
    .ALUSrcOut(exALUSrc),
    .ALUOp(idALUOp),
    .ALUOpOut(exALUOp),
    .RegDst(idRegDst),
    .RegDstOut(exRegDst),
    .Branch(idBranch),
    .BranchOut(exBranch),
    .MemRead(idMemRead),
    .MemReadOut(exMemRead),
    .MemWrite(idMemWrite),
    .MemWriteOut(exMemWrite),
    .MemtoReg(idMemtoReg),
    .MemtoRegOut(exMemtoReg),
    .RegWrite(idRegWrite),
    .RegWriteOut(exRegWrite),
    .RegReadData1(idRegReadData1),
    .RegReadData1Out(exRegReadData1),
    .RegReadData2(idRegReadData2),
    .RegReadData2Out(exRegReadData2),
    .Immediate(idImmediate),
    .ImmediateOut(exImmediate),
    .Reg2(Instruction[20:16]),
    .Reg2Out(exReg2),
    .Reg3(Instruction[20:16]),
    .Reg3Out(exReg3),
    .Func(Instruction[5:0]),
    .FuncOut(exFunc)
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

wire idRegDst, exRegDst;
wire [31:0] exRegWriteAddr;
wire [31:0] exALUInput2;
wire [31:0] exALUResult;
wire [31:0] exRegWriteAddr, memRegWriteAddr;
wire exZero;


MUX32 MUX_ALUSrc(exRegReadData2, exImmediate, exALUSrc, exALUInput2);

ALU ALU(
    .CLK(CLK),
    .A(exRegReadData1),
    .B(exALUInput2),
    .ALUOp(exALUOp),
    .func(exFunc),
    .result(exALUResult),
    .Zero(exZero)
);

//assign BeqTarget = DefaultNxtPC + (Immediate << 2);
/*BeqJumper BeqJumper(
    .CLK(CLK),
    .DefaultNxtPC(exDefaultNxtPC),
    .Immediate(Immediate),
    .BeqTarget(BeqTarget)
)*/

MUX5 MUX_RegDst(exReg2, exReg3, exRegDst, exRegWriteAddr);

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
    //.JumpTarget(JumpTarget),
    //.JumpTargetOut(memJumpTarget),
    .ALUResult(exALUResult),
    .ALUResultOut(memAddress),
    .Zero(exZero),
    .ZeroOut(memZero),
    .RegReadData2(RegReadData2),
    .RegReadData2Out(memWriteData),
    .RegWriteAddr(exRegWriteAddr),
    .RegWriteAddr(memRegWriteAddr)
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

DataMem DataMem(
    .CLK(CLK),
    .MemWrite(memMemWrite),
    .MemRead(memMemRead),
    .Addr(memAddress),
    .WriteData(memWriteData),
    .ReadData(memReadData),
    .OutMem0(OutMem0),
    .OutMem1(OutMem1),
    .OutMem2(OutMem2),
    .OutMem3(OutMem3),
    .OutMem4(OutMem4),
    .OutMem5(OutMem5),
    .OutMem6(OutMem6),
    .OutMem7(OutMem7)
);

//MUX32 MUX_Branch(DefaultNxtPC, BeqTarget, ALUZero & Branch, BranchResult);

MEM2WB MEM2WB(
    .CLK(CLK),
    .MemtoReg(memMemtoReg),
    .MemtoRegOut(wbMemtoReg),
    .RegWrite(memRegWrite),
    .RegWriteOut(wbRegWrite),
    .ReadData(memReadData),
    .ReadDataOut(wbReadData),
    .ALUResult(memAddress),
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

MUX32 MUX_MemtoReg(wbALUResult, wbReadData, wbMemtoReg, idRegWriteData);

endmodule
