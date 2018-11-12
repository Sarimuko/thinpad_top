module ID2EX(
    input reg [31:0] defaultPC,
    input reg [31:0] Instruction,
    output reg RegDst,
    output reg ALUSrc,
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

    always@(OP) 
    begin
        case(OP)
            6'b000000:
            // add
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b011;
            end
            6'b000001:
            // sub
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b011;
            end
            6'b001101:
            // ori
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b010;
            end
            6'b100011:
            // lw
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                Branch = 0;
                Jump = 0;
                ExtOp = 1;
                ALUOp = 3'b000;
            end
            6'b101011:
            // sw
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 1;
                ALUOp = 3'b000;
            end
            6'b000100:
            // beq
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                Branch = 1;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b001;
            end
            6'b000010:
            // jump
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 1;
                ExtOp = 0;
                ALUOp = 3'b000;
            end
            default:
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                Branch = 0;
                Jump = 0;
                ExtOp = 0;
                ALUOp = 3'b111;
            end
    endcase
  end
endmodule