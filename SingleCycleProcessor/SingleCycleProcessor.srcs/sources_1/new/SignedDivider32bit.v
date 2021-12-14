`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignedDivider32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SignedDivider32bit(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out_q,
    output reg [31:0] out_r
    );
    
    integer i;
    
    reg [31:0] a_unsigned;
    reg [31:0] b_unsigned;
    reg [63:0] divisor;
    reg [31:0] quotient;
    reg [63:0] remainder;
    
    always @ (a or b) begin
        // negate a if negative
        if (a[31] == 1'b1) begin
            a_unsigned = -a;
        end else begin
            a_unsigned = a;
        end
        
        // negate b if negative
        if (b[31] == 1'b1) begin
            b_unsigned = -b;
        end else begin
            b_unsigned = b;
        end
    
        divisor = {b_unsigned,32'b0};
        quotient = 0;
        remainder = {32'b0,a_unsigned};
        
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
        
        // negate quotient if only a or only b is negative
        if (a[31] ^ b[31] == 1'b1) begin
            quotient = -quotient;
        end
        
        // negate remainder if divident is negative
        if (a[31] == 1'b1) begin
            remainder = -remainder;
        end
        
        out_q = quotient;
        out_r = remainder[31:0];
    end
endmodule
