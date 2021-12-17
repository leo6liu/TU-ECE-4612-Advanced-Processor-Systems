`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: FloatAdder32bit_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module FloatAdder32bit_tb();

    reg [31:0] a,b;
    wire [31:0] result;
    
    FloatAdder32bit M01(.a(a),.b(b),.result(result));
    
    initial begin
        a = 32'h40700000; b = 32'h40a40000; #10 // a = 3.75, b = 5.125, result = 8.875      = 0x410e0000
        a = 32'h40700000; b = 32'hc0a40000; #10 // a = 3.75, b = -5.125, result = -1.375    = 0xbfb00000
        a = 32'hc0a40000; b = 32'hc0a40000; #10 // a = -5.125, b = -5.125, result = -10.25  = 0xc1240000
        a = 32'h40700000; b = 32'h00000000; #10 // a = 3.75, b = 0, result = 3.75           = 0x40700000
        a = 32'h4048f5c3; b = 32'h40c8f5c3; #10 // a = 3.14, b = 6.28, result = 9.42        = 0x4116b852
        a = 32'h7f800000; b = 32'hff800000; #10 // a = +inf, b = -inf, result = NaN         = 0x7f800001
        a = 32'h7f800000; b = 32'h00000000; #10 // a = +inf, b = 0, result = +inf           = 0x7f800000
        a = 32'h7f800001; b = 32'h00000000; #10 // a = NaN,  b = 0, result = NaN            = 0x7f800001
        $finish;
    end
endmodule
