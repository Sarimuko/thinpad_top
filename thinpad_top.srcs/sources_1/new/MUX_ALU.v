`default_nettype wire

// ranking: immediate, memforward, wbforward, regdata

//mux before alu.
module MUX_ALU
    (
    input [31:0] memData,
    input [31:0] wbData,
    input [31:0] immediate,
    input [31:0] regData,
    input forwardMem,
    input forwardWb,
    input ALUSrc,
    output reg [31:0] S
);
    wire [2:0] Control;
    assign Control = {forwardMem, forwardWb, ALUSrc}; 
    always @(*) begin
        if (ALUSrc == 0) // immediate
        begin
            S = immediate;
        end
        else if (forwardMem) 
        begin
            S = memData;
        end
        else if(forwardWb)
        begin
            S = forwardWb;
        end
        else // no forward
        begin
            S = regData;
        end
    end
endmodule
