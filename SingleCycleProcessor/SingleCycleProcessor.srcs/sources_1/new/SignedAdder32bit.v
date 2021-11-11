`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignedAdder32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SignedAdder32bit(
    input [31:0] a,
    input [31:0] b,
    input c_in,
    output [31:0] sum,
    output c_out,
    output overflow
    );
    
    Adder32bit M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in));
    
    // rules for detecting overflow:
    //   - If the sum of two positive numbers yields a negative result, the sum has overflowed.
    //   - If the sum of two negative numbers yields a positive result, the sum has overflowed.
    //   - Otherwise, the sum has not overflowed. 
    assign overflow = ((a[31] == 0 && b[31] == 0 && sum[31] == 1) || 
                       (a[31] == 1 && b[31] == 1 && sum[31] == 0)) ? 1 : 0;
endmodule
