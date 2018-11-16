`default_nettype wire

module Forward(
    input [4:0] memRegWriteAddr,
    input [4:0] wbRegWriteAddr,
    input memRegWrite,
    input wbRegWrite,
    input [4:0] Reg1,
    input [4:0] Reg2,

    output reg forwardWb1,
    output reg forwardWb2,
    output reg forwardMem1,
    output reg forwardMem2
    );
    
    always @(*)
    begin
        if (memRegWrite && Reg1 != 0 && Reg1 == memRegWriteAddr) begin
            forwardMem1 = 1;
        else begin
            forwardMem1 = 0;
        end
        if (memRegWrite && Reg2 != 0 && Reg2 == memRegWriteAddr) begin
            forwardMem2 = 1;
        else begin
            forwardMem2 = 0;
        end
        if (wbRegWrite && Reg1 != 0 && Reg1 == wbRegWriteAddr) begin
            forwardWb1 = 1;
        else begin
            forwardWb1 = 0;
        end
        if (wbRegWrite && Reg2 != 0 && Reg2 == wbRegWriteAddr) begin
            forwardWb2 = 1;
        else begin
            forwardWb2 = 0;
        end
    end
endmodule
