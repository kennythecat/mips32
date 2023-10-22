module tb_XOR_NOR;

    // Declare the signals
    reg [31:0] tb_reg_read_data_1, tb_reg_read_data_2;
    wire tb_nor_result;
    
    // Instantiate the XOR_NOR module
    XOR_NOR uut (
        .reg_read_data_1(tb_reg_read_data_1),
        .reg_read_data_2(tb_reg_read_data_2),
        .nor_result(tb_nor_result)
    );

    initial begin
        // Initialize inputs
        tb_reg_read_data_1 = 32'd0;
        tb_reg_read_data_2 = 32'd0;

        // Test Case 1: Both inputs are 0
        #10;
        $display("Test Case 1: reg_read_data_1 = %b, reg_read_data_2 = %b, nor_result = %b", tb_reg_read_data_1, tb_reg_read_data_2, tb_nor_result);

        // Test Case 2: One input is all 1s, and the other is all 0s
        tb_reg_read_data_1 = 32'hFFFFFFFF;
        tb_reg_read_data_2 = 32'd0;
        #10;
        $display("Test Case 2: reg_read_data_1 = %b, reg_read_data_2 = %b, nor_result = %b", tb_reg_read_data_1, tb_reg_read_data_2, tb_nor_result);

        // Test Case 3: Both inputs are the same non-zero value
        tb_reg_read_data_1 = 32'hAAAA_AAAA;
        tb_reg_read_data_2 = 32'hAAAA_AAAA;
        #10;
        $display("Test Case 3: reg_read_data_1 = %b, reg_read_data_2 = %b, nor_result = %b", tb_reg_read_data_1, tb_reg_read_data_2, tb_nor_result);

        // Test Case 4: Random values
        tb_reg_read_data_1 = 32'h5A3C_B2F1;
        tb_reg_read_data_2 = 32'hA5C3_4D0E;
        #10;
        $display("Test Case 4: reg_read_data_1 = %b, reg_read_data_2 = %b, nor_result = %b", tb_reg_read_data_1, tb_reg_read_data_2, tb_nor_result);
        
        // End the simulation
        $finish;
    end

endmodule

