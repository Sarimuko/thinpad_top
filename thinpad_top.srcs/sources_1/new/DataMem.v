`default_nettype wire

module DataMem(
    input CLK,
    input MemWrite,
    input MemRead,
    input [31:0] addr,
    input [31:0] WriteData,
    output reg [31:0] ReadData,
    output wire [15:0] Mem0,
    output wire [15:0] Mem1,
    output wire [15:0] Mem2,
    output wire [15:0] Mem3,
    output wire [15:0] Mem4,
    output wire [15:0] Mem5
    );

    reg [7:0] memory [0:127];
    /*assign Mem0 = {memory[0], memory[1], memory[2], memory[3]};
    assign Mem1 = {memory[4], memory[5], memory[6], memory[7]};
    assign Mem2 = {memory[8], memory[9], memory[10], memory[11]};
    assign Mem3 = {memory[12], memory[13], memory[14], memory[15]};
    assign Mem4 = {memory[16], memory[17], memory[18], memory[19]};
    assign Mem5 = {memory[20], memory[21], memory[22], memory[23]};*/

    assign Mem0 = {memory[2], memory[3]};
    assign Mem1 = {memory[6], memory[7]};
    assign Mem2 = {memory[10], memory[11]};
    assign Mem3 = {memory[14], memory[15]};
    assign Mem4 = {memory[18], memory[19]};
    assign Mem5 = {memory[22], memory[23]};
    
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
            memory[addr] = WriteData[31:24];
            memory[addr + 1] = WriteData[23:16];
            memory[addr + 2] = WriteData[15:8];
            memory[addr + 3] = WriteData[7:0];
        end
        else if(MemRead)
        begin
            ReadData[31:24] = memory[addr];
            ReadData[23:16] = memory[addr + 1];
            ReadData[15:8] = memory[addr + 2];
            ReadData[7:0] = memory[addr + 3];
        end
    end
endmodule
