module mips_32( 
    input clk,reset,  
    
    output [31:0] IFID_pc4, IFID_inst, 
    
    output [1:0] ID_alu_op,
    
    output [31:0] IDEX_pc4, IDEX_ReadData1, IDEX_ReadData2, IDEX_SignExtend,
    output [4:0]  IDEX_inst25_21, IDEX_inst20_16, IDEX_inst15_11,
    
    output fu_mem_RegWrite, fu_wb_RegWrite,
    output [4:0] fu_ex_instr25_21,  fu_ex_instr20_16, fu_mem_instr15_11, fu_wb_instr15_11,

    output [1:0] EX_alu_op, ForwardA, ForwardB,
    output [3:0] alu_ctrl,
    output [31:0] ALU_input1, ALU_input2,
    
    output [31:0] EXMEM_PC_beq, EXMEM_alu_result, EXMEM_ReadData2, 
    output [4:0]  EXMEM_WriteRegister,
    
    output [31:0] MEMWB_ReadData, MEMWB_alu_result,
    output [4:0]  MEMWB_WriteRegister,
    
    output [31:0] pc_out
   ); 
    reg [31:0] pc_current;  
    wire signed[31:0] pc_next, pc4;  
    wire [31:0] instr;  
    wire [1:0] reg_dst,mem_to_reg,alu_op;  
    wire jump,branch,mem_read,mem_write,alu_src,reg_write;  
    wire [4:0]  reg_write_dest;  
    wire [31:0] reg_write_data;  
    wire [4:0]  reg_read_addr_1,reg_read_addr_2;  
    wire [31:0] reg_read_data_1,reg_read_data_2;  
    wire [31:0] sign_ext_im,read_data2,zero_ext_im,imm_ext;  
    wire JRCtrl;  
    wire [3:0] ALU_Ctrl;  
//    wire [31:0] ALU_input1, ALU_input2;
    wire [31:0] ALU_out;  
    wire zero_flag;  
    wire signed[31:0] im_shift_2, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
    wire beq_control;  
    wire [27:0] jump_shift_2;  
    wire [31:0] mem_read_data;  
    wire [31:0] no_sign_ext;  
    wire sign_or_zero;  
//    wire [1:0] ForwardA, ForwardB;
    // PC   
    initial pc_current <= 32'd0;
    
    always @(posedge clk or posedge reset) begin   
          if(reset) pc_current <= 32'd0; 
          else  pc_current <= pc_current+4;
//          else pc_current <= pc_next;              
    end  
    assign pc4 = pc_current + 32'd4; // pc+4  
    inst_mem instrucion_memory(clk, reset, pc_current, instr);  
    
