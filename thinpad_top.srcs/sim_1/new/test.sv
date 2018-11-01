`timescale 1ns / 1ps
module tb;

wire clk_50M, clk_11M0592;

reg clock_btn = 0;         //BTN5手动时钟按钮开关，带消抖电路，按下时为1
reg reset_btn = 0;         //BTN6手动复位按钮开关，带消抖电路，按下时为1

reg[15:0] OutReg0;
reg[15:0] OutReg1;
reg[15:0] OutReg2;
reg[15:0] OutReg3;
reg[15:0] OutReg4;
reg[15:0] OutMem0;
reg[15:0] OutMem1;
reg[15:0] OutMem2;
reg[15:0] OutMem3;
reg[15:0] OutMem4;
reg[15:0] OutMem5;
reg sign;
//Windows需要注意路径分隔符的转义，例如"D:\\foo\\bar.bin"
parameter BASE_RAM_INIT_FILE = "/tmp/main.bin"; //BaseRAM初始化文件，请修改为实际的绝对路径
parameter EXT_RAM_INIT_FILE = "/tmp/eram.bin";    //ExtRAM初始化文件，请修改为实际的绝对路径
parameter FLASH_INIT_FILE = "/tmp/kernel.elf";    //Flash初始化文件，请修改为实际的绝对路径

initial begin 
    //在这里可以自定义测试输入序列，例如：
    sign = 1;
    reset_btn = 1;
    #100
    reset_btn = 0;
    /*for (integer i = 0; i < 20; i = i++) begin
        #100; //等待100ns
        clock_btn = 1; //按下手工时钟按钮
        #100; //等待100ns
        clock_btn = 0; //松开手工时钟按钮
    end*/
end

thinpad_top dut(
    .clk_50M(clk_50M),
    .clk_11M0592(clk_11M0592),
    .clock_btn(clock_btn),
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
    .sign(sign)
);

clock osc(
    .clk_11M0592(clk_11M0592),
    .clk_50M    (clk_50M)
);

endmodule