`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Multiplier32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Multiplier32bit(
    input [31:0] a, // multiplicand
    input [31:0] b, // multiplier
    output reg [31:0] out_hi,
    output reg [31:0] out_lo
    );
    
    integer i;
    
    reg [63:0] multiplicand;
    reg [31:0] multiplier;
    reg [63:0] product;
    
    always @ (a or b) begin
        multiplicand = {32'b0,a};
        multiplier = b;
        product = 0;
        
        for (i = 0; i < 32; i = i + 1) begin
            // add multiplicand to product if multiplier[i] == 1
            if (multiplier[0] == 1'b1) begin
                product = product + multiplicand;
            end
            
            // shift multiplicand left 1 bit
            multiplicand = {multiplicand[63:0],1'b0};
            
            // shift multiplier right 1 bit
            multiplier = {1'b0,multiplier[31:1]};
        end
        
        out_hi = product[63:32];
        out_lo = product[31:0];
    end
endmodule
