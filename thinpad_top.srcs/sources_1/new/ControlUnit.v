module ControlUnit(
    input [31:0] Instruction,
    output reg RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, Jump, ExtOp,
    output reg [5:0] ALUFunc,
    );

    wire [5:0] OP;
    assign OP = Instruction[31:26]

    initial begin
        RegWrite = 0;
        /*ExtSel = 0;
        PCWre = 0;
        InsMemRW = 1;
        ALUSrcA = 0;
        ALUSrcB = 0;
        RegDst = 0;
        DBDataSrc = 0;
        RegWre = 0;*/
    end

    always@(OP or zero) 
    begin
        case(OP)
            6'b000000:
            // add
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 1;
                Branch = 0;
                Jump = 0;
                ALUFunc = Instruction [5:0];
            end
            6'b000001:
            // sub
            begin
                RegDst = 1;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 1;
                Branch = 0;
                Jump = 0;
                ALUFunc = Instruction [5:0];
            end
            6'b001101:
            // ori
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b100011:
            // lw
            begin
                RegDst = 0;
                ALUSrc = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
            end
            6'b101011:
            // sw
            begin
                //RegDst = 0;
                ALUSrc = 1;
                //MemtoReg = 1;
                RegWrite = 0;
                MemWrite = 1;
                Branch = 0;
                Jump = 0;
            end
            6'b000100:
            // beq
            begin
                //RegDst = 0;
                ALUSrc = 0;
                //MemtoReg = 1;
                RegWrite = 0;
                MemWrite = 0;
                Branch = 1;
                Jump = 0;
            end
            6'000010:
            // sll
            begin
                //RegDst = 0;
                //ALUSrc = 0;
                //MemtoReg = 1;
                RegWrite = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 1;
            end
            default:
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
                ALUFunc = 0;
            end

    endcase
  end
endmodule