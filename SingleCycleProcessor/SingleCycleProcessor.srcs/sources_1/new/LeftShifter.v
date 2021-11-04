`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: LeftShifter
// Project Name: SingleCycleProcessor
// Description: Left Shifts input by 2 bits
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module LeftShifter(
    input [31:0] in,
    output [31:0] out
    );
    
    //assign out = {in[29:0], 2'b00};
    assign out = in << 2;
endmodule
