/******************************************************************************* 
 * Module   : friscv_top
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 24-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Top wrapper for friscv CPU. Contains all components and interfaces to
 * external memory and clock/reset.
 ******************************************************************************/

import friscv_pkg::*;

module friscv_top (
  input logic clk,
  input logic rst_n,
  
  // memory interface inputs
  input logic [ARCH-1:0] instr_in,
  input logic [ARCH-1:0] data_mem_in,
  // memory interface outputs
  output logic [ARCH-1:0] read_addr_out,
  output logic [ARCH-1:0] alu_result_out,
  output logic [ARCH-1:0] w_data_out,
  output logic mem_write_out,

  output logic [7-1:0] dbg_opcode_out,
  output logic [7-1:0] dbg_func7_out,
  output logic [3-1:0] dbg_func3_out
);

/* SIGNALS ********************************************************************/
  
  logic [ARCH-1:0] pc_incr_s, 
                   src_a_s, 
                   rd_2_s, 
                   src_b_s, 
                   alu_result_s, 
                   reg_write_data_s,
                   write_result_s;
  logic zero_s,
        pc_src_s,
        pc_src_decode_s,
        jump_src_s,
        reg_write_s,
        alu_src_s,
        auipc_s;
  logic [2-1:0] result_src_s;
  logic [4-1:0] alu_ctrl_s;
  logic [3-1:0] func3_s;
  logic [7-1:0] op_code_s,
                func7_s;                   
  logic [$clog2(REGFILE_DEPTH)-1:0] rs1_s, 
                                    rs2_s, 
                                    rd_s;
  logic signed [ARCH-1:0] imm_ext_s;

/* COMPONENTS *****************************************************************/
  
  assign dbg_opcode_out = op_code_s;
  assign dbg_func3_out  = func3_s;
  assign dbg_func7_out  = func7_s;
  assign alu_result_out = alu_result_s;

  // program counter
  pc i_pc (
    .clk(clk),
    .rst_n(rst_n),
    .auipc_in(auipc_s),
    .pc_src_in(pc_src_s),
    .imm_in(imm_ext_s),
    .pc_incr_out(pc_incr_s),
    .pc_out(read_addr_out)
  );
  
  // jump source mux
  mux_2_way #(
    .MUX_WIDTH(ARCH)
  ) i_jmp_src_mux (
    .sel_in(jump_src_s),
    .a_in(pc_src_decode_s),
    .b_in({alu_result_s[ARCH-1:1], 1'b0}), // sets LSB to 0 as per JALR in spec
    .val_out(pc_src_s)
  );
  
  // instruction decoder
  instr_decode i_instr_decode (
    .instr_in(instr_in),
    .op_code_out(op_code_s), 
    .func3_out(func3_s),
    .func7_out(func7_s),
    .rs1_out(rs1_s),
    .rs2_out(rs2_s),
    .rd_out(rd_s),
    .imm_out(imm_ext_s)
  );
  
  // main controller
  main_controller i_main_controller (
    .func3_in(func3_s),
    .func7_in(func7_s),
    .op_code_in(op_code_s),
    .zero_in(zero_s),
    .lt_in(alu_result_s[0]),
    .pc_src_out(pc_src_decode_s),
    .jump_src_out(jump_src_s),
    .reg_write_out(reg_write_s),
    .auipc_out(auipc_s),
    .alu_src_out(alu_src_s),
    .alu_ctrl_out(alu_ctrl_s),
    .mem_write_out(mem_write_out),
    .result_src_out(result_src_s)
  );

  // register file
  reg_file i_reg_file (
    .clk(clk),
    .we(reg_write_s),
    .addr_w(rd_s),
    .addr_r1(rs1_s),
    .addr_r2(rs2_s),
    .data_w(reg_write_data_s),
    .data_r1(src_a_s),
    .data_r2(rd_2_s)
  );

  // write data sign extender
  write_data_ext i_write_data_ext (
    .w_data_in(write_result_s),
    .rd_data_in(rd_2_s),
    .op_code_in(op_code_s),
    .func3_in(func3_s),
    .w_data_out(reg_write_data_s),
    .rd_data_out(w_data_out)
  );
  
  // ALU source mux
  mux_2_way #(
    .MUX_WIDTH(ARCH)
  ) i_alu_src_mux (
    .sel_in(alu_src_s),
    .a_in(rd_2_s),
    .b_in(imm_ext_s),
    .val_out(src_b_s)
  );
  
  // ALU
  alu i_alu (
    .ctrl_in(alu_ctrl_s),
    .a_in(src_a_s),
    .b_in(src_b_s),
    .result_out(alu_result_s),
    .zero_out(zero_s)
  );
  
  // result source mux
  mux_4_way #(
    .MUX_WIDTH(ARCH)
  ) i_result_src_mux (
    .sel_in(result_src_s),
    .a_in(alu_result_s),
    .b_in(data_mem_in),
    .c_in(pc_incr_s),
    .d_in(), // KEEP DISCONNECTED AS UNUSED
    .val_out(write_result_s)
  );

endmodule // friscv_top