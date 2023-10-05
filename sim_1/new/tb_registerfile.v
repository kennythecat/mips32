module tb_register_file;

    // Testbench signals
    reg clk, reset, reg_write_en;
    reg [4:0] read_reg1, read_reg2, read_dest;
    reg [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    // Instantiate the register_file module
    register_file uut (
        .clk(clk),
        .reset(reset),
        .reg_write_en(reg_write_en),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .read_dest(read_dest),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate a clock with period of 10 time units
    end

    // Test sequence
    initial begin
        $display("Time, read_reg1, read_reg2, read_dest, write_data, read_data1, read_data2");

        // Initialize signals
        reset = 1;
        reg_write_en = 0;
        read_reg1 = 5'b0;
        read_reg2 = 5'b0;
        read_dest = 5'b0;
        write_data = 32'b0;
        #10;

        reset = 0;
        #10;

        // Write to register 5
        reg_write_en = 1;
        read_dest = 5;
        write_data = 32'd25;
        #10;

        // Write to register 8
        read_dest = 8;
        write_data = 32'd58;
        #10;

        reg_write_en = 0;
        #10;

        // Read from register 5 and 8
        read_reg1 = 5;
        read_reg2 = 8;
        #10;

        // Read from register 5 and 0 (zero register)
        read_reg1 = 5;
        read_reg2 = 0;
        #10;

        // Read from register 0 (zero register) and 8
        read_reg1 = 0;
        read_reg2 = 8;
        #10;

        $finish;
    end

    // Monitor the outputs
    always @(posedge clk) begin
        $display("%d, %b, %b, %b, %b, %b, %b", 
                 $time, read_reg1, read_reg2, read_dest, write_data, read_data1, read_data2);
    end

endmodule
