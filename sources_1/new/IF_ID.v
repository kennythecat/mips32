module IF_ID(
    input clk, reset,
    input [31:0] pc4_i, instr_i,
    output reg [31:0] pc4_o, instr_o
    );
    always@(posedge clk or posedge reset) begin
        if(reset) instr_o <= 0;
        else begin
            pc4_o   <= pc4_i;
            instr_o <= instr_i;
        end
    end  
endmodule
