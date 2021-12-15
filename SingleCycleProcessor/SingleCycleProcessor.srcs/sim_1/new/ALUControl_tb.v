`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ALUControl_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUControl_tb();

    reg [1:0] alu_op;
    reg [4:0] shamt;
    reg [5:0] func_code;
    wire [3:0] alu_ctl;

    ALUControl  M1(.alu_op(alu_op),.shamt(shamt),.func_code(func_code),.alu_ctl(alu_ctl));
    
    initial begin
        alu_op = 2'b00; #10                         // 4'b0010 lw,sw (add)
        alu_op = 2'b01; #10                         // 4'b0011 beq (sub)
        alu_op = 2'b10; func_code = 6'b101010; #10  // 4'b1000 slt
        alu_op = 2'b10; func_code = 6'b100100; #10  // 4'b0000 and
        alu_op = 2'b10; func_code = 6'b100101; #10  // 4'b0001 or
        alu_op = 2'b10; func_code = 6'b100000; #10  // 4'b0010 add
        alu_op = 2'b10; func_code = 6'b100010; #10  // 4'b0011 sub
        alu_op = 2'b10; func_code = 6'b011000; shamt = 5'b00010; #10 // 4'b0100 mul
        alu_op = 2'b10; func_code = 6'b011000; shamt = 5'b00011; #10 // 4'b0101 muh
        alu_op = 2'b10; func_code = 6'b011010; shamt = 5'b00010; #10 // 4'b0110 div
        alu_op = 2'b10; func_code = 6'b011010; shamt = 5'b00011; #10 // 4'b0111 mod
        $finish;
    end
endmodule
