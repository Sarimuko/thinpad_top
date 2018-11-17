`default_nettype wire

`define R_TYPE  6'b000000
`define ADDIU   6'b001001
`define ANDI    6'b001100
`define ORI     6'b001101
`define XORI    6'b001110
`define CLZ_R_TYPE     6'b011100

module ControlUnit(
    input wire [31:0] Instruction,
    output reg RegDst,
    output reg ALUSrc1,
    output reg ALUSrc2,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemWrite,
    output reg MemRead,
    output reg Branch,
    output reg Jump,
    output reg ExtOp,
    output reg [2:0] ALUOp
    );

    wire [5:0] OP;
    assign OP = Instruction[31:26];
    wire [5:0] Func;
    assign Func = Instruction[5:0];

    always@(*) 
    begin
        case(OP)
            `R_TYPE:
            begin
                RegDst = 1;
                ALUSrc1 = (Func == 6'b000000 || Func == 6'b000010) ? 0 : 1;
                ALUSrc2 = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b111;
            end
            `ADDIU:
            begin
                RegDst = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b001;
            end
            `ANDI:
            begin
                RegDst = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b010;
            end
            `ORI:
            begin
                RegDst = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b011;
            end
            `XORI:
            begin
                RegDst = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b100;
            end
            `CLZ_R_TYPE:
            begin
                RegDst = 0;
                ALUSrc1 = 1;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b101;
            end
            /*6'b000010:
            // jump
            begin
                RegDst = 0;
                //ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 1;
                ExtOp = 0;
                ALUOp = 3'b000;
            end*/
            default:
            begin
                RegDst = 0;
                ALUSrc1 = 0;
                ALUSrc2 = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b000;
            end
    endcase
  end
endmodule