`timescale 1ns / 1ps

module tb_mips32;  
    reg clk,reset; 
    
    wire [31:0] pc_current;
    wire branch_equal;
    wire [31:0] IFID_pc4, IFID_inst, pc_next;
    
    wire [1:0] ID_alu_op;
    
    wire [31:0] IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend;
    wire [4:0]  IDEX_inst25_21, IDEX_inst20_16, IDEX_inst15_11;
        
    wire fu_mem_RegWrite, fu_wb_RegWrite;
    wire [4:0] fu_ex_instr25_21,  fu_ex_instr20_16, fu_mem_instr15_11, fu_wb_instr15_11;
    wire [1:0] EX_alu_op, ForwardA, ForwardB;
    wire [3:0] alu_ctrl;
    wire [31:0] ALU_input1, ALU_input2;
    
    wire [31:0] EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2;
    wire [4:0]  EXMEM_WriteRegister;
    
    wire [31:0] MEMWB_ReadData, MEMWB_alu_result;
    wire [4:0]  MEMWB_WriteRegister;
    
    wire [31:0] pc_out;
    
    mips_32 uut (
        clk, reset,    
        pc_current,
        branch_equal,
        IFID_pc4, IFID_inst, pc_next,
        
        ID_alu_op,
        
        IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend,
        IDEX_inst25_21, IDEX_inst20_16, IDEX_inst15_11,
        
        fu_mem_RegWrite, fu_wb_RegWrite,
        fu_ex_instr25_21,  fu_ex_instr20_16, fu_mem_instr15_11, fu_wb_instr15_11,
        EX_alu_op, ForwardA, ForwardB,
        alu_ctrl, 
        ALU_input1, ALU_input2,
        
        EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2, 
        EXMEM_WriteRegister,
        
        MEMWB_ReadData, MEMWB_alu_result,
        MEMWB_WriteRegister,
        
        pc_out
    );  
    
    always #5 clk = ~clk; 

    // Display the values every #10 time units
    always #10 begin
        $display("Time: %t | pc_current: %b", $time, pc_current);
        $display("Time: %t | IFID_pc4: %b, IFID_inst: %b ID_alu_op: %b, pc_next: %b: , branch_equal: %b ", $time, IFID_pc4, IFID_inst, ID_alu_op, pc_next, branch_equal);
        $display("Time: %t | IDEX_pc4: %b, IDEX_ReadData1: %b, IDEX_ReadData2: %b, IDEX_SignExtend: %b, IDEX_inst25_21: %b,  IDEX_inst20_16: %b, IDEX_inst15_11: %b", $time, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend, IDEX_inst25_21, IDEX_inst20_16, IDEX_inst15_11);
        $display("Time: %t | fu_mem_RegWrite: %b, fu_wb_RegWrite: %b, fu_ex_instr25_21: %b,  fu_ex_instr20_16: %b, fu_mem_instr15_11: %b, fu_wb_instr15_11: %b", $time, fu_mem_RegWrite, fu_wb_RegWrite,fu_ex_instr25_21,  fu_ex_instr20_16, fu_mem_instr15_11, fu_wb_instr15_11);        
        $display("Time: %t | EX_alu_op: %b , ALU_Ctrl: %b ,  ForwardA: %b,  ForwardB: %b,  ALU_input1:%b , ALU_input2: %b", $time, EX_alu_op, alu_ctrl, ForwardA, ForwardB, ALU_input1, ALU_input2);
        $display("Time: %t | EXMEM_PC_beq: %b,EXMEM_alu_result: %b, EXMEM_ReadData2: %b, EXMEM_WriteRegister: %b", $time, EXMEM_PC_beq,EXMEM_alu_result, EXMEM_ReadData2, EXMEM_WriteRegister);
        $display("Time: %t | MEMWB_ReadData: %b, MEMWB_alu_result: %b, MEMWB_WriteRegister: %b", $time, MEMWB_ReadData, MEMWB_alu_result, MEMWB_WriteRegister);
        $display("Time: %t | pc_out: %b", $time, pc_out);
        $display("--------------------");
    end

    initial begin  
        clk = 0; reset = 1;
        #10 reset = 0;  
        #100 $finish;
    end  
endmodule  
