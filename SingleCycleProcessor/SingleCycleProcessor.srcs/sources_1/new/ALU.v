`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ALU
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input [3:0] ctl,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result,
    output zero
    );
    
    wire [31:0] res_and;
    wire [31:0] res_or;
    wire [31:0] res_slt;
    wire [31:0] res_add; // sum
    wire [31:0] res_sub; // difference
    wire [31:0] res_mul; // product low
    wire [31:0] res_muh; // product high
    wire [31:0] res_div; // quotient
    wire [31:0] res_mod; // remainder (modulo)
    
    // zero is true if result is 0
    assign zero = (result == 0);
    
    assign res_and = a & b;
    assign res_or = a | b;
    assign res_slt = (a < b) ? 1 : 0;
    SignedAdder32bit        M1(.a(a),.b(b),.c_in(1'b0),.sum(res_addition));
    SignedSubtractor32bit   M2(.a(a),.b(b),.difference(res_subtraction));
    SignedMultiplier32bit   M3(.a(a),.b(b),.out_hi(res_muh),.out_lo(res_mul));
    SignedDivider32bit      M4(.a(a),.b(b),.out_q(res_div),.out_r(res_mod));

    always @(ctl, a, b) begin
        case (ctl)
            4'b0000: result <= res_and;
            4'b0001: result <= res_or;
            4'b0010: result <= res_add;
            4'b0011: result <= res_sub;
            4'b0100: result <= res_mul;
            4'b0101: result <= res_muh;
            4'b0110: result <= res_div;
            4'b0111: result <= res_mod;
            4'b1000: result <= res_slt;
        endcase
    end
endmodule
