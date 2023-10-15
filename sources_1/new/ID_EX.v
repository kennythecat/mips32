module ID_EX(
    input clk, reset,
    input [1:0] RegDst, MemtoReg, ALUOp,  
    input Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite,
    input [31:0] pc4, ReadData1, ReadData2, SignExtend,
    input [4:0] inst20_16, inst15_11,
    
    output reg [1:0] RegDst_o, MemtoReg_o, ALUOp_o,  
    output reg Jump_o, Branch_o, MemRead_o, MemWrite_o, ALUSrc_o, RegWrite_o,
    output reg [31:0] pc4_o, ReadData1_o, ReadData2_o, SignExtend_o,
    output reg [4:0] inst20_16_o, inst15_11_o
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegDst_o <= 2'b00;
            MemtoReg_o <= 2'b00;
            ALUOp_o <= 2'b00;
            Jump_o <= 1'b0;
            Branch_o <= 1'b0;
            MemRead_o <= 1'b0;
            MemWrite_o <= 1'b0;
            ALUSrc_o <= 1'b0;
            RegWrite_o <= 1'b0;
            pc4_o <= 32'd0;
            ReadData1_o <= 32'd0;
            ReadData2_o <= 32'd0;
            SignExtend_o <= 32'd0;
            inst20_16_o <= 5'd0;
            inst15_11_o <= 5'd0;
        end 
        else begin
            RegDst_o <= RegDst;
            MemtoReg_o <= MemtoReg;
            ALUOp_o <= ALUOp;
            Jump_o <= Jump;
            Branch_o <= Branch;
            MemRead_o <= MemRead;
            MemWrite_o <= MemWrite;
            ALUSrc_o <= ALUSrc;
            RegWrite_o <= RegWrite;
            pc4_o <= pc4;
            ReadData1_o <= ReadData1;
            ReadData2_o <= ReadData2;
            SignExtend_o <= SignExtend;
            inst20_16_o <= inst20_16;
            inst15_11_o <= inst15_11;
        end
    end

endmodule
