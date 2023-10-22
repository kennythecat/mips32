`timescale 1ns / 1ps

module tb_mips32;  
    reg clk,reset; 
    
    wire [31:0] pc_current;
    wire branch_equal, stall, mem_read, ex_MemRead;
    wire [31:0] IFID_pc4, IFID_inst, pc_next, IFID_WriteData;
    
    wire [1:0] ID_alu_op;
    
    wire [31:0] IDEX_inst, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend;
    
        
    wire fu_mem_RegWrite, fu_wb_RegWrite;
    
    wire [1:0] EX_alu_op, ForwardA, ForwardB;
    wire [3:0] alu_ctrl;
    wire [31:0] ALU_input1, ALU_input2;
    
    wire [31:0] mem_instr, EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2;
    wire [4:0]  EXMEM_WriteRegister;
    
    wire [31:0] wb_instr, MEMWB_ReadData, MEMWB_alu_result;
    wire [4:0]  MEMWB_WriteRegister;
    
    wire [31:0] pc_out;
    
    mips_32 uut (
        clk, reset,    
        
        pc_current,
        branch_equal, stall, mem_read, ex_MemRead,
        IFID_pc4, IFID_inst, pc_next, IFID_WriteData,
        
        ID_alu_op,
        IDEX_inst, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend,
 
        fu_mem_RegWrite, fu_wb_RegWrite,
        
        EX_alu_op, ForwardA, ForwardB,
        alu_ctrl, 
        ALU_input1, ALU_input2,
        
        mem_instr, EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2, 
        EXMEM_WriteRegister,
        
        wb_instr, MEMWB_ReadData, MEMWB_alu_result,
        MEMWB_WriteRegister,
        
        pc_out
    );  
    
    always #5 clk = ~clk; 

    // Display the values every #10 time units
    always #10 begin
//        $display("Time: %t | pc_current: %b", $time, pc_current);
        $display("Time: %t | fu_mem_RegWrite: %h, fu_wb_RegWrite: %h", $time, fu_mem_RegWrite, fu_wb_RegWrite);    
        $display("Time: %t | IFID_pc4: %h, IFID_inst: %h ID_alu_op: %h, pc_next: %h: , branch_equal: %h, stall: %h,  IFID_WriteData: %h, ID_ mem_read: %h", $time, IFID_pc4, IFID_inst, ID_alu_op, pc_next, branch_equal, stall, IFID_WriteData, mem_read);
        $display("Time: %t | IDEX_inst:%h, IDEX_pc4: %h, IDEX_ReadData1: %h, IDEX_ReadData2: %h, IDEX_SignExtend: %h, ex_MemRead: %h,", $time, IDEX_inst, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend, ex_MemRead,);
        $display("Time: %t | EX_alu_op: %h , ALU_Ctrl: %h ,  ForwardA: %h,  ForwardB: %h,  ALU_input1:%h , ALU_input2: %h", $time, EX_alu_op, alu_ctrl, ForwardA, ForwardB, ALU_input1, ALU_input2);
        $display("Time: %t | mem_instr: %h ,EXMEM_PC_beq: %h,EXMEM_alu_result: %h, EXMEM_ReadData2: %h, EXMEM_WriteRegister: %h", $time, mem_instr, EXMEM_PC_beq,EXMEM_alu_result, EXMEM_ReadData2, EXMEM_WriteRegister);
        $display("Time: %t | wb_instr: %h ,MEMWB_ReadData: %h, MEMWB_alu_result: %h, MEMWB_WriteRegister: %h", $time, wb_instr, MEMWB_ReadData, MEMWB_alu_result, MEMWB_WriteRegister);
//        $display("Time: %t | pc_out: %b", $time, pc_out);
        $display("--------------------");
    end

    initial begin  
        clk = 0; reset = 1;
        #10 reset = 0;  
        #100 $finish;
    end  
endmodule  
