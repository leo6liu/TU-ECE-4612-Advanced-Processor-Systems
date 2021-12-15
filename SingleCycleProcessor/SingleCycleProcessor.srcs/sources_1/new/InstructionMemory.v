`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: InstructionMemory
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionMemory #(parameter WIDTH = 32, DEPTH = 1024) (
    input [31:0] address,
    output [31:0] instruction
    );
    
    // memory with 1024 locations [0:1023] (depth) each of 32 bits [31:0] (width).
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // initialize memory to all 0's, then read program.txt
    initial begin : initialize_memory
        integer i;
        for (i = 0; i < DEPTH; i = i+1) begin
            memory[i] = 32'b0;
        end
        $readmemb("program.txt", memory);
    end
    
    // output the instruction corresponding to the requested address
    assign instruction = memory[address];
endmodule
