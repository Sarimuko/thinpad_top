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
    input wire sign,
    output wire [31:0] outPC,
    output wire [31:0] outInstruction
);

wire CLK;
assign CLK = clk_50M;

wire [31:0] curPC, nxtPC, defaultNxtPC, Instruction;

wire RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead, Branch, Jump, ExtOp;
wire [5:0] ALUFunc;

wire [31:0] RegReadData1, RegReadData2, RegWriteData, Immediate;
wire [5:0] Reg1, Reg2, Reg3, RegWriteAddr;
wire [31:0] ALUInput1, ALUInput2, ALUResult, RAMWriteData, RAMReadData;
wire [2:0] ALUOp;
wire ALUzero;
wire [31:0] JumpTarget, BeqTarget, BranchResult, PCResult;
wire [5:0] Func;

assign Reg1 = Instruction[25:21];
assign Reg2 = Instruction[20:16];
assign Reg3 = Instruction[15:11];
assign Func = Instruction[5:0];

assign outPC = curPC;
assign outInstruction = Instruction;
/* =========== Single Cycle CPU ========== */

PC PC(clk_50M, reset_btn, PCResult, curPC);

assign defaultNxtPC = curPC + 4;

InstMEM InstMEM(curPC, Instruction);

ControlUnit ControlUnit(Instruction, RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, MemRead, Branch, Jump, ALUOp);

MUX #(5) MUX_RegDst(Reg2, Reg3, RegDst, RegWriteAddr);

Register Register(CLK, Reg1, Reg2, RegWriteAddr, RegWrite, RegWriteData, RegReadData1, RegReadData2, OutReg0, OutReg1, OutReg2, OutReg3, OutReg4);

Extend Extend(Instruction[15:0], sign, Immediate);

MUX #(32) MUX_ALUSrc(RegReadData2, Immediate, ALUSrc, ALUInput2);

DataMem DataMem(CLK, MemWrite, MemRead, ALUResult, RegReadData2, RAMReadData, OutMem0, OutMem1, OutMem2, OutMem3, OutMem4, OutMem5);

MUX #(32) MUX_MemtoReg(ALUResult, RAMReadData, MemtoReg, RegWriteData);

assign BeqTarget = defaultNxtPC + (Immediate << 2);

assign JumpTarget = {curPC[31:28], Instruction[25:0], 2'b00};

ALU ALU(RegReadData1, ALUInput2, ALUOp, Func, ALUResult, ALUzero);

MUX #(32) MUX_Branch(defaultNxtPC, BeqTarget, ALUzero & Branch, BranchResult);

MUX #(32) MUX_Jump(BranchResult, JumpTarget, Jump, PCResult);

endmodule
