module EX_MEM(
    input clk, reset,
    input [1:0] MemtoReg,  
    input Jump, Branch, MemRead, MemWrite, RegWrite,
    input [31:0] PC_beq, alu_result, ReadData2, 
    input zero_flag,
    input [4:0] WriteRegister,
    input [31:0] inst,
    output reg [1:0] MemtoReg_o,  
    output reg Jump_o, Branch_o, MemRead_o, MemWrite_o, RegWrite_o,
    output reg [31:0] PC_beq_o, alu_result_o, ReadData2_o, 
    output reg zero_flag_o,
    output reg [4:0] WriteRegister_o,
    output reg [31:0] inst_o
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        MemtoReg_o <= 2'b00;
        Jump_o <= 1'b0;
        Branch_o <= 1'b0;
        MemRead_o <= 1'b0;
        MemWrite_o <= 1'b0;
        RegWrite_o <= 1'b0;
        PC_beq_o <= 32'd0;
        alu_result_o <= 32'd0;
        ReadData2_o <= 32'd0;
        zero_flag_o <= 1'b0;
        WriteRegister_o <= 5'd0;
        inst_o <= 32'd0;
    end 
    else begin
        MemtoReg_o <= MemtoReg;
        Jump_o <= Jump;
        Branch_o <= Branch;
        MemRead_o <= MemRead;
        MemWrite_o <= MemWrite;
        RegWrite_o <= RegWrite;
        PC_beq_o <= PC_beq;
        alu_result_o <= alu_result;
        ReadData2_o <= ReadData2;
        zero_flag_o <= zero_flag;
        WriteRegister_o <= WriteRegister;
        inst_o <= inst;
    end
end

endmodule
