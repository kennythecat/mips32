module PCadd4 (
    input [31:0] pc_in,
    output [31:0] pc_out
);

    assign pc_out = pc_in + 4'b0100;

endmodule
