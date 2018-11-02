`timescale 1ns / 1ps
module tb();

reg clk_50M = 0;
reg clk_11M0592 = 0;

reg clock_btn = 0;         //BTN5手动时钟按钮�?关，带消抖电路，按下时为1
reg reset_btn = 0;         //BTN6手动复位按钮�?关，带消抖电路，按下时为1

wire[7:0] OutReg0;
wire[7:0] OutReg1;
wire[7:0] OutReg2;
wire[7:0] OutReg3;
wire[7:0] OutReg4;
wire[7:0] OutMem0;
wire[7:0] OutMem1;
wire[7:0] OutMem2;
wire[7:0] OutMem3;
wire[7:0] OutMem4;
wire[7:0] OutMem5;
wire[7:0] OutMem6;
wire[7:0] OutMem7;
wire [31:0] outPC;
wire [31:0] outInstruction;
wire RegDst;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemWrite;
wire MemRead;
wire Branch;
wire Jump;
wire ExtOp;
wire [2:0] ALUOp;
//Windows�?要注意路径分隔符的转义，例如"D:\\foo\\bar.bin"

initial begin 
    //在这里可以自定义测试输入序列，例如：
    reset_btn = 1;
    #200 reset_btn = 0;
    /*for (integer i = 0; i < 20; i = i++) begin
        #100; //等待100ns
        clock_btn = 1; //按下手工时钟按钮
        #100; //等待100ns
        clock_btn = 0; //松开手工时钟按钮
    end*/
end

always
begin
    #100 clk_50M = ~clk_50M;
end

thinpad_top dut(
    .clk_50M(clk_50M),
    .reset_btn(reset_btn),
    .OutReg0(OutReg0),
    .OutReg1(OutReg1),
    .OutReg2(OutReg2),
    .OutReg3(OutReg3),
    .OutReg4(OutReg4),
    .OutMem0(OutMem0),
    .OutMem1(OutMem1),
    .OutMem2(OutMem2),
    .OutMem3(OutMem3),
    .OutMem4(OutMem4),
    .OutMem5(OutMem5),
    .OutMem6(OutMem6),
    .OutMem7(OutMem7),
    .outPC(outPC),
    .outInstruction(outInstruction),
    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Branch(Branch),
    .Jump(Jump),
    .ExtOp(ExtOp),
    .ALUOp(ALUOp)
);
/*
clock osc(
    .clk_11M0592(clk_11M0592),
    .clk_50M    (clk_50M)
);
*/
endmodule