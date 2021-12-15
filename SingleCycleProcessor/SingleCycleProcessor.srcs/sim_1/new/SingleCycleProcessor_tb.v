`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SingleCycleProcessor_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SingleCycleProcessor_tb();

    reg clk;
    
    SingleCycleProcessor M01(.clk(clk));
    
    initial begin : clock_gen
        integer cycles, i;
        
        // set number of cycles to run (safe: instructions + 1)
        cycles = 15;
        
        // first clock cycle
        clk = 0; #20
        cycles = cycles - 1;
        
        // remaining clock cycles
        for (i = 0; i < cycles; i = i + 1) begin
            clk = 1; #10;
            clk = 0; #10;
        end
        $finish;
    end
endmodule
