`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Mux2to1
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Mux2to1(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] out
    );
    
    // when sel == 0, out = a
    // when sel == 1, out = b
    assign out = sel ? b : a;
endmodule
