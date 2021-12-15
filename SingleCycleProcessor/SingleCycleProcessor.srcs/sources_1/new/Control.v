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
    output reg_dst_sel,
    output jump_src_sel,
    output branch_src_sel,
    output alu_src_sel,
    output mem_to_reg_sel, // determines if data written to register comes from memory or ALU
    output reg_write,
    output mem_write
    );
    
    always @(opcode) begin
        case (opcode) // instruction[31:26]
            6'b100011: begin // lw (load word) I-format
                alu_op <= 2'b00;
            end
            6'b101011: begin // sw (store word) I-format
                alu_op <= 2'b00;
            end
            6'b000100: begin // beq (branch on equal) I-format
                alu_op <= 2'b01;
            end
            6'b000010: begin // j (jump) J-format
                alu_op <= 2'bxx; // doesn't use ALU
            end
            6'b000000: begin // SPECIAL (slt,and,or,add,sub,mul,muh,div,mod) R-format
                alu_op <= 2'b10;
            end
        endcase 
    end
endmodule
