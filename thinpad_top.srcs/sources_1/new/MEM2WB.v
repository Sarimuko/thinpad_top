module MEM2WB(
    input wire CLK,
    
    input reg MemtoReg,
    output reg MemtoRegOut,

    input reg RegWrite,
    output reg RegWriteOut,

    input reg ReadData,
    output reg ReadDataOut,

    input reg ALUResult,
    output reg ALUResultOut,
    );

    always @(posedge CLK) begin
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        ReadDataOut <= ReadData;
        ALUResultOut <= ALUResult;
    end
endmodule
