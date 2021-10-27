`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder16bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder16bit(
    input [15:0] a,
    input [15:0] b,
    input c_in,
    output [15:0] sum,
    output c_out
    );
    
    wire c1,c2,c3;
    
    Adder4bit M1(.sum(sum[3:0]),.c_out(c1),.a(a[3:0]),.b(b[3:0]),.c_in(c_in));
    Adder4bit M2(.sum(sum[7:4]),.c_out(c2),.a(a[7:4]),.b(b[7:4]),.c_in(c1));
    Adder4bit M3(.sum(sum[11:8]),.c_out(c3),.a(a[11:8]),.b(b[11:8]),.c_in(c2));
    Adder4bit M4(.sum(sum[15:12]),.c_out(c_out),.a(a[15:12]),.b(b[15:12]),.c_in(c3));
endmodule
