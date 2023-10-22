module IF_ID(
    input clk, reset, stall,
    input [31:0] pc4_i, instr_i, pc_current,
    output reg [31:0] pc4_o, instr_o, pc_current_o
    );
    initial pc_current_o = 0;
    
    always@(posedge clk or posedge reset) begin
        pc_current_o <= pc_current;
        if(reset) instr_o <= 0;
        else if (stall);
        else begin
            pc4_o   <= pc4_i;
            instr_o <= instr_i;
        end
    end  
endmodule
