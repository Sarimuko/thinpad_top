module EX2MEM(
    input wire CLK,
    
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

    input [31:0] RegReadData2,
    output reg [31:0] RegReadData2Out,

    input Zero,
    output reg ZeroOut,

    input [31:0] ALUResult,
    output reg [31:0] ALUResultOut,

    input [4:0] RegWriteAddr,
    output reg [4:0] RegWriteAddrOut

    );
    always @(posedge CLK) begin
        MemReadOut <= MemRead;
        BranchOut <= Branch;
        MemWriteOut <= MemWrite;
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        //JumpTargetOut <= JumpTarget;
        RegReadData2Out <= RegReadData2;
        ZeroOut <= Zero;
        ALUResultOut <= ALUResult;
        RegWriteAddrOut <= RegWriteAddr;
    end
endmodule
