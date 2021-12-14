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
    input [31:0] a, // dividend
    input [31:0] b, // divisor
    output reg [31:0] out_q, // quotient
    output reg [31:0] out_r // remainder
    );
    
    integer i;
    
    //reg [31:0] dividend;
    reg [63:0] divisor;
    reg [31:0] quotient;
    reg [63:0] remainder;
    
    always @ (a or b) begin
        //dividend = a;
        divisor = {b,32'b0};
        quotient = 0;
        remainder = {32'b0,a};
        
        for (i = 0; i < 33; i = i + 1) begin
            // subtrtact divisor from remainder
            remainder = remainder - divisor;
            
            // check if remainder is >= 0
            if (remainder[63] != 1'b1) begin
                // shift quotient left, setting new rightmost bit to 1
                quotient = {quotient[30:0],1'b1};
            end else begin
                // restore remainder by adding divisor back
                remainder = remainder + divisor;
                // shift quotient left, setting new rightmost bit to 0
                quotient = {quotient[30:0],1'b0};
            end
            
            // shift divisor right
            divisor = {1'b0,divisor[63:1]};
        end
        
        out_q = quotient;
        out_r = remainder[31:0];
    end
endmodule
