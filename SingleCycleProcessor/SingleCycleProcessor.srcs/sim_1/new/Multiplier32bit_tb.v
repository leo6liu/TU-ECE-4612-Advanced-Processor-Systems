`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Multiplier32bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplier32bit_tb();

    reg[31:0]   a,b;
    wire[63:0]  product;
    
    Multiplier32bit    M1(.a(a),.b(b),.out_hi(product[63:32]),.out_lo(product[31:0]));
    
    initial begin
        a = 1; b = 1; #10 // 1 * 1 = 1                                              = 0x 00000000 00000001
        a = 1; b = 1000; #10 // 1 * 1000 = 1000                                     = 0x 00000000 000003e8
        a = 8; b = 3; #10 // 8 * 3 = 24                                             = 0x 00000000 00000018
        a = 34952; b = 2882400000; #10 // 34952 * 2882400000 = 100,745,644,800,000  = 0x 00005BA0 AC5EF800
        a = 999; b = 0; #10 // 999 * 0 = 0                                          = 0x 00000000 00000000
        a = -3; b = 7; #10 // -3 * 7 = -21                                          = 0x FFFFFFFF FFFFFFEB (will not work as expected)
        $finish;
    end
endmodule
