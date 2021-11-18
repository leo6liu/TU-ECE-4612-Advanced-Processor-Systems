`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: DataMemory_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemory_tb();

    reg [31:0] address;
    reg [31:0] write_data;
    reg mem_write;
    reg mem_read;
    reg clk;
    wire [31:0] read_data;
    
    DataMemory M1(.address(address), .write_data(write_data), .read_data(read_data), .mem_write(mem_write), .mem_read(mem_read), .clk(clk));
    
    initial begin
        address = 0;
        write_data = 'habcd0123;
        mem_write = 0;
        mem_read = 0;
        clk = 0; // 20ns period
    
        #10 clk = 1;                // read_data should be 0xffffffff
        #10 clk = 0;                // read_data should be 0xffffffff
        #10 clk = 1; mem_read = 1;  // read_data should be 0x00000000
        #10 clk = 0;                // read_data should be 0x00000000
        #10 clk = 1; mem_read = 0;  // read_data should be 0xffffffff
        #10 clk = 0;                // read_data should be 0xffffffff
        #10 clk = 1;                // read_data should be 0xffffffff
        #10 clk = 0; mem_write = 1; // read_data should be 0xffffffff
        #10 clk = 1;                // read_data should be 0xffffffff
        #10 clk = 0; mem_write = 0; // read_data should be 0xffffffff
        #10 clk = 1; mem_read = 1;  // read_data should be 0xabcd0123
        #10 clk = 0;                // read_data should be 0xabcd0123
        #10 clk = 1; address = 1;   // read_data should be 0x00000000
        #10 clk = 0;                // read_data should be 0x00000000
        #10 $finish;
    end
endmodule
