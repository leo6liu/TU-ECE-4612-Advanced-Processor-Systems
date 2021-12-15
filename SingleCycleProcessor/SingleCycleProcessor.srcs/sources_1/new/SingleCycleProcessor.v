`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Leo Battalora
// 
// Module Name: SingleCycleProcessor
// Project Name: SingleCycleProcessor
// Description: 
// 
// Dependencies: 
// 
//////////////////////////////////////////////////////////////////////////////////


module SingleCycleProcessor(
    input clk
    );
    
    wire [31:0] pc; // current address
    wire [31:0] pc_plus_4; // current address +4
    wire [31:0] instr_index_shifted; // low 28 bits of target address when jumping
    wire [31:0] pc_jump_addr; // new address calculated from jump
    wire [31:0] pc_branch_calc; // new address calculated if branch occurs
    wire [31:0] pc_branch_res; // new address selected from branch or normal +4
    wire [31:0] immediate_offset; // sign-extended branch offset
    wire [31:0] branch_offset_shifted; // sign-extended branch offset shifted
    wire [31:0] pc_next;
    wire [31:0] instruction;
    wire [31:0] rs_data; // source register 1
    wire [31:0] rt_data; // source register 2
    wire [31:0] rd_data; // destination register
    wire [4:0] write_reg; // destination register to write to
    wire reg_write;
    wire mem_write;
    wire reg_dst_sel;
    wire jump_src_sel;
    wire branch_src_sel;
    wire branch_src_sel_res;
    wire alu_zero; // output from ALU indicating a 0 result
    
    Control             M00();
    
    ProgramCounter      M01(.pc_next(pc_next),.pc_current(pc),.clk(clk));
    InstructionMemory   M02(.address(pc),.instruction(instruction));
    Adder32bit          M03(.a(pc),.b(32'd4),.c_in(1'b0),.sum(pc_plus_4));
    LeftShifter         M04(.in(instruction[25:0]),.out(instr_index_shifted));
    assign pc_jump_addr = {pc_plus_4[31:28],instr_index_shifted[27:0]};
    SignExtender        M05(.in(instruction[15:0]),.out(immediate_offset));
    LeftShifter         M06(.in(immediate_offset),.out(branch_offset_shifted));
    Adder32bit          M07(.a(pc_plus_4),.b(branch_offset_shifted),.c_in(1'b0),.sum(pc_branch_calc));
    assign branch_src_sel_res = branch_src_sel & alu_zero;
    Mux2to1             M08(.a(pc_plus_4),.b(pc_branch_calc),.sel(branch_src_sel_res),.out(pc_branch_res));
    Mux2to1             M09(.a(pc_branch_res),.b(pc_jump_addr),.sel(jump_src_sel),.out(pc_next));
    
    Mux2to1 #(.WIDTH(5)) M10(.a(instruction[20:16]),.b(instruction[15:11]),.sel(reg_dst_sel),.out(write_reg));
    Registers           M11(.read_reg_1(instruction[25:21]),.read_reg_2(instruction[20:16]),
                            .read_data_1(rs_data),.read_data_2(rt_data),
                            .write_reg(write_reg),.write_data(rd_data),.reg_write(reg_write),
                            .clk(clk));
                            
    Mux2to1             M12();
    ALUControl          M13();
    ALU                 M14();
    
    DataMemory          M15();
    Mux2to1             M16();
endmodule
