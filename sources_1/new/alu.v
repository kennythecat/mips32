module alu(       
    input [31:0] a, b,         
    input [3:0] ALU_Ctrl,     
    output reg [31:0] result,   
    output zero  
    );  
    always @(*) begin   
          case(ALU_Ctrl)  
              4'b0010: result = a + b; // add  
              4'b0110: result = a - b; // sub  
              4'b0000: result = a & b; // and  
              4'b0001: result = a | b; // or  
              4'b0111: begin 
                if (a<b) result = 32'd1;  
                else result = 32'd0;  
              end  
              default:result = a + b; // add  
          endcase  
        end  
    assign zero = (result==32'd0) ? 1:0;  
endmodule  
