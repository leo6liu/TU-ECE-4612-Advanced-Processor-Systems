`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 06:23:12 PM
// Design Name: 
// Module Name: HalfAdder_tb
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


module HalfAdder_tb();

    reg     a,b;
    wire    sum,c_out;
    
    HalfAdder   M1(.sum(sum),.c_out(c_out),.a(a),.b(b));
    
    initial
        begin
            #10 a = 0; b = 0;   // 0b 0 0
            #10 a = 0; b = 1;   // 0b 0 1
            #10 a = 1; b = 0;   // 0b 0 1
            #10 a = 1; b = 1;   // 0b 1 0
            #10 $finish;
        end
endmodule
