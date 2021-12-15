`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Registers
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Registers(
    input [4:0] read_reg_1,
    input [4:0] read_reg_2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input clk,
    input reg_write,
    output [31:0] read_data_1,
    output [31:0] read_data_2
    );
    
    // register space with 32 locations [0:31] (depth) each of 32 bits [31:0] (width)
    reg [31:0] registers [0:31];
    
    // initialize registers to all 0's
    initial begin : initialize_registers
    integer i;
        for (i = 0; i < 32; i = i+1) begin
            registers[i] = 32'b0;
        end
    end
    
    // on each clock cycle, write write_data to write_reg if reg_write is high
    always @(posedge clk) begin
        if (reg_write == 1) begin
            registers[write_reg] = write_data;
        end
    end
    
    assign read_data_1 = registers[read_reg_1];
    assign read_data_2 = registers[read_reg_2];
endmodule
