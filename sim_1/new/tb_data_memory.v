module tb_data_memory;

    // Declare signals
    reg clk;
    reg [31:0] address, write_data;
    reg mem_write_en, mem_read_en;
    wire [31:0] read_data;

    // Instantiate the DUT (Device Under Test)
    data_memory uut(
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .mem_write_en(mem_write_en),
        .mem_read_en(mem_read_en),
        .read_data(read_data)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Generate a clock with time period of 10 units
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        address = 0;
        write_data = 0;
        mem_write_en = 0;
        mem_read_en = 0;

        // Write to address 0
        address = 32'h0000_0008; // As we're using address[8:1] for actual addressing, this corresponds to ram[1]
        write_data = 32'hDEAD_BEEF;
        mem_write_en = 1;
        #10;

        // Read from address 0
        mem_write_en = 0;
        mem_read_en = 1;
        #10;

        // Check if read_data matches write_data
        if(read_data == write_data) 
            $display("Test Passed: read_data = %h", read_data);
        else
            $display("Test Failed: Expected %h but got %h", write_data, read_data);

        // Finish simulation
        $finish;
    end

endmodule
