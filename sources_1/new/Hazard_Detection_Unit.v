module Hazard_Detection_Unit(
    input clk, reset, 
    input IDEX_MemRead,
    input [4:0] IFID_Rs, IFID_Rt, IDEX_Rt, 
    output reg stall
    );
    
    always@(*) begin
        if(IDEX_Rt && (IDEX_Rt==IFID_Rs || IDEX_Rt==IFID_Rt))
            stall = 1;
        else
            stall = 0;
    end
endmodule
