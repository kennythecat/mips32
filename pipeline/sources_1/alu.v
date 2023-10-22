module alu(
    input clk, reset,
    input [31:0] a, b,
    input [3:0] ALU_Ctrl,
    output reg [31:0] result,
    output zero
);

    wire [31:0] add_sub_result;
    wire ov;   // Overflow flag
    reg sub;  

    AdderSubtractor32 adder_sub(
        .A(a),
        .B(b),
        .SUB(sub),
        .Y(add_sub_result),
        .OV(ov),
        .Z(zero)
    );

    always @(*) begin
        if(reset) 
            sub = 0;
        else 
            case(ALU_Ctrl)
                4'b0010: sub = 0;      // add
                4'b0110: sub = 1;      // sub
                default: sub = 0;      // Default to addition
            endcase
    end

    always @(*) begin
        casex(ALU_Ctrl)
            4'b0x10: result = add_sub_result;
            4'b0000: result = a & b;          // and
            4'b0001: result = a | b;          // or
            4'b0111: result = (a < b) ? 32'd1 : 32'd0; // less than
            default: result = add_sub_result; 
        endcase
    end

endmodule

module FullAdder(
    input a, b, cin,    
    output sum, cout    
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));

endmodule

module AdderSubtractor32(
    input [31:0] A, B,
    input SUB,
    output [31:0] Y,
    output OV,  // overflow
    output Z    // zero
);

    wire [31:0] B_complement;
    wire [31:0] sum;
    wire [31:0] c;

    assign B_complement = B ^ {32{SUB}};

    genvar i;
    generate
        for (i = 0; i < 32; i = i+1) begin: FA
            FullAdder FA_inst(
                .a(A[i]),
                .b(B_complement[i]),
                .cin(i == 0 ? SUB : c[i-1]),
                .sum(sum[i]),
                .cout(c[i])
            );
        end
    endgenerate

    assign Y = sum;
    assign OV = c[31] ^ c[30];   // Overflow if the last two carries are different
    assign Z = (Y == 32'b0);

endmodule

