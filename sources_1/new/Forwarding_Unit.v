module Forwarding_Unit(
    input EX_MEM_RegWrite, MEM_WB_RegWrite,
    input [5:0] OPcode,
    input [4:0] ID_EX_rs, ID_EX_rt, EX_MEM_rt, EX_MEM_rd, MEM_WB_rt, MEM_WB_rd,
    output reg [1:0] ForwardA, ForwardB
    );
    
    always@(*) begin
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // One Clock Cycle Hazards, EX & MEM
        if(EX_MEM_RegWrite) begin
            if((EX_MEM_rd != 5'b00000) && (EX_MEM_rd == ID_EX_rs))
                ForwardA = 2'b10;
            else if((EX_MEM_rd != 5'b00000) && (EX_MEM_rd == ID_EX_rt))
                ForwardB = 2'b10;

            //  I-type instructions (e.g., addi)
            else if(OPcode == 6'b001000) begin
                if((EX_MEM_rt != 5'b00000) && (EX_MEM_rt == ID_EX_rs))
                    ForwardA = 2'b10;
            end
            // I & R...

        end

        // Two Clock Cycle Hazards, EX & WB
        else if(MEM_WB_RegWrite) begin
            if((MEM_WB_rd != 5'b00000) && (MEM_WB_rd == ID_EX_rs) && (ForwardA == 2'b00))
                ForwardA = 2'b01; 
            else if((MEM_WB_rd != 5'b00000) && (MEM_WB_rd == ID_EX_rt) && (ForwardB == 2'b00))
                ForwardB = 2'b01;

            //  I-type instructions
            else if(OPcode == 6'b001000) begin
                if((MEM_WB_rt != 5'b00000) && (MEM_WB_rt == ID_EX_rs) && (ForwardA == 2'b00))
                    ForwardA = 2'b01; 
            end
            // I & R...
        end
    end
endmodule
