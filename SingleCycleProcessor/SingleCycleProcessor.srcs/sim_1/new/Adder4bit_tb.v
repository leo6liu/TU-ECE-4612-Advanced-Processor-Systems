`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder4bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder4bit_tb();

    reg[3:0]    a,b;
    reg         c_in;
    wire[3:0]   sum;
    wire        c_out;
    
    Adder4bit   M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in));
    
    initial begin
        #10 a = 0; b = 0; c_in = 0;     // 0b 0 0000
        #10 a = 0; b = 0; c_in = 1;     // 0b 0 0001
        #10 a = 0; b = 1; c_in = 0;     // 0b 0 0001
        #10 a = 0; b = 1; c_in = 1;     // 0b 0 0010
        #10 a = 0; b = 2; c_in = 0;     // 0b 0 0010
        #10 a = 0; b = 2; c_in = 1;     // 0b 0 0011
        
        #10 a = 15; b = 15; c_in = 0;   // 0b 1 1110
        #10 a = 15; b = 15; c_in = 1;   // 0b 1 1111
        
        #10 a = 7; b = 7; c_in = 1;     // 0b 0 1111
        #10 a = 7; b = 8; c_in = 1;     // 0b 1 0000
        #10 a = 5; b = 5; c_in = 1;     // 0b 0 1011
        #10 $finish;
    end
endmodule
