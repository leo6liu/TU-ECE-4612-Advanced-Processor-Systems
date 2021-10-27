`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: FullAdder
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module FullAdder(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out
    );
    
    wire    w1,w2,w3;
    
    HalfAdder   M1(.sum(w1),.c_out(w2),.a(a),.b(b));
    HalfAdder   M2(.sum(sum),.c_out(w3),.a(w1),.b(c_in));
    or          M3(c_out,w2,w3);
endmodule
