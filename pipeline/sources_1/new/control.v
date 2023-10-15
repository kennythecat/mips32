module CtrlUnit(
    input clk, reset,
    input [5:0] opcode,  
    output reg [1:0] RegDst, MemtoReg, ALUOp,  
    output reg Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, sign_or_zero                      
    );  
    always @(*)  begin  
        if(reset == 1'b1) begin
            ALUOp = 2'b00;
            MemRead = 0; MemWrite = 0; RegWrite = 0;
            RegDst = 0; ALUSrc = 0; MemtoReg = 0; Branch = 0; Jump = 0;  
            sign_or_zero = 1;  
            end  
        else begin    
          case (opcode)
            6'b100011: begin // lw
                ALUOp = 2'b00;
                MemRead = 1; MemWrite = 0; RegWrite = 1;
                RegDst = 2'b00; ALUSrc = 2'b01; MemtoReg = 2'b01; Branch = 0; Jump = 0;
                sign_or_zero = 1;
            end

            6'b101011: begin // sw
                ALUOp = 2'b00;
                MemRead = 0; MemWrite = 1; RegWrite = 0;
                RegDst = 2'b00; ALUSrc = 2'b01; MemtoReg = 2'b00; Branch = 0; Jump = 0;
                sign_or_zero = 1;
            end

            6'b000100: begin // beq
                ALUOp = 2'b01;
                MemRead = 0; MemWrite = 0; RegWrite = 0;
                RegDst = 2'b00; ALUSrc = 2'b00; MemtoReg = 2'b00; Branch = 1; Jump = 0;
                sign_or_zero = 0; // For subtraction in ALU
            end

            6'b000000: begin // R-type
                ALUOp = 2'b10;
                MemRead = 0; MemWrite = 0; RegWrite = 1;
                RegDst = 2'b01; ALUSrc = 2'b00; MemtoReg = 2'b00; Branch = 0; Jump = 0;
                sign_or_zero = 1;
            end
            6'b000010: begin // J
                ALUOp = 2'b00;
                MemRead = 0; MemWrite = 0; RegWrite = 0;
                RegDst = 2'b00; ALUSrc = 2'b00; MemtoReg = 2'b00; Branch = 0; Jump = 1;
                sign_or_zero = 1;
            end
            6'b000011: begin // Jal
                ALUOp = 2'b00;
                MemRead = 0; MemWrite = 0; RegWrite = 0;
                RegDst = 2'b10; ALUSrc = 2'b00; MemtoReg = 2'b10; Branch = 0; Jump = 1;
                sign_or_zero = 1;
            end
            6'b001000: begin // addi
                ALUOp = 2'b11;
                MemRead = 0; MemWrite = 0; RegWrite = 1;
                RegDst = 2'b00; ALUSrc = 2'b01; MemtoReg = 2'b00; Branch = 0; Jump = 0;
                sign_or_zero = 1;
            end
            default: begin // R-type
                ALUOp = 2'b10;
                MemRead = 0; MemWrite = 0; RegWrite = 1;
                RegDst = 2'b01; ALUSrc = 2'b00; MemtoReg = 2'b00; Branch = 0; Jump = 0;
                sign_or_zero = 1;
            end  
          endcase  
      end  
     end  
 endmodule
