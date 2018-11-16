`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz ʱ������
    input wire reset_btn,         //BTN6�ֶ���λ��ť???�أ���������·������ʱΪ1
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
    //output wire[7:0] OutMem6,
    //output wire[7:0] OutMem7,
    output wire [31:0] OutPC,
    output wire [31:0] OutInstruction,
    output wire OutRegDst,
    output wire OutALUSrc,
    output wire OutMemtoReg,
    output wire OutRegWrite,
    output wire OutMemWrite,
    output wire OutMemRead,
    output wire OutBranch,
    output wire OutJump,
    output wire OutExtOp,
    output wire [2:0] OutALUOp,
    output wire [7:0] debugOut1,
    output wire [7:0] debugOut2,
    output wire [7:0] debugOut3
);

wire CLK;
assign CLK = clk_50M;

wire [7:0] OutMem6, OutMem7;
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

/* =========== Pipeline CPU =========== */





/* =========== PC & InstMEM =========== */

//MUX32 MUX_Jump(BranchResult, JumpTarget, Jump, PCResult);

wire [31:0] PCResult, CurPC;
wire [31:0] ifDefaultNxtPC, ifInstruction;
wire [31:0] idDefaultNxtPC, idInstruction;

assign OutPC = CurPC;
assign OutInstruction = idInstruction;

assign PCResult = ifDefaultNxtPC;

PC PC(CLK, reset_btn, PCResult, CurPC);

//assign CurPC = reset_btn ? 0 : PCResult;

assign ifDefaultNxtPC = CurPC + 4;

InstMEM InstMEM(
    .addr(CurPC),
    .Instruction(ifInstruction)
);

IF2ID IF2ID(
    .CLK(CLK),
    .DefaultNxtPC(ifDefaultNxtPC),
    .DefaultNxtPCOut(idDefaultNxtPC),
    .Instruction(ifInstruction),
    .InstructionOut(idInstruction)
);





/* =========== Reg & Control =========== */

wire idRegDst, exRegDst; assign OutRegDst = idRegDst;
wire idALUSrc, exALUSrc; assign OutALUSrc = idALUSrc;
wire idMemtoReg, exMemtoReg; assign OutMemtoReg = idMemtoReg;
wire idRegWrite, exRegWrite; assign OutRegWrite = idRegWrite;
wire idMemWrite, exMemWrite; assign OutMemWrite = idMemWrite;
wire idMemRead, exMemRead; assign OutMemRead = idMemRead;
wire idBranch, exBranch; assign OutBranch = idBranch;
wire idJump, exJump; assign OutJump = idJump;
wire idExtOp, exExtOp; assign OutExtOp = idExtOp;
wire [2:0] idALUOp, exALUOp; assign OutALUOp = idALUOp;
wire [31:0] idImmediate, exImmediate;
wire [31:0] idRegReadData1, exRegReadData1;
wire [31:0] idRegReadData2, exRegReadData2;
wire [4:0] idReg1, exReg1, idReg2, exReg2, idReg3, exReg3;
wire [5:0] idFunc, exFunc;

ControlUnit ControlUnit(
    .Instruction(idInstruction),
    .RegDst(idRegDst),
    .ALUSrc1(idALUSrc1),
    .ALUSrc2(idALUSrc2),
    .MemtoReg(idMemtoReg),
    .RegWrite(idRegWrite),
    .MemWrite(idMemWrite),
    .MemRead(idMemRead),
    .Branch(idBranch),
    .Jump(idJump),
    .ExtOp(idExtOp),
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
    .WriteReg(wbRegWriteAddr),
    .RegWe(wbRegWrite),
    .WriteData(wbRegWriteData),
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
    .Reg1(idReg1),
    .Reg1Out(exReg1),
    .Reg2(idReg2),
    .Reg2Out(exReg2),
    .Reg3(idReg3),
    .Reg3Out(exReg3),
    .Func(idFunc),
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

wire [31:0] exALUInput1, exALUInput2;
wire [31:0] exALUResult, memWriteData;
wire [4:0] exRegWriteAddr, memRegWriteAddr;
wire memRegWrite;
wire memMemtoReg;
wire memBranch;
wire memMemRead;
wire memMemWrite;
wire [31:0] memAddress;
wire exZero, memZero;
wire forwardMem1, forwardMem2, forwardWb1, forwardWb2;

//MUX32 MUX_ALUSrc(exRegReadData2, exImmediate, exALUSrc, exALUInput2);

MUX_ALU MUX_ALU1(
    .memData(exALUResult),
    .wbData(wbReadData),
    .immediate(exImmediate),
    .regData(exRegReadData1),
    .forwardMem(forwardMem1),
    .forwardWb(forwardWb1),
    .ALUSrc(exALUSrc1),
    .S(exALUInput1)
);

MUX_ALU MUX_ALU2(
    .memData(exALUResult),
    .wbData(wbReadData),
    .immediate(exImmediate),
    .regData(exRegReadData2),
    .forwardMem(forwardMem2),
    .forwardWb(forwardWb2),
    .ALUSrc(exALUSrc2),
    .S(exALUInput2)
)

ALU ALU(
    .A(exALUInput1),
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
    .RegReadData2(exRegReadData2),
    .RegReadData2Out(memWriteData),
    .RegWriteAddr(exRegWriteAddr),
    .RegWriteAddrOut(memRegWriteAddr)
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
wire [31:0] memReadData;
wire wbMemtoReg, wbRegWrite;
wire [31:0] wbReadData, wbALUResult;
wire [4:0] wbRegWriteAddr;

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
    .ALUResultOut(wbALUResult),
    .MemWriteAddr(memRegWriteAddr),
    .MemWriteAddrOut(wbRegWriteAddr)
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

wire [31:0] wbRegWriteData;

MUX32 MUX_MemtoReg(wbALUResult, wbReadData, wbMemtoReg, wbRegWriteData);

//assign debugOut = {idRegWrite, exRegWrite, memRegWrite, wbRegWrite, 2'b0};

/* =========== Forward =========== */

Forward Forward(
    .memRegWriteAddr(memRegWriteAddr),
    .wbRegWriteAddr(wbRegWriteAddr),
    .memRegWrite(memRegWrite),
    .wbRegWrite(wbRegWrite),
    .Reg1(exReg1),
    .Reg2(exReg2),
    .forwardMem1(forwardMem1),
    .forwardMem2(forwardMem2),
    .forwardWb1(forwardWb1),
    .forwardWb2(forwardWb2)
);

input [4:0] memRegWriteAddr,
    input [4:0] wbRegWriteAddr,
    input memRegWrite,
    input wbRegWrite,
    input [4:0] Reg1,
    input [4:0] Reg2,

    output reg forwardWb1,
    output reg forwardWb2,
    output reg forwardMem1,
    output reg forwardMem2

/* =========== Debug =========== */

assign debugOut1 = exALUResult[7:0];
assign debugOut2 = idRegReadData1[7:0];
assign debugOut3 = exRegReadData1[7:0];

endmodule
