module inst_mem_tb;

    reg clk, reset;
    reg [31:0] pc;
    wire [31:0] instruction;

    // Instantiate the inst_mem module
    inst_mem uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instruction(instruction)
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
        pc = 0;
        
        #10 reset = 0; // Deassert reset after 10 time units
        #10 pc = 32'd4; // Fetch next instruction
        #10 pc = 32'd8; // Fetch next instruction
        #10 pc = 32'd12; // Fetch next instruction
        #10 pc = 32'd16; // Fetch next instruction
        #10 pc = 32'd20; // Fetch next instruction
        #10 pc = 32'd24; // Fetch next instruction
        #10 pc = 32'd28; // Fetch next instruction
        
        #10 $finish; // End simulation after fetching a few instructions
    end

endmodule
