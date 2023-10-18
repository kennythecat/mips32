module Pc_add4;

    reg clk, reset, stall;
    wire [31:0] pc_input;  // output of Add_Pc module
    reg [31:0] pc_feed;    // Used to feed data to ProgramCounter
    wire [31:0] pc_next, pc_current;

    // Clock Generation
    always begin
        #5 clk = ~clk;
    end

    // Instantiate mips32 components
    ProgramCounter P_C(
        .clk(clk), 
        .reset(reset), 
        .stall(stall),
        .pc_in(pc_feed),  // Feed this to ProgramCounter
        .pc_out(pc_current)
    );

    Add_Pc pc_add4(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_current),
        .pc_out(pc_input)  // capture the output
    );

    // Testbench Logic
    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        stall = 0;
        pc_feed = 32'd0;

        // Reset cycle
        #10 reset = 0;
        
        // Let the system run without stalling
        #10 stall = 0;
        #10 pc_feed = pc_input;  // Feed the output of Add_Pc to ProgramCounter

        // Introduce a stall
        #10 stall = 1;
        #10;

        // Release the stall
        #10 stall = 0;
        #20 pc_feed = pc_input;  // Continue feeding

        // End the simulation
        $finish;
    end
endmodule
