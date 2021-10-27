`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder4bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder4bit(
    input [3:0] a,
    input [3:0] b,
    input c_in,
    output [3:0] sum,
    output c_out
    );
    
    wire c1,c2,c3;
    
    FullAdder M1(.sum(sum[0]),.c_out(c1),.a(a[0]),.b(b[0]),.c_in(c_in));
    FullAdder M2(.sum(sum[1]),.c_out(c2),.a(a[1]),.b(b[1]),.c_in(c1));
    FullAdder M3(.sum(sum[2]),.c_out(c3),.a(a[2]),.b(b[2]),.c_in(c2));
    FullAdder M4(.sum(sum[3]),.c_out(c_out),.a(a[3]),.b(b[3]),.c_in(c3));
endmodule
