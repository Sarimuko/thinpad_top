module Register(
    input CLK,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input RegWe,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2,
    output wire [7:0] Reg0,
    output wire [7:0] Reg1,
    output wire [7:0] Reg2,
    output wire [7:0] Reg3,
    output wire [7:0] Reg4
    );
    
    reg [31:0] register[0:31];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            register[i] = 0;
        end
    end
    
    // RS : address of rs
    // RT : address of rt
    // RS -> ReadData1  RT -> ReadData2 
    assign ReadData1 = register[ReadReg1];
    assign ReadData2 = register[ReadReg2];
    assign Reg0 = register[0][7:0];
    assign Reg1 = register[1][7:0];
    assign Reg2 = register[2][7:0];
    assign Reg3 = register[3][7:0];
    assign Reg4 = register[4][7:0];

    // RegWre : 1 - ??��??????????
    always @(negedge CLK) 
    begin
        if (RegWrite)
        begin
            register[WriteReg] = WriteData;
        end
    end
        
endmodule
