module CtrlUnit_tb;

    reg clk, reset;
    reg [5:0] opcode;
    wire [1:0] RegDst, MemtoReg, ALUOp;
    wire Jump, Branch, MemRead, MemWrite, ALUSrc, RegWrite, sign_or_zero;

    CtrlUnit uut (
        .clk(clk),
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

    // Clock generation
    always begin
        #5 clk = ~clk; // Generate a clock with a period of 10 time units
    end

    // Testbench logic
    initial begin
        clk = 0; 
        reset = 1;
        #10 reset = 0; // Deassert reset after 10 time units
        
        #10 opcode = 6'b100011; // Test lw
        #10 opcode = 6'b101011; // Test sw
        #10 opcode = 6'b000100; // Test beq
        #10 opcode = 6'b000000; // Test R-type
        #10 opcode = 6'b000010; // Test J
        #10 opcode = 6'b000011; // Test Jal
        #10 opcode = 6'b001000; // Test addi

        #10 $finish; // End simulation after testing
    end

endmodule
