module ALUCtrl(   
    input clk, reset,
    input [1:0] ALUOp,  
    input [5:0] funct,
    output reg[3:0] ALU_Ctrl  
    );
     wire [7:0] ALUCtrl_In;  
     assign ALUCtrl_In = {ALUOp, funct};  
     always @(*)  
         casex (ALUCtrl_In)  
              8'b00xxxxxx: ALU_Ctrl=4'b0010; // lw/sw  
              8'b01xxxxxx: ALU_Ctrl=4'b0110; // Branch 
              8'b11xxxxxx: ALU_Ctrl=4'b0010; // ADDI 
              8'b10100000: ALU_Ctrl=4'b0010; // ADD 
              8'b10100010: ALU_Ctrl=4'b0110; // SUB  
              8'b10100100: ALU_Ctrl=4'b0000; // AND
              8'b10100101: ALU_Ctrl=4'b0001; // OR
              8'b10101010: ALU_Ctrl=4'b0111; // SLT
              default: ALU_Ctrl=4'b0010;  
          endcase  
 endmodule  

module JR_Ctrl( // Jump Register Control
    input clk, reset,
    input[1:0] ALUOp, 
    input [3:0] funct,
    output reg JRCtrl
    );
    always @(*) 
        JRCtrl = ({ALUOp, funct}==8'b00001000) ? 1'b1 : 1'b0;
     
 endmodule
