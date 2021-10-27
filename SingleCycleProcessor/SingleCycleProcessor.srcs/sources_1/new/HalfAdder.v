`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: HalfAdder
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module HalfAdder(
    input a,
    input b,
    output sum,
    output c_out
    );
    
    xor M1(sum, a, b);
    and M2(c_out, a, b);
endmodule
