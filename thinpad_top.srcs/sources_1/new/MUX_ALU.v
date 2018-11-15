`default_nettype wire

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
        if (forwardMem) 
        begin
            S = memData;
        end
        else if(forwardWb)
        begin
            S = forwardWb;
        end
        else if(ALUSrc) // 1 when from reg
        begin
            S = regData;
        end
        else
        begin
            S = immediate;
        end
    end
endmodule
