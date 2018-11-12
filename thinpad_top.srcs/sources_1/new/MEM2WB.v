module MEM2WB(
    input wire CLK,
    
    input reg MemtoReg,
    output reg MemtoRegOut,

    input reg RegWrite,
    output reg RegWriteOut,

    input reg ALUResult,
    output reg ALUResultOut,
    );

    always @(posedge CLK) begin
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        ALUResultOut <= ALUResult;
    end
endmodule
