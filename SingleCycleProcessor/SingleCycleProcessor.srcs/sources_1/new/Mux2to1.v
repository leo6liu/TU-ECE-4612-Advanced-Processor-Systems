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

module Mux2to1 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input sel,
    output [WIDTH-1:0] out
    );
    
    // when sel == 0, out = a
    // when sel == 1, out = b
    assign out = sel ? b : a;
endmodule
