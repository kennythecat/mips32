module MEM_WB(
    input clk, reset,
    input [1:0] MemtoReg,  
    input RegWrite,
    input [31:0] ReadData, alu_result,
    input [4:0] WriteRegister, 
    input [31:0] inst,
    
    output reg [1:0] MemtoReg_o,  
    output reg RegWrite_o,
    output reg [31:0] ReadData_o, alu_result_o,
    output reg [4:0] WriteRegister_o, 
    output reg [31:0] inst_o
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        MemtoReg_o <= 2'b00;
        RegWrite_o <= 1'b0;
        ReadData_o <= 32'd0;
        alu_result_o <= 32'd0;
        WriteRegister_o <= 5'd0;
        inst_o <= 32'd0;
    end 
    else begin
        MemtoReg_o <= MemtoReg;
        RegWrite_o <= RegWrite;
        ReadData_o <= ReadData;
        alu_result_o <= alu_result;
        WriteRegister_o <= WriteRegister;
        inst_o <= inst;
    end
end

endmodule
