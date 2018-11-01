module PC(
    input wire CLK,
    input wire Reset,
    input wire [31:0] prePC,
    output reg [31:0] nxtPC
    );
    always @(posedge CLK) begin
        if (Reset == 1)
        begin
            nxtPC = 0;
        end
        else
        begin
            nxtPC = prePC;
        end
        /*else if (PCWre) 
        begin
            out_pc = in_pc;
        end
        else if (!PCWre) 
        // halt
        begin
            out_pc = out_pc;
        end*/
    end
endmodule
