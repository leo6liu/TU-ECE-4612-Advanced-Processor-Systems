`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: ALUControl
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module ALUControl(
    input [1:0] alu_op,     // ?
    input [4:0] shamt,      // instruction[10:6]
    input [5:0] func_code,  // instruction[5:0]
    output reg [3:0] alu_ctl
    );
    
    always @(alu_op or func_code) begin
        case (alu_op)
            2'b00: alu_ctl <= 4'b0010; // lw,sw (add)
            2'b01: alu_ctl <= 4'b0011; // beq (sub)
            2'b10: begin // R-type
                case (func_code) // instruction[5:0]
                    6'b101010: alu_ctl <= 4'b1000; // slt
                    6'b100100: alu_ctl <= 4'b0000; // and
                    6'b100101: alu_ctl <= 4'b0001; // or
                    6'b100000: alu_ctl <= 4'b0010; // add
                    6'b100010: alu_ctl <= 4'b0011; // sub
                    6'b011000: alu_ctl <= (shamt == 5'b00010) ? 4'b0100 : 4'b0101; // mul shamt = 00010, muh shamt = 00011
                    6'b011010: alu_ctl <= (shamt == 5'b00010) ? 4'b0110 : 4'b0111; // div shamt = 00010, mod shamt = 00011
                endcase
            end
        endcase
    
        
    end
endmodule
