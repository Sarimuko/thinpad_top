module alu(
	input wire[15: 0] A,
	input wire[15: 0] B,
	input wire[3: 0] opt,
	output reg[15: 0] result,
	output reg CF,
	output reg ZF,
	output reg NF,
	output reg OF);

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

//reg last_B;
reg[15:0] reg_B;
reg[15:0] reg_A;
reg[15:0] add_res, sub_res, and_res, or_res, xor_res, not_res, sll_res, srl_res, sra_res, rol_res;
reg add_cf_res, sub_cf_res, add_of_res, sub_of_res;
integer i;

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
        OF = 1;
    end
    else begin
        OF = 0;
    end
    
    if (((~A[15] && B[15] && sub_res[15]) || (A[15] && ~B[15] && ~sub_res[15]))) begin
        OF = 1;
    end
    else begin
        OF = 0;
    end
end

always @(*)begin
	case (opt[3:0])
		ADD:begin
		    CF = add_cf_res;
		    result = add_res;
		    OF = add_of_res;
            /*{CF, result} = A + B;
			if ((A[15] && B[15] && ~result[15]) || (~A[15] && ~B[15] && result[15])) begin
			    OF = 1;
			end
			else begin
			    OF = 0;
			end*/
		end
		SUB:begin
		    CF = sub_cf_res;
		    result = sub_res;
		    OF = sub_of_res;
            /*{CF, result} = A + ~B + 1;
            if (((~A[15] && B[15] && result[15]) || (A[15] && ~B[15] && ~result[15]))) begin
                OF = 1;
            end
            else begin
                OF = 0;
            end*/
        end
		AND:begin
		    result = and_res;
			//result = A & B;
			CF = 0;
			OF = 0;
		end
		OR:begin
		    result = or_res;
            //result = A | B;
            CF = 0;
            OF = 0;
		end
		XOR:begin
		    result = xor_res;
            //result = A ^ B;
            CF = 0;
            OF = 0;
        end
		NOT:begin
		    result = not_res;
			//result = ~A;
			CF = 0;
			OF = 0;
		end
		SLL:begin
		    result = sll_res;
			//result = A << B;
			CF = 0;
			OF = 0;
		end
		SRL:begin
		    result = srl_res;
			//result = A >> B;
			CF = 0;
			OF = 0;
		end
		SRA:begin
		    result = sra_res;
			//result = {A[15], A[14:0] >> last_B};//�?15位右�?
			//result = ($signed(A)) >>> B;
			CF = 0;
			OF = 0;
		end
		ROL:begin
		    result = rol_res;
		    //result = (A << B) | (A >> (16-B));
		    CF = 0;
		    OF = 0;
		end
	endcase
	ZF = (result[15: 0] == 0);
	NF = result[15];
end

endmodule
