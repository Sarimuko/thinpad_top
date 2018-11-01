`default_nettype wire

module InstMEM(
    input [31:0] addr,
    output reg [31:0] Instruction
    );
    
    reg [7:0] MEM [0:127];
    
    initial 
    begin
        $readmemb("C:/Users/acer/Desktop/thinpad_top/thinpad_top.srcs/sources_1/new/testdata.txt", MEM);
        for (integer i=0;i<24;i=i+1)
        begin
            $display("%h%h%h%h", MEM[i*4+0], MEM[i*4+1], MEM[i*4+2], MEM[i*4+3]);
        end
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
