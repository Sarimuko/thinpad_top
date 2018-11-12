module EX2MEM(
    input wire CLK,
    
    input reg Branch,
    output reg BranchOut,

    input reg MemRead,
    output reg MemReadOut,

    input reg MemWrite,
    output reg MemWriteOut,

    input reg MemtoReg,
    output reg MemtoRegOut,

    input reg RegWrite,
    output reg RegWriteOut,

    input reg JumpTarget,
    output reg JumpTargetOut,

    input reg RegReadData2,
    output reg RegReadData2Out,

    input Zero,
    output reg ZeroOut,

    input ALUResult,
    output reg ALUResultOut,

    );
    always @(posedge CLK) begin
        MemReadOut <= MemRead;
        BranchOut <= Branch;
        MemWriteOut <= MemWrite;
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        JumpTargetOut <= JumpTarget;
        MemReadData2Out <= MemReadData2;
        ZeroOut <= Zero;
        ALUResultOut <= ALUResult;
    end
endmodule
