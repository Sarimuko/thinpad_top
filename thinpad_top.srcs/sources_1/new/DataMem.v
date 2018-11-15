`default_nettype wire

module DataMem(
    input CLK,
    input MemWrite,
    input MemRead,
    input [31:0] Addr,
    input [31:0] WriteData,
    output reg [31:0] ReadData,
    output wire [7:0] OutMem0,
    output wire [7:0] OutMem1,
    output wire [7:0] OutMem2,
    output wire [7:0] OutMem3,
    output wire [7:0] OutMem4,
    output wire [7:0] OutMem5,
    output wire [7:0] OutMem6,
    output wire [7:0] OutMem7
    );

    reg [7:0] memory [0:127];
    /*assign Mem0 = {memory[0], memory[1], memory[2], memory[3]};
    assign Mem1 = {memory[4], memory[5], memory[6], memory[7]};
    assign Mem2 = {memory[8], memory[9], memory[10], memory[11]};
    assign Mem3 = {memory[12], memory[13], memory[14], memory[15]};
    assign Mem4 = {memory[16], memory[17], memory[18], memory[19]};
    assign Mem5 = {memory[20], memory[21], memory[22], memory[23]};*/

    assign OutMem0 = {memory[3]};
    assign OutMem1 = {memory[7]};
    assign OutMem2 = {memory[11]};
    assign OutMem3 = {memory[15]};
    assign OutMem4 = {memory[19]};
    assign OutMem5 = {memory[23]};
    assign OutMem6 = {memory[27]};
    assign OutMem7 = {memory[31]};
    
    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            memory[i] = 0;
        end
    end
    
    always @(negedge CLK) 
    begin
        if (MemWrite) 
        begin
            memory[Addr] = WriteData[31:24];
            memory[Addr + 1] = WriteData[23:16];
            memory[Addr + 2] = WriteData[15:8];
            memory[Addr + 3] = WriteData[7:0];
        end
        else if(MemRead)
        begin
            ReadData[31:24] = memory[Addr];
            ReadData[23:16] = memory[Addr + 1];
            ReadData[15:8] = memory[Addr + 2];
            ReadData[7:0] = memory[Addr + 3];
        end
    end
endmodule
