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
    output reg_dst_sel,
    output reg_write,
    output alu_src_sel,
    output jump_src_sel,
    output [1:0] alu_op // ?
    );
    
    always @(opcode) begin
        case (opcode) // instruction[31:26]
            6'b100011: begin // lw (load word) I-format
                
            end
            6'b101011: begin // sw (store word) I-format
                
            end
            6'b000100: begin // beq (branch on equal) I-format
                
            end
            6'b000010: begin // j (jump) J-format
                
            end
            6'b000000: begin // SPECIAL (slt,and,or,add,sub,mul,muh,div,mod) R-format
                
            end
        endcase 
    end
endmodule
