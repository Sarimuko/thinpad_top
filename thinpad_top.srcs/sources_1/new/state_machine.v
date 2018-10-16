module state_machine(
	input wire[15: 0] input_num,//输入操作数和操作码所用
	input wire clk,//确认键
	input wire rst,//复位键

	output wire[15: 0] result);//结果输出

parameter [2:0] ORIGIN = 3'b000;
parameter [2:0] START = 3'b001;
parameter [2:0] RECA = 3'b010;
parameter [2:0] RECB = 3'b011;
parameter [2:0] CAL = 3'b100;
parameter [2:0] OUTPUT = 3'b101;

parameter [11: 0] ZERO = 0;

reg[15: 0] A;
reg[15: 0] B;
reg[3: 0] opt;
reg[16: 0] ans;
reg[2: 0] state, next_state;


//TODO: 实例化一个ALU，input A, B, opt, output ans
alu alu_instance(A, B, opt, ans);

always @(state) begin
	next_state = ORIGIN;
	case(state)
		ORIGIN: begin
			next_state = START
		end
		START:begin
			next_state = RECA;
		end
		RECA:begin
			next_state = RECB;
		end
		RECA:begin
			next_state = CAL;
		end
		CAL: begin //一个时钟周期等待计算结果
			next_state = OUTPUT;
		end
		OUTPUT: begin
			next_state = ORIGIN;
		end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
		state <= ORIGIN;
		next_state <= ORIGIN;
	end
	else begin
	state <= #1 next_state;
	case(state)
		ORIGIN:begin
		end
		START:begin
			A = input_num;
			result = input_num;
		end
		RECA:begin
			B = input_num;
			result = input_num;
		end
		RECB:begin
			opt = input_num[3: 0];
			result = {ZERO[11:0], input_num[3: 0]};
		end
		CAL:begin
		end
		OUTPUT:begin
			result <= ans;
		end
		default:begin
			state <= ORIGIN;
			next_state <= ORIGIN;
		end
		
	end
end
endmodule

