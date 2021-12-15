`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignedSubtractor32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SignedSubtractor32bit(
    input [31:0] a,
    input [31:0] b,
    output [31:0] difference,
    output c_out,
    output overflow
    );
    
    wire [31:0] negated_b;
    
    assign negated_b = -b;
    
    SignedAdder32bit M1(.sum(difference),.c_out(c_out),.overflow(overflow),.a(a),.b(negated_b),.c_in(1'b0));
endmodule
