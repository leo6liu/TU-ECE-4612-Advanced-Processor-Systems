`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Control_tb
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Control_tb();

    reg [5:0] opcode;
    wire [1:0] alu_op;
    wire reg_dst_sel;
    wire jump_src_sel;
    wire branch_src_sel;
    wire alu_src_sel;
    wire mem_to_reg_sel;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    
    Control M01(.opcode(opcode),.alu_op(alu_op),.reg_dst_sel(reg_dst_sel),
                .jump_src_sel(jump_src_sel),.branch_src_sel(branch_src_sel),
                .alu_src_sel(alu_src_sel),.mem_to_reg_sel(mem_to_reg_sel),
                .reg_write(reg_write),.mem_read(mem_read),.mem_write(mem_write));
                
    initial begin
        opcode = 6'b100011; #10 // lw (load word) I-format
        opcode = 6'b101011; #10 // sw (store word) I-format
        opcode = 6'b000100; #10 // beq (branch on equal) I-format
        opcode = 6'b000010; #10 // j (jump) J-format
        opcode = 6'b000000; #10 // SPECIAL (slt,and,or,add,sub,mul,muh,div,mod) R-format
        $finish;
    end
endmodule
