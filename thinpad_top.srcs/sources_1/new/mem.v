`define HIGHZ	32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz
`define HALF 	4'b0011
`define BYTE 	4'b0111
`define WORD 	4'b0000

`default net type wire
module mem(
    input MemWrite,
    input MemRead,


    input [31:0] dataAddr,
    input [31:0] instAddr,

    input [31:0] WriteData,
    input [31:0] WriteAddr,
    output reg [31:0] ReadData,
    output reg [31:0] Instruction,

    input [3:0] byteLength,

    output reg writeInst,// is writing instruction field memory, 1 for writing

    /* ============== interface with thinpad_top =================*/
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
    output wire ext_ram_we_n
    /* ===========================================================*/

    /*output wire [7:0] OutMem0,
    output wire [7:0] OutMem1,
    output wire [7:0] OutMem2,
    output wire [7:0] OutMem3,
    output wire [7:0] OutMem4,
    output wire [7:0] OutMem5,
    output wire [7:0] OutMem6,
    output wire [7:0] OutMem7*/
	)

	assign base_ram_ce_n = 0;
	assign ext_ram_ce_n = 0;

	reg writeInst_reg;
	reg [19:0] dataAddr_reg;
	reg [19:0] instAddr_reg;

	reg [19:0] writeAddr_reg;
	reg [31:0] MemData_reg;

	assign dataAddr_reg = dataAddr[19:0];
	assign instAddr_reg = instAddr[19:0];

	assign writeAddr_reg = WriteAddr[19:0];
	assign writeInst_reg = WriteAddr[20];
	assign writeInst = writeInst_reg && MemWrite; // is writing instruction part memory

	assign base_ram_oe_n = !MemRead;
	assign base_ram_we_n = !(MemWrite && !writeInst_reg);

	assign ext_ram_oe_n = writeInst_reg; // 只要是没有在写instruction的Mem，就可以一直读
	assign ext_ram_we_n = !(MemWrite && writeInst_reg);

	assign base_ram_data = (MemWrite && !writeInst_reg)? WriteData: `HIGHZ; // 给baseRam写的时候置成writeData,否则置成高阻态
	assign ext_ram_data = (MemWrite && writeInst_reg)? WriteData : `HIGHZ;

	assign base_ram_be_n = byteLength;
	assign ext_ram_be_n = 0;

	always @(MemRead, InstRead) begin
		if(MemRead)
			ReadData = base_ram_data;
		if(InstRead && !writeInst_reg)
			Instruction = ext_ram_data;
	end

endmodule