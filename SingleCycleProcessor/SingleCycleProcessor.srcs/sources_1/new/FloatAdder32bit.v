`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: FloatAdder32bit
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module FloatAdder32bit(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
    );
    
    reg sign_a, sign_b, sign_tmp; // 1 bit
    reg [7:0] exponent_a, exponent_b, exponent_tmp; // 8 bits
    reg [31:0] mantissa_a, mantissa_b, mantissa_tmp; // 23 bits
    integer exp_diff; // absolute exponent difference
    integer i; // sentinal counter for control loops
    
    always @(a, b, result) begin
        // extract sign, exponent, mantissa from a and b
        sign_a = a[31];
        exponent_a = a[30:23];
        mantissa_a = {9'b1,a[22:0]}; // insert implicit 1
        sign_b = b[31];
        exponent_b = b[30:23];
        mantissa_b = {9'b1,b[22:0]}; // insert implicit 1
    
        // if a is NaN, result is NaN  (output signalling NaN)
        if (exponent_a == 8'hFF && a[22:0] != 0)
            result <= 32'h7F800001;
        // if b is NaN, result is NaN  (output signalling NaN)
        else if (exponent_b == 8'hFF && b[22:0] != 0)
            result <= 32'h7F800001;
        // if a + b == inf + -inf, then result is NaN (output signalling NaN)
        else if (a == 32'h7F800000 && b == 32'hFF800000)
            result <= 32'h7F800001;
        // if a + b == -inf + inf, then result is NaN (output signalling NaN)
        else if (a == 32'hFF800000 && b == 32'h7F800000)
            result <= 32'h7F800001;
        // if only a is +-inf (or b is inf of the same sign), then result is a
        else if (a == 32'hFF800000 || a == 32'h7F800000)
            result <= a;
        // if only b is +-inf (or a is inf of the same sign), then result is b
        else if (a == 32'hFF800000 || a == 32'h7F800000)
            result <= b;
        // else perform normal float32 addition
        else begin
            // calculate exponent difference
            exp_diff = exponent_a - exponent_b;
            
            // if a has smaller exponent, swap a and b so that a is always larger;
            if (exp_diff < 0) begin
                sign_tmp = sign_a; exponent_tmp = exponent_a; mantissa_tmp = mantissa_a;
                sign_a = sign_b; exponent_a = exponent_b; mantissa_a = mantissa_b;
                sign_b = sign_tmp; exponent_b = exponent_tmp; mantissa_b = mantissa_tmp;
                // negate exp_diff (as it is not positive)
                exp_diff = -exp_diff;
            end
            
            // shift b right exp_diff bits
            mantissa_b = mantissa_b >> exp_diff;
            
            // if a is negative, negate its mantissa using 2's complement
            if (sign_a == 1)
                mantissa_a = -mantissa_a;
            
            // if b is negative, negate its mantissa using 2's complement
            if (sign_b == 1)
                mantissa_b = -mantissa_b;
                
            // add mantissas (storing in mantissa_a)
            mantissa_a = mantissa_a + mantissa_b;
            
            // if mantissa is positive, set sign_a to 0
            if (mantissa_a[31] == 0)
                sign_a = 0;
            // else, set sign_a to 1 and negate mantissa using 2's complement
            else begin
                sign_a = 1;
                mantissa_a = -mantissa_a;
            end
            
            // normalize mantissa (shift so first set bit is at index 23)
            for (i = 0; i < 32; i = i + 1) begin
                if (mantissa_a[31 - i] == 1) begin
                    if (8 - i > 0)
                        mantissa_a = mantissa_a >> (8 - i);
                    else
                        mantissa_a = mantissa_a << -1 * (8 - i);
                    exponent_a = exponent_a + (8 - i);
                    i = 32; // break loop
                end
            end
            
            // compose result, checking for over/underflow
            result <= {sign_a,exponent_a,mantissa_a[22:0]};
        end
    end
endmodule
