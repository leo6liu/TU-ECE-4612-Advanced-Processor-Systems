`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignedAdder32bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SignedAdder32bit_tb();
    
    reg[31:0]   a,b;
    reg         c_in;
    wire[31:0]  sum;
    wire        c_out;
    wire        overflow;
    
    SignedAdder32bit    M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in),.overflow(overflow));
    
    initial begin
        // signed 32-bit integer range: [-2147483648 to 2147483647]
        
        // addition of two positives or two negatives which do not overflow.
        #10 a = 1; b = 1; c_in = 0;     // sum =  2, overflow = 0, c_out = 0;
        #10 a = -1; b = -1; c_in = 0;   // sum = -2, overflow = 0, c_out = 0;
        
        // addition of two positives which result in a negative. overflow occurs.
        #10 a = 2147483647; b = 1; c_in = 0;   // sum = -2147483648, overflow = 1, c_out = 0;
        
        // addition of two negatives which result in a positive. overflow occurs.
        #10 a = -2147483648; b = -1; c_in = 0;   // sum = 2147483647, overflow = 1, c_out = 1;
        #10 $finish;
    end
endmodule
