`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ProgramCounter
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(
    input [31:0] pc_next,
    output reg [31:0] pc_current,
    input clk
    );
    
    initial begin
        pc_current <= 32'h00000000;
    end
    
    always @(posedge clk) begin
        pc_current <= pc_current;//pc_next;
    end
endmodule
