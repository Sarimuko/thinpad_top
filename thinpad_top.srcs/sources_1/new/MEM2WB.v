`default_nettype wire

module MEM2WB(
    input wire CLK,
    
    input MemtoReg,
    output reg MemtoRegOut,

    input RegWrite,
    output reg RegWriteOut,

    input [31:0] ReadData,
    output reg [31:0] ReadDataOut,

    input [31:0] ALUResult,
    output reg [31:0] ALUResultOut,
    
    input [4:0] MemWriteAddr,
    output reg [4:0] MemWriteAddrOut
    );

    always @(posedge CLK) begin
        MemtoRegOut <= MemtoReg;
        RegWriteOut <= RegWrite;
        ReadDataOut <= ReadData;
        ALUResultOut <= ALUResult;
        MemWriteAddrOut <= MemWriteAddr;
    end
endmodule
