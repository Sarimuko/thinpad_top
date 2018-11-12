`default_nettype wire

module IF2ID(
    input wire CLK,
    input wire [31:0] defaultNxtPC,
    output reg [31:0] defaultNxtPCOut,

    input wire [4:0] Reg2,
    output reg [4:0] Reg2Out,

    input wire [4:0] Reg3,
    output reg [4:0] Reg3Out,

    );

    always @(posedge CLK) begin
        Reg2Out <= Reg2;
        Reg3Out <= Reg3;
        defaultPCOut <= defaultPC;
    end

  end
endmodule