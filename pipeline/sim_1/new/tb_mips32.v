`timescale 1ns / 1ps

module tb_mips32;  
    reg clk,reset; 
    
    wire [31:0] IFID_pc4, IFID_inst;
    
    wire [1:0] ID_alu_op;
    
    wire [31:0] IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend;
    wire [4:0]  IDEX_inst20_16, IDEX_inst15_11;
    
    wire [1:0] EX_alu_op;
    wire [3:0] alu_ctrl;
    
    wire [31:0] EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2;
    wire [4:0]  EXMEM_WriteRegister;
    
    wire [31:0] MEMWB_ReadData, MEMWB_alu_result;
    wire [4:0]  MEMWB_WriteRegister;
    
    wire [31:0] pc_out;
    
    mips_32 uut (
        clk, reset,    
        
        IFID_pc4, IFID_inst,
        
        ID_alu_op,
        
        IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend,
        IDEX_inst20_16, IDEX_inst15_11,
        
        EX_alu_op,
        alu_ctrl,
        
        EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2, 
        EXMEM_WriteRegister,
        
        MEMWB_ReadData, MEMWB_alu_result,
        MEMWB_WriteRegister,
        
        pc_out
    );  
    
    always #5 clk = ~clk; 

    // Display the values every #10 time units
    always #10 begin
        $display("Time: %t | IFID_pc4: %b, IFID_inst: %b ID_alu_op: %b ", $time, IFID_pc4, IFID_inst, ID_alu_op);
        $display("Time: %t | IDEX_pc4: %b, IDEX_ReadData1: %b, IDEX_ReadData2: %b, IDEX_SignExtend: %b, IDEX_inst20_16: %b, IDEX_inst15_11: %b", $time, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend, IDEX_inst20_16, IDEX_inst15_11);
        $display("Time: %t | EXMEM_PC_beq: %b, EX_alu_op: %b , ALU_Ctrl: %b , EXMEM_alu_result: %b, EXMEM_ReadData2: %b, EXMEM_WriteRegister: %b", $time, EXMEM_PC_beq, EX_alu_op, alu_ctrl, EXMEM_alu_result, EXMEM_ReadData2, EXMEM_WriteRegister);
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
