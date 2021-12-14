`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Divider32bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Divider32bit_tb();

    reg [31:0]  a,b;
    wire[31:0]  quotient;
    wire[31:0]  remainder;
    
    Divider32bit    M1(.a(a),.b(b),.out_q(quotient),.out_r(remainder));
    
    initial begin
        a = 1; b = 1; #10 // 1 / 1 = 1 R 0              = 0x00000001 R 0x00000000
        a = 1; b = 10; #10 // 1 / 10 = 0 R 1            = 0x00000000 R 0x00000001
        a = 8; b = 3; #10 // 8 / 3 = 2 R 2              = 0x00000002 R 0x00000002
        a = 'heeaaaa; b = 'hdd; #10 // 0xEEAAAA / 0xDD  = 0x00011476 R 0x000000CC
        a = 999; b = 0; #10 // 999 / 0 = ???            = 0xFFFFFFFF R 0x000003E7 (undefined behavior)
        a = 21; b = -3; #10 // 21 / -3 = -7             = 0xFFFFFFF9 R 0x00000000 (will not work as expected)
        $finish;
    end
endmodule
