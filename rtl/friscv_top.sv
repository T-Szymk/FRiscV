/******************************************************************************* 
 * Module   : friscv_top
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Top wrapper for friscv CPU. Contains all components and connections.
 ******************************************************************************/

import friscv_pkg::*;

module friscv_top #(
  parameter IMEM_DEPTH     = 4096,
  parameter DMEM_WIDTH     = 4096,
  parameter IMEM_INIT_FILE = "imem_init.mem",
  parameter DMEM_INIT_FILE = "dmem_init.mem" 
) (
  input logic clk,
  input logic rst_n,

  output logic [7-1:0] dbg_opcode_out,
  output logic [7-1:0] dbg_func7_out,
  output logic [3-1:0] dbg_func3_out
);

/* SIGNALS ********************************************************************/
  
  logic [ARCH-1:0] pc_word_incr_s,
                   read_addr_s,
                   instr_s, 
                   src_a_s, 
                   rd_2_s,
                   w_data_s, 
                   src_b_s, 
                   alu_result_s, 
                   data_mem_s, 
                   reg_write_data_s,
                   write_result_s;
  logic zero_s,
        pc_src_s,
        pc_src_decode_s,
        jump_src_s,
        reg_write_s,
        alu_src_s,
        mem_write_s;
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

  // program counter
  pc i_pc (
    .clk(clk),
    .rst_n(rst_n),
    .pc_src_in(pc_src_s),
    .imm_in(imm_ext_s),
    .pc_word_incr_out(pc_word_incr_s),
    .pc_out(read_addr_s)
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

  // instruction memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(IMEM_DEPTH_BYTES),
    .INIT_FILE(IMEM_INIT_FILE)
  ) i_imem (
    .clk(clk),
    .addr_a_byte_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .addr_b_byte_in(read_addr_s[IMEM_ADDR_WIDTH-1:0]),
    .din_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .we_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .dout_b_out(instr_s) 
  );
  
  // instruction decoder
  instr_decode i_instr_decode (
    .instr_in(instr_s),
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
    .pc_src_out(pc_src_decode_s),
    .jump_src_out(jump_src_s),
    .reg_write_out(reg_write_s),
    .alu_src_out(alu_src_s),
    .alu_ctrl_out(alu_ctrl_s),
    .mem_write_out(mem_write_s),
    .result_src_out(result_src_s)
  );

  // register file
  reg_file i_reg_file (
    .clk(clk),
    .we(reg_write_s),
    .addr_w(rd_s),
    .addr_r1(rs1_s),
    .addr_r2(rs2_s),
    .data_w(),
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
    .rd_data_out(w_data_s)
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
  
  // data memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(DMEM_DEPTH_BYTES),
    .INIT_FILE(DMEM_INIT_FILE)
  ) i_dmem (
    .clk(clk),
    .addr_a_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .addr_b_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .din_a_in(w_data_s),
    .we_a_in(mem_write_s),
    .dout_b_out(data_mem_s) 
  );
  
  // result source mux
  mux_4_way #(
    .MUX_WIDTH(ARCH)
  ) i_result_src_mux (
    .sel_in(result_src_s),
    .a_in(alu_result_s),
    .b_in(data_mem_s),
    .c_in(pc_word_incr_s),
    .d_in(), // KEEP DISCONNECTED AS UNUSED
    .val_out(write_result_s)
  );

endmodule // friscv_top