module XOR_NOR (
    input [31:0] reg_read_data_1, reg_read_data_2,
    output nor_result
);
    wire [31:0] xor_result;

    assign xor_result = reg_read_data_1 ^ reg_read_data_2;

    assign nor_result = ~( | xor_result);

endmodule
