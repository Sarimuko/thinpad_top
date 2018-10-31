module DataMem(
    input CLK,
    input MemWrite,
    input MemRead,
    input [31:0] addr,
    input [31:0] WriteData,
    output reg [31:0] ReadData
    );

    reg [7:0] memory [0:127];
    
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
