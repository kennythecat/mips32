module tb_CtrlUnit;

    reg reset;
    reg [5:0] opcode;
    wire [1:0] RegDst, MemtoReg, ALUOp;
    wire Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, sign_or_zero;

    // Instantiate the CtrlUnit
    CtrlUnit uut (
        .reset(reset),
        .opcode(opcode),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .sign_or_zero(sign_or_zero)
    );

    // Test sequence
    initial begin
        $display("reset, opcode, RegDst, MemtoReg, ALUOp, Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, sign_or_zero");
        
        // Reset the control unit
        reset = 1;
        opcode = 6'b0;
        #10;
        
        // Test for various opcodes
        reset = 0;
        opcode = 6'b100011;  // lw
        #10;

        opcode = 6'b101011;  // sw
        #10;

        opcode = 6'b000100;  // beq
        #10;

        opcode = 6'b000000;  // R-type
        #10;

        opcode = 6'b000010;  // J
        #10;

        opcode = 6'b001000;  // addi
        #10;

        opcode = 6'b011111;  // some random opcode
        #10;

        $finish;
    end

    // Monitor the outputs for each opcode
    always @(posedge reset or posedge opcode) begin
        $display("%b, %b, %b, %b, %b, %b, %b, %b, %b, %b, %b, %b", 
                 reset, opcode, RegDst, MemtoReg, ALUOp, Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, sign_or_zero);
    end

endmodule
