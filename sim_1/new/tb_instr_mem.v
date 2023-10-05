module tb_instr_mem;
    parameter CLK_PERIOD = 20; 
    reg [31:0] pc;
    wire [31:0] instruction;
    reg clk = 0;  

    instr_mem uut (
        .pc(pc),
        .instruction(instruction)
    );

    always # (CLK_PERIOD / 2) clk = ~clk;

    integer i;

    initial begin
        pc = 32'b0;
        wait (clk == 1);

        // Test for the first 15 addresses (0 to 14)
        for ( i = 0; i < 15; i = i + 1) begin
            pc = i;  // Multiply by 4 to get the byte address
            #CLK_PERIOD;  // Wait for a clock cycle
            $display("PC: %h, Instruction: %b", pc, instruction);
        end
        $finish;
    end
endmodule
