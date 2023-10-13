module data_memory(  
    input clk,  
    input  [31:0] address, write_data,  
    input mem_write_en, mem_read_en,  
    output [31:0] read_data  
    );  
    integer i;  
    reg [31:0] ram [255:0];  // 256 words of 32 bits each
    wire [8:0] ram_addr = address[9:2];  
    initial begin  
        for(i=0;i<256;i=i+1)
         ram[i] <= 32'd0;  
    end  
    always @(posedge clk) begin  
        if (mem_write_en)
         ram[ram_addr] <= write_data;  
    end  
    assign read_data = (mem_read_en) ? ram[ram_addr]: 32'd0;   
endmodule   
