module alu_tb;

    reg clk, reset;
    reg [31:0] a, b;
    reg [3:0] ALU_Ctrl;
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU
    alu uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .ALU_Ctrl(ALU_Ctrl),
        .result(result),
        .zero(zero)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Generate a clock with a period of 10 time units
    end

    // Testbench logic
    initial begin
        // Initialization
        clk = 0; 
        reset = 1;
        a = 32'd4;
        b = 32'd8;
        
        #10 reset = 0; // Deassert reset after 10 time units
        #10 ALU_Ctrl = 4'b0010; // Test addition
        #10 ALU_Ctrl = 4'b0110; // Test subtraction
        #10 ALU_Ctrl = 4'b0000; // Test AND
        #10 ALU_Ctrl = 4'b0001; // Test OR
        #10 ALU_Ctrl = 4'b0111; // Test less than
        
        #10 $finish; // End simulation after testing a few operations
    end

endmodule
