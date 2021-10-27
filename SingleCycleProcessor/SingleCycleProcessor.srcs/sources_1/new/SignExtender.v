`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SignExtender
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////

module SignExtender(
    input [15:0] in,
    output [31:0] out
    );
    
    assign out = {{16{in[15]}}, in};
endmodule
