`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder32bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder32bit_tb();

    reg[31:0]   a,b;
    reg         c_in;
    wire[31:0]  sum;
    wire        c_out;
    
    Adder32bit   M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in));
    
    initial begin
        #10 a = 0; b = 0; c_in = 0;     // 0x 0 0000 0000
        #10 a = 0; b = 0; c_in = 1;     // 0x 0 0000 0001
        #10 a = 0; b = 2; c_in = 0;     // 0x 0 0000 0002
        #10 a = 0; b = 2; c_in = 1;     // 0x 0 0000 0003
        
        #10 a = 'hFFFFFFFF; b = 'hFFFFFFFF; c_in = 0;   // 0x 1 FFFF FFFE
        #10 a = 'hFFFFFFFF; b = 'hFFFFFFFF; c_in = 1;   // 0x 0 FFFF FFFF
        
        #10 a = 'h7FFF; b = 'h7FFF; c_in = 1;   // 0x 0 0000 FFFF
        #10 a = 'h7FFF; b = 'h8000; c_in = 1;   // 0x 0 0001 0000
        #10 $finish;
    end
endmodule