//----------------------------------IF/ID-----------------------------------------------------------------------    
    wire [31:0] id_pc4, id_instr;
    IF_ID if_id(clk, reset, pc4, instr, 
                // Output
                id_pc4, id_instr);
    // Check point
    assign IFID_pc4 = id_pc4;
    assign ID_alu_op =  alu_op;
    assign IFID_inst = id_instr;
    
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
    assign sign_ext_im = {{16{id_instr[15]}},id_instr[15:0]};  
    assign zero_ext_im = {{16{1'b0}},id_instr[15:0]};  
    assign imm_ext = sign_or_zero ? sign_ext_im : zero_ext_im;  
    JR_Ctrl JR_Ctrl_unit(alu_op,id_instr[5:0],JRCtrl);  
//----------------------------------ID/EX----------------------------------------------------------------------- 
    wire [1:0] ex_RegDst, ex_MemtoReg, ex_ALUOp; 
    wire ex_Jump, ex_Branch, ex_MemRead, ex_MemWrite, ex_ALUSrc,ex_RegWrite;
    wire [31:0] ex_pc4, ex_ReadData_1, ex_ReadData_2, ex_SignExtend;
    wire [4:0] ex_instr25_21, ex_instr20_16, ex_instr15_11;
    ID_EX id_ex(clk, reset, 
                reg_dst, mem_to_reg, alu_op, 
                jump,  branch, mem_read, mem_write, alu_src,reg_write,
                id_pc4, reg_read_data_1, reg_read_data_2, imm_ext,
                id_instr,
                // output 
                ex_RegDst, ex_MemtoReg, ex_ALUOp, 
                ex_Jump, ex_Branch, ex_MemRead, ex_MemWrite, ex_ALUSrc, ex_RegWrite,
                ex_pc4, ex_ReadData_1, ex_ReadData_2, ex_SignExtend,
                ex_instr25_21, ex_instr20_16, ex_instr15_11); // rs rt rd
    // Check point            
    assign IDEX_pc4 = ex_pc4;
    assign IDEX_ReadData1 = ex_ReadData_1;
    assign IDEX_ReadData2 = ex_ReadData_2;
    assign IDEX_SignExtend = ex_SignExtend;
    assign IDEX_inst25_21 = ex_instr25_21;
    assign IDEX_inst20_16 = ex_instr20_16;
    assign IDEX_inst15_11 = ex_instr15_11;
    assign EX_alu_op =  ex_ALUOp;
    assign alu_ctrl = ALU_Ctrl;
    
    // Check Forwarding Unit Input
    assign fu_mem_RegWrite = mem_RegWrite;
    assign fu_wb_RegWrite = wb_RegWrite;
    assign fu_ex_instr25_21 = ex_instr25_21;
    assign fu_ex_instr20_16 = ex_instr20_16;
    assign fu_mem_instr15_11 = mem_instr15_11;
    assign fu_wb_instr15_11 = wb_instr15_11;
    
    Forwarding_Unit fu(mem_RegWrite, wb_RegWrite,
                       ex_instr25_21 , ex_instr20_16, mem_instr15_11, wb_instr15_11,
                       //  Output
                       ForwardA, ForwardB
                       );
    
    ALUCtrl ALUCtrl_unit(clk, reset, ex_ALUOp, ex_SignExtend[5:0], ALU_Ctrl);  
    assign read_data2 = ex_ALUSrc ? ex_SignExtend : ex_ReadData_2;  //  2nd Mux
 
    assign ALU_input1 = (ForwardA==2'b10)? mem_alu_result:((ForwardA==2'b01)? reg_write_data: ex_ReadData_1);
    assign ALU_input2 = (ForwardB==2'b10)? mem_alu_result:((ForwardB==2'b01)? reg_write_data: read_data2);
    
    alu alu_unit(clk, reset, ALU_input1,ALU_input2,ALU_Ctrl,ALU_out,zero_flag);  
    
    assign im_shift_2 = {ex_SignExtend[29:0], 2'b00};  
    assign no_sign_ext = ~(ex_SignExtend) + 1'b1;  
    
    wire [31:0] Add_Sum;
    assign Add_Sum = ex_pc4 +im_shift_2;
    assign PC_beq = (im_shift_2[31] == 1'b1) ? (ex_pc4 - no_sign_ext): Add_Sum; 
    assign reg_write_dest = (ex_RegDst==2'b10) ? 5'b11111: ((ex_RegDst==2'b01) ? ex_instr15_11:ex_instr20_16);  // First Mux
    
//----------------------------------EX/MEM----------------------------------------------------------------------- 
    wire [1:0] mem_MemtoReg;
    wire mem_Jump, mem_Branch, mem_MemRead, mem_MemWrite, mem_RegWrite;
    wire [31:0] mem_add_sum, mem_alu_result, mem_ReadData2;
    wire mem_zero_flag;
    wire [4:0] mem_WriteRegister, mem_instr15_11;
    EX_MEM ex_mem(clk, reset,
                  ex_MemtoReg,  
                  ex_Jump, ex_Branch, ex_MemRead, ex_MemWrite, ex_RegWrite,
                  PC_beq, ALU_out, ex_ReadData_2, 
                  zero_flag,
                  reg_write_dest, ex_instr15_11,
                  // Output
                  mem_MemtoReg,  
                  mem_Jump, mem_Branch, mem_MemRead, mem_MemWrite, mem_RegWrite,
                  mem_PC_beq, mem_alu_result, mem_ReadData2, 
                  mem_zero_flag,
                  mem_WriteRegister, mem_instr15_11);
    // Check Point
    assign EXMEM_PC_beq = mem_PC_beq;
    assign EXMEM_alu_result = mem_alu_result;
    assign EXMEM_ReadData2 = mem_ReadData2; 
    assign EXMEM_WriteRegister = mem_WriteRegister;
    
    assign beq_control = mem_Branch & mem_zero_flag;  
    data_memory datamem(clk, mem_alu_result, mem_ReadData2, mem_MemWrite, mem_MemRead, mem_read_data);  
    
//----------------------------------MEM/WB----------------------------------------------------------------------- 
    wire [1:0] wb_MemtoReg; 
    wire wb_RegWrite;
    wire [31:0] wb_ReadData, wb_alu_result;
    wire [4:0] wb_WriteRegister, wb_instr15_11;
    MEM_WB mem_wb(clk, reset,
                  mem_MemtoReg,  
                  mem_RegWrite,
                  mem_read_data, mem_alu_result,
                  mem_WriteRegister, mem_instr15_11,
                  // Output
                  wb_MemtoReg,  
                  wb_RegWrite,
                  wb_ReadData, wb_alu_result,
                  wb_WriteRegister, wb_instr15_11);
    // Check Point
    assign MEMWB_ReadData = wb_ReadData;
    assign MEMWB_alu_result = wb_alu_result;
    assign MEMWB_WriteRegister = wb_WriteRegister;
    
    assign reg_write_data = (wb_MemtoReg == 2'b10) ? pc4:((wb_MemtoReg == 2'b01)? wb_ReadData : wb_alu_result);  
    
    assign PC_4beq = beq_control ? mem_PC_beq : ex_pc4;  // WB???
    assign PC_j = {ex_pc4[31:28],jump_shift_2};  // WB???
    assign PC_4beqj = jump ? PC_j : PC_4beq;  
    assign PC_jr = reg_read_data_1;  
    assign pc_next = JRCtrl ? PC_jr : PC_4beqj; 
    
    // Check Result
    assign pc_out = pc_current;  
 endmodule  