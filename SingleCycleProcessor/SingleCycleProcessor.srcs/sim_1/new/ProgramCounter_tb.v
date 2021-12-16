`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ProgramCounter_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter_tb();

    reg [31:0] pc_next;
    wire [31:0] pc_current;
    reg clk;
    
    ProgramCounter  M01(.pc_next(pc_next),.pc_current(pc_current),.clk(clk));
    
    initial begin
        clk = 0; #10 pc_next = 2; #10
        clk = 1; #10 clk = 0; pc_next = 3; #10
        clk = 1; #10 clk = 0; pc_next = 4; #10
        $finish;
    end
endmodule
