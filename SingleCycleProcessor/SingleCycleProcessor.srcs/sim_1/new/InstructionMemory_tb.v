`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: InstructionMemory_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory_tb();

    reg [31:0] address;
    wire [31:0] instruction;
    
    InstructionMemory M1(.address(address), .instruction(instruction));
    
    initial begin
        #10 address = 0;
        #10 address = 1;
        #10 address = 2;
        #10 address = 3;
        #10 address = 4;
        #10 $finish;
    end
endmodule
