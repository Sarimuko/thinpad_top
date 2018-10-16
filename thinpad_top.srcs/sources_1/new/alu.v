module alu(
	input reg[15: 0] A,
	input reg[15: 0] B,
	input reg[3: 0] opt,
	output reg[15: 0] result);

parameter[2:0] ADD = 3'b000;
parameter[2:0] AND = 3'b001;
parameter[2:0] OR = 3'b010;
parameter[2:0] NOT = 3'b011;
parameter[2:0] SLL = 3'b100;
parameter[2:0] SRL = 3'b101;
parameter[2:0] SRA = 3'b110;
parameter[2:0] ROL = 3'b111;

reg last_B;

always @(A, B, opt)begin
	last_B = B[3:0];//只有后四位在移位时是有效的

	case (opt[3:1])
		ADD:begin
			if (opt[0] == 1'b1) begin
				B = ~B + 1;
			end
			result = A + B;
		end
		AND:begin
			result = A & B;
		end
		OR:begin
			result = A | B;
			if (opt[0] == 1'b1) begin
				result = ~result;
			end
		end
		NOT:begin
			result = ~A;
		end
		SLL:begin
			result = A << last_B;
		end
		SLR:begin
			result = A >> last_B;
		end
		SRA:begin
			result = {result[15], result[14:0] >> last_B};//后15位右移
		end
		ROL:begin
			if (last_B > 0)begin
				result = {result[15 - last_B:0], result[15: 16-last_B]};
			end
		end
end
endmodule
