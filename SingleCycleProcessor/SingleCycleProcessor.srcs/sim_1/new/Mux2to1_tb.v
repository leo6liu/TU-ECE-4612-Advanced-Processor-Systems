`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Mux2to1_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Mux2to1_tb();

    reg[31:0]   a,b;
    reg         sel;
    wire[31:0]  out;
    
    Mux2to1 M1(.out(out),.a(a),.b(b),.sel(sel));
    
    initial begin
        #10 a = 'hFFFFFFFF; b = 'h00000000; sel = 'b0;     // 0x FFFF FFFF
        #10 a = 'hFFFFFFFF; b = 'h00000000; sel = 'b1;     // 0x 0000 0000
        #10 $finish;
    end
endmodule
