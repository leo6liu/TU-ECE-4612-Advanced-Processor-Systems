`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Registers_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Registers_tb();

    reg [4:0] read_reg_1;
    reg [4:0] read_reg_2;
    reg [4:0] write_reg;
    reg [31:0] write_data;
    reg reg_write;
    reg clk;
    wire [31:0] read_data_1;
    wire [31:0] read_data_2;
    
    Registers   M01(read_reg_1,read_reg_2,write_reg,write_data,clk,reg_write,read_data_1,read_data_2);

    initial begin
        read_reg_1 = 0;
        read_reg_2 = 1;
        write_reg = 0;
        write_data = 'habcd0123;
        reg_write = 0;
        clk = 0; // 20ns period
    
        #10 clk = 1;                // read_data should be 0x00000000
        #10 clk = 0;                // read_data should be 0x00000000
        #10 clk = 1;                // read_data should be 0xffffffff
        #10 clk = 0; reg_write = 1; // read_data should be 0xffffffff
        #10 clk = 1;                // read_data should be 0xffffffff
        #10 clk = 0; reg_write = 0; // read_data should be 0xffffffff
        #10 clk = 1;                // read_data should be 0xabcd0123
        #10 clk = 0;                // read_data should be 0xabcd0123
        #10 $finish;
    end
endmodule
