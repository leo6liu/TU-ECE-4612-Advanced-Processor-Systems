`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: FullAdder_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module FullAdder_tb();

    reg     a,b,c_in;
    wire    sum,c_out;
    
    FullAdder   M1(.sum(sum),.c_out(c_out),.a(a),.b(b),.c_in(c_in));
    
    initial begin
        #10 a = 0; b = 0; c_in = 0;
        #10 a = 0; b = 0; c_in = 1;
        #10 a = 0; b = 1; c_in = 0;
        #10 a = 0; b = 1; c_in = 1;
        #10 a = 1; b = 0; c_in = 0;
        #10 a = 1; b = 0; c_in = 1;
        #10 a = 1; b = 1; c_in = 0;
        #10 a = 1; b = 1; c_in = 1;
        #10 $finish;
    end
endmodule
