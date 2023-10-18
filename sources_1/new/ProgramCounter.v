module ProgramCounter (
    input clk, reset, stall,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    reg [1:0] cnt = 2'b00; 

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'd0;
            cnt <= 2'b00;
        end
        else if (stall) 
            cnt <= 2'b10; //  Stall 2 Clock Cycle
        else if (cnt > 2'b10) 
            cnt <= cnt - 1'b1;
        else 
            pc_out <= pc_in;
    end
endmodule

