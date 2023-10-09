module mips_32( 
    input clk,reset,  
    output[31:0] r1,r2, wd,alu_o,
    output [4:0] rr1,rr2,wr,
    output[31:0] pc_out, alu_result
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
    wire [31:0] ALU_out;  
    wire zero_flag;  
    wire signed[31:0] im_shift_2, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr;  
    wire beq_control;  
    wire [27:0] jump_shift_2;  
    wire [31:0] mem_read_data;  
    wire [31:0] no_sign_ext;  
    wire sign_or_zero;  
    // PC   
    always @(posedge clk or posedge reset) begin   
          if(reset) pc_current <= 32'd0;  
          else pc_current <= pc_next;              
    end  
    assign pc4 = pc_current + 32'd4; // pc+4  
    instr_mem instrucion_memory(pc_current,instr);  
    assign jump_shift_2 = {instr[25:0],2'b00};
    CtrlUnit ctrl(reset,instr[31:26], 
                reg_dst, mem_to_reg, alu_op, 
                jump,  branch, mem_read, mem_write, alu_src,reg_write,sign_or_zero);  
    assign reg_write_dest = (reg_dst==2'b10) ? 5'b11111: ((reg_dst==2'b01) ? instr[15:11] :instr[20:16]);  // First Mux
    assign reg_read_addr_1 = instr[25:21];  
    assign reg_read_addr_2 = instr[20:16];  
    
    // Check Register File input
    assign rr1 = reg_read_addr_1;
    assign rr2 = reg_read_addr_2;
    assign wr  = reg_write_dest;
    assign wd  = reg_write_data;
    
    register_file reg_file(clk,reset,
                reg_write,reg_read_addr_1,reg_read_addr_2,reg_write_dest,
                reg_write_data,reg_read_data_1,reg_read_data_2); 
    // IF/ID
    assign sign_ext_im = {{16{instr[15]}},instr[15:0]};  
    assign zero_ext_im = {{16{1'b0}},instr[15:0]};  
    assign imm_ext = sign_or_zero ? sign_ext_im : zero_ext_im;  
    JR_Ctrl JR_Ctrl_unit(alu_op,instr[5:0],JRCtrl);  
    // ID/EXE     
    ALUCtrl ALUCtrl_unit(alu_op,instr[5:0],ALU_Ctrl);  
    assign read_data2 = alu_src ? imm_ext : reg_read_data_2;  //  2nd Mux
    
    // check ALU input
    assign r1 = reg_read_data_1;
    assign r2 = read_data2;
    
    alu alu_unit(reg_read_data_1,read_data2,ALU_Ctrl,ALU_out,zero_flag);  
    assign im_shift_2 = {imm_ext[29:0], 2'b00};  
    assign no_sign_ext = ~(im_shift_2) + 1'b1;  
    assign PC_beq = (im_shift_2[31] == 1'b1) ? (pc4 - no_sign_ext): (pc4 +im_shift_2);  
    assign beq_control = branch & zero_flag;  
    assign PC_4beq = beq_control ? PC_beq : pc4;  
    assign PC_j = {pc4[31:28],jump_shift_2};
    //check alu output
    assign alu_o = ALU_out;
    // EXE/DM
    assign PC_4beqj = jump ? PC_j : PC_4beq;  
    assign PC_jr = reg_read_data_1;  
    assign pc_next = JRCtrl ? PC_jr : PC_4beqj;  
    data_memory datamem(clk,ALU_out,reg_read_data_2,mem_write,mem_read,mem_read_data);  
    assign reg_write_data = (mem_to_reg == 2'b10) ? pc4:((mem_to_reg == 2'b01)? mem_read_data: ALU_out);  
    assign pc_out = pc_current;  
    assign alu_result = ALU_out;  
 endmodule  