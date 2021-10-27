`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Adder32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder32bit(
    input [31:0] a,
    input [31:0] b,
    input c_in,
    output [31:0] sum,
    output c_out
    );
    
    wire c1;
    
    Adder16bit M1(.sum(sum[15:0]),.c_out(c1),.a(a[15:0]),.b(b[15:0]),.c_in(c_in));
    Adder16bit M2(.sum(sum[31:16]),.c_out(c_out),.a(a[31:16]),.b(b[31:16]),.c_in(c1));
endmodule
