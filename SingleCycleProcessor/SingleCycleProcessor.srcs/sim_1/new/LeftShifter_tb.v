`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: LeftShifter_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module LeftShifter_tb();

    reg[31:0]   in;
    wire[31:0]  out;
    
    LeftShifter M1(.out(out),.in(in));
    
    initial begin
        #10 in = 32'b1111;     // 0b 1111 00
        #10 in = 32'b0000;     // 0x 0000 00
        #10 $finish;
    end
endmodule
