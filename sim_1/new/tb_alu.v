module tb_alu;

    reg [31:0] a, b;
    reg [3:0] ALU_Ctrl;
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU
    alu uut (
        .a(a),
        .b(b),
        .ALU_Ctrl(ALU_Ctrl),
        .result(result),
        .zero(zero)
    );

    // Testbench logic
    initial begin
        $display("Time\tALU_Ctrl\tA\tB\tResult\tZero");
        
        // Test for addition
        a = 32'd5; b = 32'd3; ALU_Ctrl = 4'b0010; 
        #10 $display("%d\t%d\t%d\t%d\t%d\t%d", $time, ALU_Ctrl, a, b, result, zero);
        
        // Test for subtraction
        a = 32'd5; b = 32'd3; ALU_Ctrl = 4'b0110; 
        #10 $display("%d\t%d\t%d\t%d\t%d\t%d", $time, ALU_Ctrl, a, b, result, zero);
        
        // Test for AND
        a = 32'd5; b = 32'd3; ALU_Ctrl = 4'b0000; 
        #10 $display("%d\t%d\t%d\t%d\t%d\t%d", $time, ALU_Ctrl, a, b, result, zero);
        
        // Test for OR
        a = 32'd5; b = 32'd3; ALU_Ctrl = 4'b0001; 
        #10 $display("%d\t%d\t%d\t%d\t%d\t%d", $time, ALU_Ctrl, a, b, result, zero);
        
        // Test for less than
        a = 32'd5; b = 32'd3; ALU_Ctrl = 4'b0111; 
        #10 $display("%d\t%d\t%d\t%d\t%d\t%d", $time, ALU_Ctrl, a, b, result, zero);
        
        // End of the test
        $finish;
    end
endmodule
