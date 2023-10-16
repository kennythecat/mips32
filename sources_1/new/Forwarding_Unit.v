module Forwarding_Unit(
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    input [4:0] ID_EX_rs, ID_EX_rt, EX_MEM_rd, MEM_WB_rd,
    output reg [1:0] ForwardA, ForwardB
    );
    
    always@(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // Test One Clock Cycle Hazards,  EX & MEM
        if(EX_MEM_RegWrite && EX_MEM_rd!= 5'b00000) begin
            if(EX_MEM_rd == ID_EX_rs) 
                ForwardA = 2'b10;
            if(EX_MEM_rd == ID_EX_rt) 
                ForwardB = 2'b10;
        end

        // Test Two Clock Cycle Hazards,  EX & WB
        if(MEM_WB_RegWrite && MEM_WB_rd!= 5'b00000) begin
            if(MEM_WB_rd == ID_EX_rs && ForwardA == 2'b00)
                ForwardA = 2'b01; 
            if(MEM_WB_rd == ID_EX_rt && ForwardB == 2'b00)
                ForwardB = 2'b01;
        end
    end
endmodule
