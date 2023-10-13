module tb_ALUCtrl_JR_Ctrl;
    // Signals
    reg [1:0] ALUOp;
    reg [5:0] funct;
    wire [3:0] ALU_Ctrl;
    wire JRCtrl;

    // Instantiate ALUCtrl
    ALUCtrl alu_ctrl (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALU_Ctrl(ALU_Ctrl)
    );

    // Instantiate JR_Ctrl
    JR_Ctrl jr_ctrl (
        .ALUOp(ALUOp),
        .funct(funct[3:0]),
        .JRCtrl(JRCtrl)
    );

    initial begin
        $display("ALUOp, funct, ALU_Ctrl, JRCtrl");
        #10
        // Test cases
        ALUOp = 2'b00; funct = 6'bxxxxxx; #10;  // For lw/sw  and JRCtrl=0
        ALUOp = 2'b01; funct = 6'bxxxxxx; #10;  // For Branch and JRCtrl=0
        ALUOp = 2'b10; funct = 6'b100000; #10;  // For ADD and JRCtrl=0
        ALUOp = 2'b10; funct = 6'b100010; #10;  // For SUB and JRCtrl=0
        ALUOp = 2'b10; funct = 6'b100100; #10;  // For AND and JRCtrl=0
        ALUOp = 2'b10; funct = 6'b100101; #10;  // For OR and JRCtrl=0
        ALUOp = 2'b10; funct = 6'b101010; #10;  // For SLT and JRCtrl=0
        ALUOp = 2'b11; funct = 6'b111111; #10;  // Default and JRCtrl=0
        ALUOp = 2'b00; funct = 6'b001000; #10;  //  JRCtrl=1

        $finish;
    end

    always @(ALUOp or funct) begin
        $display("%b, %b, %b, %b", ALUOp, funct, ALU_Ctrl, JRCtrl);
    end

endmodule
