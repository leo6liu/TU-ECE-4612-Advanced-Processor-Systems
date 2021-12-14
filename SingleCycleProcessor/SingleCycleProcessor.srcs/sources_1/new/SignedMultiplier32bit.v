`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignedMultiplier32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SignedMultiplier32bit(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out_hi,
    output reg [31:0] out_lo
    );
    
    integer i;
    
    reg [31:0] a_unsigned;
    reg [31:0] b_unsigned;
    reg [63:0] multiplicand;
    reg [31:0] multiplier;
    reg [63:0] product;
    
    always @ (a or b) begin
        // negate a if negative
        if (a[31] == 0'b1) begin
            a_unsigned = -a;
        end else begin
            a_unsigned = a;
        end
        
        // negate b if negative
        if (b[31] == 0'b1) begin
            b_unsigned = -b;
        end else begin
            b_unsigned = b;
        end
        
        multiplicand = {32'b0,a_unsigned};
        multiplier = b_unsigned;
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
        
        // negate product if only a or only b is negative
        if (a[31] ^ b[31] == 1'b1) begin
            product = -product;
        end
        
        out_hi = product[63:32];
        out_lo = product[31:0];
    end
endmodule
