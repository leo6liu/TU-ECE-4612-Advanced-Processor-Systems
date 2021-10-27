`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignExtender_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module SignExtender_tb();

    reg[15:0]   in;
    wire[31:0]  out;
    
    SignExtender M1(.out(out),.in(in));
    
    initial begin
        #10 in = 'h00FF;     // 0x 0000 00FF
        #10 in = 'hF0FF;     // 0x FFFF F0FF
        #10 $finish;
    end
endmodule
