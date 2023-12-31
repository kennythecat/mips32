module mips_32( 
    input clk,reset,  
    
    output [31:0] pc_current,
    output branch_equal, stall, mem_read, ex_MemRead,
    output [31:0] IFID_pc4, IFID_inst, pc_next, IFID_WriteData,
    
    output [1:0] ID_alu_op,    
    output [31:0] IDEX_inst, IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend, 
    
    output fu_mem_RegWrite, fu_wb_RegWrite,

    output [1:0] EX_alu_op, ForwardA, ForwardB,
    output [3:0] alu_ctrl,
    output [31:0] ALU_input1, ALU_input2,
    
    output [31:0] mem_instr, EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2, 
    output [4:0]  EXMEM_WriteRegister,
    
    output [31:0] wb_instr, MEMWB_ReadData, MEMWB_alu_result,
    output [4:0]  MEMWB_WriteRegister,
    
    output [31:0] pc_out
   ); 
  
    wire signed[31:0] pc4;  
    wire [31:0] instr;  
    wire [1:0] reg_dst,mem_to_reg,alu_op;  
    wire jump,branch,mem_write,alu_src,reg_write;  
    wire [4:0]  reg_write_dest;  
    wire [31:0] reg_write_data;  
    wire [4:0]  reg_read_addr_1,reg_read_addr_2;  
    wire [31:0] reg_read_data_1,reg_read_data_2;  
    wire [31:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
    wire JRCtrl;  
    wire [3:0] ALU_Ctrl;  
    wire [31:0] ALU_out;  
    wire zero_flag;  
    wire signed[31:0] im_shift_2, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
    wire PCSrc;  
    wire [27:0] jump_shift_2;  
    wire [31:0] mem_read_data;  
    wire [31:0] no_sign_ext;  
    wire sign_or_zero;  
    wire equal;
    
    assign branch_equal = branch&&equal;
    assign pc_next= (branch_equal)?PC_beq:pc4;
    ProgramCounter PC(clk, reset, stall, pc_next, pc_current);
    PCadd4 pcadd4(pc_current, pc4) ;  

    inst_mem instrucion_memory(clk, reset, pc_current, instr);  
    
//----------------------------------IF/ID-----------------------------------------------------------------------    
    wire [31:0] id_pc4, id_instr;
    IF_ID if_id(clk, reset, stall, branch_equal, pc4, instr,
                // Output
                id_pc4, id_instr);
    // Check point
    assign IFID_pc4 = id_pc4;
    assign ID_alu_op =  alu_op;
    assign IFID_inst = id_instr;
    assign IFID_WriteData = reg_write_data;
    
    
    Hazard_Detection_Unit hdu(clk, reset, 
                              ex_MemRead, id_instr[25:21], id_instr[20:16], ex_instr[20:16],
                              stall);
    assign jump_shift_2 = {id_instr[25:0],2'b00};
    CtrlUnit ctrl(clk, reset, id_instr[31:26], 
                  // Output  
                  reg_dst, mem_to_reg, alu_op, 
                  jump,  branch, mem_read, mem_write, alu_src,reg_write,sign_or_zero);  
    
    assign reg_read_addr_1 = id_instr[25:21];  
    assign reg_read_addr_2 = id_instr[20:16];  
   
    register_file reg_file(clk,reset,
                reg_write,reg_read_addr_1,reg_read_addr_2, wb_WriteRegister, 
                reg_write_data,reg_read_data_1,reg_read_data_2); 
                
    XOR_NOR xn(reg_read_data_1, reg_read_data_2, equal);
    
    
    assign sign_ext_im = {{16{id_instr[15]}},id_instr[15:0]};  
    assign zero_ext_im = {{16{1'b0}},id_instr[15:0]};  
    assign imm_ext = sign_or_zero ? sign_ext_im : zero_ext_im;  
    assign im_shift_2 = {imm_ext[29:0], 2'b00};  
    assign no_sign_ext = ~(imm_ext) + 1'b1;  //  1110 -> 0010

    assign PC_beq = (im_shift_2[31] == 1'b1) ? (id_pc4 - no_sign_ext): (id_pc4 +im_shift_2); 
    
    JR_Ctrl JR_Ctrl_unit(alu_op,id_instr[5:0],JRCtrl);  
    
//----------------------------------ID/EX----------------------------------------------------------------------- 
    wire [1:0] ex_RegDst, ex_MemtoReg, ex_ALUOp; 
    wire ex_Jump, ex_Branch, ex_MemWrite, ex_ALUSrc,ex_RegWrite;
    wire [31:0] ex_pc4, ex_ReadData_1, ex_ReadData_2, ex_SignExtend;
    wire [31:0] ex_instr;
    ID_EX id_ex(clk, reset, stall,
                reg_dst, mem_to_reg, alu_op, 
                jump,  branch, mem_read, mem_write, alu_src,reg_write,
                id_pc4, reg_read_data_1, reg_read_data_2, imm_ext,
                id_instr,
                // output 
                ex_RegDst, ex_MemtoReg, ex_ALUOp, 
                ex_Jump, ex_Branch, ex_MemRead, ex_MemWrite, ex_ALUSrc, ex_RegWrite,
                ex_pc4, ex_ReadData_1, ex_ReadData_2, ex_SignExtend,
                ex_instr); 
    // Check point            
    assign IDEX_pc4 = ex_pc4;
    assign IDEX_ReadData1 = ex_ReadData_1;
    assign IDEX_ReadData2 = ex_ReadData_2;
    assign IDEX_SignExtend = ex_SignExtend;
    assign IDEX_inst = ex_instr;
 
    assign EX_alu_op =  ex_ALUOp;
    assign alu_ctrl = ALU_Ctrl;
    
    // Check Forwarding Unit Input
    assign fu_mem_RegWrite = mem_RegWrite;
    assign fu_wb_RegWrite = wb_RegWrite;
    
    Forwarding_Unit fu(mem_RegWrite, 1,
                       ex_instr[31:26], wb_instr[31:26],
                       ex_instr[25:21], ex_instr[20:16], mem_instr[20:16], mem_instr[15:11], wb_instr[20:16], wb_instr[15:11],
                       ForwardA, ForwardB
                       );
    
    ALUCtrl ALUCtrl_unit(clk, reset, ex_ALUOp, ex_SignExtend[5:0], ALU_Ctrl);  
    assign read_data2 = ex_ALUSrc ? ex_SignExtend : ex_ReadData_2;  
 
    assign ALU_input1 = (ForwardA==2'b11)? wb_ReadData:(ForwardA==2'b10)? mem_alu_result:((ForwardA==2'b01)? reg_write_data: ex_ReadData_1);
    assign ALU_input2 = (ForwardB==2'b11)? wb_ReadData:(ForwardB==2'b10)? mem_alu_result:((ForwardB==2'b01)? reg_write_data: read_data2);
    
    alu alu_unit(clk, reset, ALU_input1,ALU_input2,ALU_Ctrl,ALU_out,zero_flag);  
    
    
    
    assign reg_write_dest = (ex_RegDst==2'b10) ? 5'b11111: ((ex_RegDst==2'b01) ? ex_instr[15:11]:ex_instr[20:16]); 
    
//----------------------------------EX/MEM----------------------------------------------------------------------- 
    wire [1:0] mem_MemtoReg;
    wire mem_Jump, mem_Branch, mem_MemRead, mem_MemWrite, mem_RegWrite;
    wire [31:0] mem_add_sum, mem_alu_result, mem_ReadData2;
    wire mem_zero_flag;
    wire [4:0] mem_WriteRegister;
    EX_MEM ex_mem(clk, reset,
                  ex_MemtoReg,  
                  ex_Jump, ex_Branch, ex_MemRead, ex_MemWrite, ex_RegWrite,
                  PC_beq, ALU_out, ex_ReadData_2, 
                  zero_flag,
                  reg_write_dest, ex_instr,
                  // Output
                  mem_MemtoReg,  
                  mem_Jump, mem_Branch, mem_MemRead, mem_MemWrite, mem_RegWrite,
                  mem_PC_beq, mem_alu_result, mem_ReadData2, 
                  mem_zero_flag,
                  mem_WriteRegister, mem_instr);
    // Check Point
    assign EXMEM_PC_beq = mem_PC_beq;
    assign EXMEM_alu_result = mem_alu_result;
    assign EXMEM_ReadData2 = mem_ReadData2; 
    assign EXMEM_WriteRegister = mem_WriteRegister;
    
    // Old Version Branch
//    assign PCSrc = mem_Branch & mem_zero_flag;  
//    assign PC_4beq = PCSrc ? mem_PC_beq : ex_pc4;  
    data_memory datamem(clk, mem_alu_result, mem_ReadData2, mem_MemWrite, mem_MemRead, mem_read_data);  
    
//----------------------------------MEM/WB----------------------------------------------------------------------- 
    wire [1:0] wb_MemtoReg; 
    wire wb_RegWrite;
    wire [31:0] wb_ReadData, wb_alu_result;
    wire [4:0] wb_WriteRegister;
    MEM_WB mem_wb(clk, reset,
                  mem_MemtoReg,  
                  mem_RegWrite,
                  mem_read_data, mem_alu_result,
                  mem_WriteRegister, mem_instr,
                  // Output
                  wb_MemtoReg,  
                  wb_RegWrite,
                  wb_ReadData, wb_alu_result,
                  wb_WriteRegister, wb_instr);
    // Check Point
    assign MEMWB_ReadData = wb_ReadData;
    assign MEMWB_alu_result = wb_alu_result;
    assign MEMWB_WriteRegister = wb_WriteRegister;
    
    assign reg_write_data = (wb_MemtoReg == 2'b10) ? pc4:((wb_MemtoReg == 2'b01)? wb_ReadData : wb_alu_result);  
    
//    assign PC_4beq = PCSrc ? mem_PC_beq : ex_pc4;  // WB???
//    assign PC_j = {ex_pc4[31:28],jump_shift_2};  // WB???
//    assign PC_4beqj = jump ? PC_j : PC_4beq;  
//    assign PC_jr = reg_read_data_1;  
//    assign pc_next = JRCtrl ? PC_jr : PC_4beqj; 
    
    // Check Result
    assign pc_out = no_sign_ext;  
 endmodule  