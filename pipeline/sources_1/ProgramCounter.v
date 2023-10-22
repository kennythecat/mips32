module ProgramCounter (
    input clk, reset, stall,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'd0;
        end
        else if (stall);
        else 
            pc_out <= pc_in;
    end
endmodule

