`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ALU_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU_tb();

    reg [3:0] ctl;
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] result;
    wire zero;
    
    ALU M1(.ctl(ctl),.a(a),.b(b),.result(result),.zero(zero));
    
    initial begin
        ctl = 4'b0010; a = 3; b = 2; #10 // 5
        ctl = 4'b0011; a = 5; b = 5; #10 // 0
        ctl = 4'b0100; a = -3; b = 7; #10 // -27
        $finish;
    end
endmodule
