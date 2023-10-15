module register_file  (  
    input clk, reset,  
    input reg_write_en,  
    input [4:0] read_reg1, read_reg2, read_dest, // Read Destination = Write Register
    input [31:0] write_data,  
    output[31:0] read_data1, read_data2
    );  
    reg [31:0] reg_array [31:0];  
    integer i;
    
    always @ (*) begin  
        if(reset) begin  
            for(i = 0; i < 32; i = i+1) 
                reg_array[i] = 32'b0;     
        end  
        else begin  
            if(reg_write_en) 
                reg_array[read_dest] = write_data;  
        end  
    end  
    assign read_data1 = ( read_reg1 == 0)? 32'b0 : reg_array[read_reg1];  
    assign read_data2 = ( read_reg2 == 0)? 32'b0 : reg_array[read_reg2];  
endmodule   
