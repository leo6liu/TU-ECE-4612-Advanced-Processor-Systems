`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Divider32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Divider32bit(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out_q,
    output reg [31:0] out_r
    );
    
    integer i;
    
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg [31:0] quotient;
    reg [31:0] remainder;
    
    always @ (a or b) begin
        dividend = a;
        divisor = b;
        quotient = 0;
        remainder = 0;
        
        for (i = 0; i < 32; i = i + 1) begin
            //if (multiplier[0] == 1'b1) begin
            //    product = product + multiplicand;
            //end
            
            // shift multiplicand left 1 bit
            //multiplicand = {multiplicand[63:0],1'b0};
            
            // shift multiplier right 1 bit
            //multiplier = {1'b0,multiplier[31:1]};
        end
        
        out_q = quotient;
        out_r = remainder;
    end
endmodule
