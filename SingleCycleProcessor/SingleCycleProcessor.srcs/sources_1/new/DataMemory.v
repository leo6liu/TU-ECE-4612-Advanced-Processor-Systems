`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: DataMemory
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module DataMemory #(parameter WIDTH = 32, DEPTH = 1024) (
    input [WIDTH-1:0] address,
    input [WIDTH-1:0] write_data,
    output reg [WIDTH-1:0] read_data,
    input mem_write,
    input mem_read,
    input clk
    );
    
    // memory with 1024 locations [0:1023] (depth) each of 32 bits [31:0] (width).
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    
    // initialize memory to all 0's, then read data.txt
    initial begin : initialize_memory
        integer i;
        for (i = 0; i < DEPTH; i = i+1) begin
            memory[i] = 32'b0;
        end
        $readmemb("data.txt", memory);
    end
    
    // on each clock cycle, write write_data to address if mem_write is high
    always @(posedge clk) begin
        if (mem_write == 1) begin
            memory[address] = write_data;
        end
    end
    
    // on each clock cycle, read data from address to read_data
    always @(address) begin
        read_data <= memory[address];
    end
endmodule
