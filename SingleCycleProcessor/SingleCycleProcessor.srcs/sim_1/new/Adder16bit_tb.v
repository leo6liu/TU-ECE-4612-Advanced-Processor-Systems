`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder16bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder16bit_tb();

    reg[15:0]   a,b;
    reg         c_in;
    wire[15:0]  sum;
    wire        c_out;
    
    Adder16bit   M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in));
    
    initial begin
        #10 a = 0; b = 0; c_in = 0;     // 0x 0 0000
        #10 a = 0; b = 0; c_in = 1;     // 0x 0 0001
        #10 a = 0; b = 2; c_in = 0;     // 0x 0 0002
        #10 a = 0; b = 2; c_in = 1;     // 0x 0 0003
        
        #10 a = 'hFFFF; b = 'hFFFF; c_in = 0;   // 0x 1 FFFE
        #10 a = 'hFFFF; b = 'hFFFF; c_in = 1;   // 0x 1 FFFF
        
        #10 a = 'h7FFF; b = 'h7FFF; c_in = 1;   // 0x 0 FFFF
        #10 a = 'h7FFF; b = 'h8000; c_in = 1;   // 0x 1 0000
        #10 $finish;
    end
endmodule
