`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2021 05:50:52 AM
// Design Name: 
// Module Name: SingleCycleProcessor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SingleCycleProcessor_tb();

    reg clk;
    
    SingleCycleProcessor M01(.clk(clk));
    
    initial begin
        clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        clk = 1; #10 clk = 0; #10
        $finish;
    end
endmodule
