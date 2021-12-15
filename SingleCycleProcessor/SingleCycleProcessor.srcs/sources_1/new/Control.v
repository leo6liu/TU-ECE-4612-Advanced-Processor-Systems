`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: Control
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module Control(
    input [5:0] opcode, // instruction[31:26]
    output reg [1:0] alu_op,
    output reg reg_dst_sel,
    output reg jump_src_sel,
    output reg branch_src_sel,
    output reg alu_src_sel,
    output reg mem_to_reg_sel, // determines if data written to register comes from memory or ALU
    output reg reg_write,
    output reg mem_read,
    output reg mem_write
    );
    
    always @(opcode) begin
        case (opcode) // instruction[31:26]
            6'b100011: begin // lw (load word) I-format
                alu_op <= 2'b00;
                reg_dst_sel <= 1'b0;
                jump_src_sel <= 1'b0;
                branch_src_sel <= 1'b0;
                alu_src_sel <= 1'b1;
                mem_to_reg_sel <= 1'b1;
                reg_write <= 1'b1;
                mem_read <= 1'b1;
                mem_write <= 1'b0;
            end
            6'b101011: begin // sw (store word) I-format
                alu_op <= 2'b00;
                reg_dst_sel <= 1'bx;
                jump_src_sel <= 1'b0;
                branch_src_sel <= 1'b0;
                alu_src_sel <= 1'b1;
                mem_to_reg_sel <= 1'bx;
                reg_write <= 1'b0;
                mem_read <= 1'b0;
                mem_write <= 1'b1;
            end
            6'b000100: begin // beq (branch on equal) I-format
                alu_op <= 2'b01;
                reg_dst_sel <= 1'bx;
                jump_src_sel <= 1'b0;
                branch_src_sel <= 1'b1;
                alu_src_sel <= 1'b0;
                mem_to_reg_sel <= 1'bx;
                reg_write <= 1'b0;
                mem_read <= 1'b0;
                mem_write <= 1'b0;
            end
            6'b000010: begin // j (jump) J-format
                alu_op <= 2'bxx; // doesn't use ALU
                reg_dst_sel <= 1'bx;
                jump_src_sel <= 1'b1;
                branch_src_sel <= 1'b0;
                alu_src_sel <= 1'b0;
                mem_to_reg_sel <= 1'bx;
                reg_write <= 1'b0;
                mem_read <= 1'b0;
                mem_write <= 1'b0;
            end
            6'b000000: begin // SPECIAL (slt,and,or,add,sub,mul,muh,div,mod) R-format
                alu_op <= 2'b10;
                reg_dst_sel <= 1'b1;
                jump_src_sel <= 0;
                branch_src_sel <= 0;
                alu_src_sel <= 0;
                mem_to_reg_sel <= 1'b0;
                reg_write <= 1'b1;
                mem_read <= 1'b0;
                mem_write <= 1'b0;
            end
        endcase 
    end
endmodule
