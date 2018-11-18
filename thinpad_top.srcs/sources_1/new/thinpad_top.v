`default_nettype none

module thinpad_top(
    input wire clk_50M,           //50MHz 
    input wire reset_btn,         //BTN6 manually reset button, 1 for pushed


    /* =============== output for debugging =============== */
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
    output wire OutALUSrc1,
    output wire OutALUSrc2,
    output wire OutMemtoReg,
    output wire OutRegWrite,
    output wire OutMemWrite,
    output wire OutMemRead,
    output wire OutBranch,
    output wire [4:0] OutForward,
    output wire OutJump,
    output wire OutExtOp,
    output wire [2:0] OutALUOp,
    output wire [7:0] debugOut1,
    output wire [7:0] debugOut2,
    output wire [7:0] debugOut3
    /* ==================================================== */
    input wire clk_11M0592,       //11.0592MHz clock

    input wire clock_btn,         //BTN5 manually clock button, 1 for pushed

    input  wire[3:0]  touch_btn,  //BTN1~BTN4，1 for pushed
    input  wire[31:0] dip_sw,     //32bit button, 1 for 'on'
    output wire[15:0] leds,       //16bit LED display
    output wire[7:0]  dpy0,       //numerical led display for low position
    output wire[7:0]  dpy1,       //high position

    //CPLDserial controller
    output wire uart_rdn,         //uart read enable, 0 enable
    output wire uart_wrn,         //uart write 
    input wire uart_dataready,    //ready for uart data
    input wire uart_tbre,         //signal for uart busy sending data
    input wire uart_tsre,         //signal for uart sending data done

    //BaseRAM
    inout wire[31:0] base_ram_data,  //BaseRAM data, low 8 bits shared with uart
    output wire[19:0] base_ram_addr, //BaseRAM address
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM clip enable, '0'
    output wire base_ram_oe_n,       //BaseRAM read enable, '0'
    output wire base_ram_we_n,       //BaseRAM write enable, '0'

    //ExtRAM
    inout wire[31:0] ext_ram_data,  //ExtRAM data
    output wire[19:0] ext_ram_addr, //ExtRAM address
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire ext_ram_ce_n,       //ExtRAM clip enable, '0'
    output wire ext_ram_oe_n,       //ExtRAM read enable, '0'
    output wire ext_ram_we_n,       //ExtRAM write enable, '0'

    //direct serial signal
    output wire txd,  //direct serial port send
    input  wire rxd,  //direct serail port receive

    //Flash storage, JS28F640 for reference
    output wire [22:0]flash_a,      //Flash地址，a0仅在8bit模式有效，16bit模式无意义
    inout  wire [15:0]flash_d,      //Flash数据
    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧写
    output wire flash_ce_n,         //Flash片选信号，低有效
    output wire flash_oe_n,         //Flash读使能信号，低有效
    output wire flash_we_n,         //Flash写使能信号，低有效
    output wire flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash的16位模式时请设为1

    //USB controller，SL811 for reference
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //data, but shared with dm9k_sd[7:0] in network controllerUSB
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //network controller，DM9000A for reference
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //vga display output
    output wire[2:0] video_red,    //reg,3 bit
    output wire[2:0] video_green,  //green, 3bit
    output wire[1:0] video_blue,   //blue, 2bit
    output wire video_hsync,       //行同步（水平同步）信号
    output wire video_vsync,       //场同步（垂直同步）信号
    output wire video_clk,         //pixel clock output
    output wire video_de           //row signal enable, labling fading period
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

assign ifDefaultNxtPC = CurPC + 4;
assign PCResult = ifDefaultNxtPC;

PC PC(.CLK(CLK), 
    .Reset(reset_btn), 
    .prePC(PCResult), 
    .nxtPC(CurPC));

//assign CurPC = reset_btn ? 0 : PCResult;



/*InstMEM InstMEM(
    .addr(CurPC),
    .Instruction(ifInstruction)
);*/

IF2ID IF2ID(
    .CLK(CLK),
    .DefaultNxtPC(ifDefaultNxtPC),
    .DefaultNxtPCOut(idDefaultNxtPC),
    .Instruction(ifInstruction),
    .InstructionOut(idInstruction)
);





/* =========== Reg & Control =========== */

wire idRegDst, exRegDst; assign OutRegDst = idRegDst;
wire idALUSrc1, idALUSrc2, exALUSrc1, exALUSrc2; 
assign OutALUSrc1 = idALUSrc1; assign OutALUSrc2 = idALUSrc2;
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
wire [3:0] idByteLength, exByteLength;

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
    .Bytelength(idByteLength)
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
    .ALUSrc1(idALUSrc1),
    .ALUSrc1Out(exALUSrc1),
    .ALUSrc2(idALUSrc2),
    .ALUSrc2Out(exALUSrc2),
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
    .Bytelength(idByteLength),
    .BytelengthOut(exByteLength),
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

wire [3:0] memByteLength;

//MUX32 MUX_ALUSrc(exRegReadData2, exImmediate, exALUSrc, exALUInput2);

assign OutForward = {forwardMem1, forwardWb1, forwardMem2, forwardWb2};

MUX_ALU MUX_ALU1(
    .memData(memAddress),
    .wbData(wbRegWriteData),
    .immediate(exImmediate),
    .regData(exRegReadData1),
    .forwardMem(forwardMem1),
    .forwardWb(forwardWb1),
    .ALUSrc(exALUSrc1),
    .S(exALUInput1)
);

MUX_ALU MUX_ALU2(
    .memData(memAddress),
    .wbData(wbRegWriteData),
    .immediate(exImmediate),
    .regData(exRegReadData2),
    .forwardMem(forwardMem2),
    .forwardWb(forwardWb2),
    .ALUSrc(exALUSrc2),
    .S(exALUInput2)
);

ALU ALU(
    .A(exALUInput1),
    .B(exALUInput2),
    .ALUOp(exALUOp),
    .Func(exFunc),
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
    .Bytelength(exByteLength),
    .BytelengthOut(memByteLength),
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

reg memWriteInst;

module mem(
    .MemWrite(memMemWrite),
    .MemRead(memMemRead),

    .dataAddr(memAddress),
    .instAddr(CurPC),

    .WriteData(memWriteData),
    .WriteAddr(memAddress),
    .ReadData(memReadData),
    .Instruction(Instruction),

    .byteLength(memByteLength),

    .writeInst(memWriteInst),// is writing instruction field memory, 1 for writing

    /* ============== interface with thinpad_top =================*/
    //BaseRAM
    .base_ram_data(base_ram_data),  //BaseRAM data, low 8 bits shared with uart
    .base_ram_addr(base_ram_addr), //BaseRAM address
    .base_ram_be_n(base_ram_be_n),  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    .base_ram_ce_n(base_ram_ce_n),       //BaseRAM clip enable, '0'
    .base_ram_oe_n(base_ram_oe_n),       //BaseRAM read enable, '0'
    .base_ram_we_n(base_ram_we_n),       //BaseRAM write enable, '0'

    //ExtRAM
    .ext_ram_data(ext_ram_data),  //ExtRAM data
    .ext_ram_addr(ext_ram_addr), //ExtRAM address
    .ext_ram_be_n(ext_ram_be_n),  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    .ext_ram_ce_n(ext_ram_ce_n),       //ExtRAM clip enable, '0'
    .ext_ram_oe_n(ext_ram_oe_n),       //ExtRAM read enable, '0'
    .ext_ram_we_n(ext_ram_we_n)
    /* ===========================================================*/

    /*.OutMem0(OutMem0),
    .OutMem1(OutMem1),
    .OutMem2(OutMem2),
    .OutMem3(OutMem3),
    .OutMem4(OutMem4),
    .OutMem5(OutMem5),
    .OutMem6(OutMem6),
    .OutMem7(OutMem7)*/
    )

/*DataMem DataMem(
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
);*/

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

/* =========== Debug =========== */

assign debugOut1 = exALUResult[7:0];
assign debugOut2 = idRegReadData1[7:0];
assign debugOut3 = exRegReadData1[7:0];

endmodule
