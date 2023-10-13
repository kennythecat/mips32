`timescale 1ns / 1ps

module tb_mips32;  
    reg clk;  
    reg reset;  
    
    wire [4:0] rr1,rr2,wr;
    wire [3:0] alu_ctrl;
    wire [31:0] r1, r2,wd,alu_o;
    wire [31:0] pc_out;  
    wire [31:0] alu_result; 
    
    mips_32 uut (  
        .clk(clk),   
        .reset(reset),
        .wr(wr),
        .wd(wd),
        .alu_ctrl(alu_ctrl),
        .rr1(rr1),
        .rr2(rr2),
        .r1(r1),
        .r2(r2),
        .alu_o(alu_o),   
        .pc_out(pc_out),   
        .alu_result(alu_result)  
        );  
    always #5 clk = ~clk; 
    initial begin  
        clk = 0; reset = 1;
        
        #10 reset = 0;  
    end  
endmodule  
