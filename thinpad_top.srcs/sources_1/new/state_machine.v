module state_machine(
	input wire[15: 0] input_num,//输入操作数和操作码所�?
	input wire clk,//确认�?
	input wire rst,//复位�?
	output reg[15: 0] result);//结果输出

parameter [2:0] ORIGIN = 3'b000;
parameter [2:0] START = 3'b001;
parameter [2:0] RECA = 3'b010;
parameter [2:0] RECB = 3'b011;
parameter [2:0] CAL = 3'b100;
parameter [2:0] OUTPUT = 3'b101;

parameter[3:0] ADD = 4'b0000;
parameter[3:0] SUB = 4'b0001;
parameter[3:0] AND = 4'b0010;
parameter[3:0] OR = 4'b0100;
parameter[3:0] XOR = 4'b0101;
parameter[3:0] NOT = 4'b0110;
parameter[3:0] SLL = 4'b1000;
parameter[3:0] SRL = 4'b1010;
parameter[3:0] SRA = 4'b1100;
parameter[3:0] ROL = 4'b1110;

parameter [11: 0] ZERO =16'b0;

reg[15: 0] A;
reg[15: 0] B;
reg[3: 0] opt;
reg ZF, OF, CF, NF;
//wire[16: 0] ans;
reg[2: 0] state = ORIGIN, next_state = START;

/*initial begin
    result <= 16'b1;
    state <= ORIGIN;
    next_state <= START;
end*/
//TODO: 实例化一个ALU，input A, B, opt, output ans
//alu alu_instance(A, B, opt, ans, CF, ZF, NF, OF);

reg[15:0] add_res, sub_res, and_res, or_res, xor_res, not_res, sll_res, srl_res, sra_res, rol_res;
reg add_cf_res, sub_cf_res, add_of_res, sub_of_res;

always @(A, B)begin
	//last_B <= B[3:0];//只有后四位在移位时是有效�?
    {add_cf_res, add_res} = A + B;
    {sub_cf_res, sub_res} = A + ~B + 1;
    and_res = A & B;
    or_res = A | B;
    xor_res = A ^ B;
    not_res = ~A;
    sll_res = A << B;
    srl_res = A >> B;
    sra_res = ($signed(A)) >>> B;
    rol_res = (A << B) | (A >> (16-B));
    
    if ((A[15] && B[15] && ~add_res[15]) || (~A[15] && ~B[15] && add_res[15])) begin
        add_of_res = 1;
    end
    else begin
        add_of_res = 0;
    end
    
    if (((~A[15] && B[15] && sub_res[15]) || (A[15] && ~B[15] && ~sub_res[15]))) begin
        sub_of_res = 1;
    end
    else begin
        sub_of_res = 0;
    end
end

/*always @(state) begin
	case(state)
		ORIGIN: begin
			next_state <= START;
		end
		START:begin
			next_state <= RECA;
		end
		RECA:begin
			next_state <= RECB;
		end
		RECB:begin
			next_state <= CAL;
		end
		CAL: begin //�?个时钟周期等待计算结�?
			next_state <= OUTPUT;
		end
		OUTPUT: begin
			next_state <= ORIGIN;
		end
		default: begin
		    next_state <= ORIGIN;
		end
	endcase
end*/

always @(posedge clk or posedge rst) begin
	if (rst) begin
		state <= START;
		//next_state <= START;
		result <= 16'b0;
	end
	else begin
	   //state <= next_state;
	   case(state)
		  //ORIGIN:begin
		  //state <= START;
		  //end
		  START:begin
			 A = input_num;
			 result = input_num;
			//result <= 16'b100;
			state = RECA;
		  end
		  RECA:begin
			 B = input_num;
			 result = input_num;
			 //result <= 16'b10;
			 state = RECB;
		  end
		  RECB:begin
			 case (input_num[3:0])
                 ADD:begin
                     CF = add_cf_res;
                     result = add_res;
                     OF = add_of_res;
                 end
                 SUB:begin
                     CF = sub_cf_res;
                     result = sub_res;
                     OF = sub_of_res;
                 end
                 AND:begin
                     result = and_res;
                     CF = 0;
                     OF = 0;
                 end
                 OR:begin
                     result = or_res;
                     CF = 0;
                     OF = 0;
                 end
                 XOR:begin
                     result = xor_res;
                     CF = 0;
                     OF = 0;
                 end
                 NOT:begin
                     result = not_res;
                     CF = 0;
                     OF = 0;
                 end
                 SLL:begin
                     result = sll_res;
                     CF = 0;
                     OF = 0;
                 end
                 SRL:begin
                     result = srl_res;
                     CF = 0;
                     OF = 0;
                 end
                 SRA:begin
                     result = sra_res;
                     CF = 0;
                     OF = 0;
                 end
                 ROL:begin
                     result = rol_res;
                     CF = 0;
                     OF = 0;
                 end
             endcase
			 state = CAL;
		  end
		  CAL:begin
		      ZF = (result[15: 0] == 0);
              NF = result[15];
		      result = {12'b0000000000000000, CF, ZF, NF, OF};
		      state = START;
		  end
		  OUTPUT:begin
			 //result <= ans;
			 state = START;
		  end
		  default:begin
			 state = START;
			 //next_state <= START;
		  end	
	   endcase
	   //result <= {13'b0,state};
    end
end
endmodule

