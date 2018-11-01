`default_nettype wire

module InstMEM(
    //input instMemRW,
    // up to 32 instructions
    input [31:0] addr,
    // each instruction has 32 bits
    output reg [31:0] Instruction
    );
    
    // each item is 8 bits and memory array has 128 items
    // each instruction needs 4 items because each instruction is 32 bits
    // so the memory can include 32 instructions
    reg [7:0] MEM [0:127];
    
    initial 
    begin
        $readmemb("/home/vivado/project/thinpad_top/thinpad_top.srcs/sources_1/new/testdata.txt", MEM);
        Instruction = 0;
    end
    
    always @(addr)
    begin
        Instruction[31:24] = MEM[addr];
        Instruction[23:16] = MEM[addr + 1];
        Instruction[15:8] = MEM[addr + 2];
        Instruction[7:0] = MEM[addr + 3];
    end
endmodule
