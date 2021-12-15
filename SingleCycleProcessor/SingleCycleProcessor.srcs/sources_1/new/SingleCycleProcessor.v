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
    wire [31:0] pc_plus_1; // current address +4
    wire [31:0] instr_index_shifted; // low 28 bits of target address when jumping
    wire [31:0] pc_jump_addr; // new address calculated from jump
    wire [31:0] pc_branch_calc; // new address calculated if branch occurs
    wire [31:0] pc_branch_res; // new address selected from branch or normal +4
    wire [31:0] immediate; // sign-extended branch offset
    wire [31:0] branch_offset_shifted; // sign-extended branch offset shifted
    wire [31:0] pc_next; // input of ProgramCounter
    wire [31:0] instruction; // output of InstructionMemory
    wire [31:0] rs_data; // source register 1 (alu_input_1)
    wire [31:0] rt_data; // source register 2
    wire [31:0] alu_input_2; // either rt_data or immediate
    wire [31:0] rd_data; // destination register
    wire [31:0] alu_result; // output of ALU
    wire [31:0] mem_read_data; // output of DataMemory
    wire [4:0] write_reg; // destination register to write to
    wire [3:0] alu_ctl; // output of ALUControl to dictate which operation ALU performs
    wire [1:0] alu_op; // output of Control to dictate ALUControl operation selectron
    wire reg_dst_sel; // output of Control
    wire jump_src_sel; // output of Control
    wire branch_src_sel; // output of Control
    wire alu_src_sel; // output of Control
    wire mem_to_reg_sel; // output of Control
    wire reg_write; // output of Control
    wire mem_read; // output of Control
    wire mem_write; // output of Control
    wire branch_src_sel_res; // output from AND of branch_src_sel and alu_zero
    wire alu_zero; // output from ALU indicating a 0 result
    
    Control             M00(.opcode(instruction[31:26]),.alu_op(alu_op),.reg_dst_sel(reg_dst_sel),
                            .jump_src_sel(jump_src_sel),.branch_src_sel(branch_src_sel),
                            .alu_src_sel(alu_src_sel),.mem_to_reg_sel(mem_to_reg_sel),
                            .reg_write(reg_write),.mem_read(mem_read),.mem_write(mem_write));
    
    ProgramCounter      M01(.pc_next(pc_next),.pc_current(pc),.clk(clk));
    InstructionMemory   M02(.address(pc),.instruction(instruction));
    Adder32bit          M03(.a(pc),.b(32'd1),.c_in(1'b0),.sum(pc_plus_1));
    LeftShifter         M04(.in(instruction[25:0]),.out(instr_index_shifted));
    assign pc_jump_addr = {pc_plus_1[31:28],instr_index_shifted[27:0]};
    SignExtender        M05(.in(instruction[15:0]),.out(immediate));
    LeftShifter         M06(.in(immediate),.out(branch_offset_shifted));
    Adder32bit          M07(.a(pc_plus_1),.b(branch_offset_shifted),.c_in(1'b0),.sum(pc_branch_calc));
    assign branch_src_sel_res = branch_src_sel & alu_zero;
    Mux2to1             M08(.a(pc_plus_1),.b(pc_branch_calc),.sel(branch_src_sel_res),.out(pc_branch_res));
    Mux2to1             M09(.a(pc_branch_res),.b(pc_jump_addr),.sel(jump_src_sel),.out(pc_next));
    
    Mux2to1 #(.WIDTH(5)) M10(.a(instruction[20:16]),.b(instruction[15:11]),.sel(reg_dst_sel),.out(write_reg));
    Registers           M11(.read_reg_1(instruction[25:21]),.read_reg_2(instruction[20:16]),
                            .read_data_1(rs_data),.read_data_2(rt_data),
                            .write_reg(write_reg),.write_data(rd_data),.reg_write(reg_write),
                            .clk(clk));
                            
    Mux2to1             M12(.a(rt_data),.b(immediate),.sel(alu_src_sel),.out(alu_input_2));
    ALUControl          M13(.alu_op(alu_op),.shamt(instruction[10:6]),.func_code(instruction[5:0]),.alu_ctl(alu_ctl));
    ALU                 M14(.a(rs_data),.b(alu_input_2),.ctl(alu_ctl),.result(alu_result),.zero(alu_zero));
    
    DataMemory          M15(.address(alu_result),.mem_write(mem_write),.mem_read(mem_read),
                            .write_data(rt_data),.read_data(mem_read_data),.clk(clk));
    Mux2to1             M16(.a(alu_result),.b(mem_read_data),.sel(mem_to_reg_sel),.out(rd_data));
endmodule
