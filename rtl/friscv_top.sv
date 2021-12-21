/******************************************************************************* 
 * Module   : friscv_top
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 21-Dec-2021
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
  input logic rst_n
);

/* SIGNALS ********************************************************************/

logic [ARCH-1:0] pc_a_s, pc_int_s, read_addr_s, instr_s, src_a_s, rd_2_s, 
                 src_b_s, alu_result_s, data_mem_s, reg_write_data_s;
logic [$clog2(REGFILE_DEPTH)-1:0] rs1_s, rs2_s, rd_s;
logic signed [ARCH-1:0] imm_ext_s;

/* COMPONENTS *****************************************************************/


// PLACE THIS INTO DECODE MODULE 
// assign imm_ext_s = signed'(instr_s[31:7]); // cast to signed to sign-extend
assign pc_a_s = read_addr_s + imm_ext_s;

// pc source mux
mux_2_way #(
  .MUX_WIDTH(ARCH)
) i_pc_src_mux (
  .sel_in(),
  .a_in(pc_a_s),
  .b_in(read_addr_s),
  .val_out(pc_int_s)
);

// program counter
pc i_pc (
  .clk(clk),
  .rst_n(rst_n),
  .pc_in(pc_int_s),
  .pc_out(read_addr_s)
);

// instruction memory
sram_4k #(
  .RAM_WIDTH(ARCH),
  .RAM_DEPTH(IMEM_DEPTH),
  .INIT_FILE(IMEM_INIT_FILE)
) i_imem (
  .clk(clk),
  .addr_a_byte_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
  .addr_b_byte_in(read_addr_s),
  .din_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
  .we_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
  .dout_b_out(instr_s) 
);

// instruction decoder
instr_decode i_instr_decode (
  .instr_in(instr_s),
  .op_code_out(), // not connected
  .func3_out(), // not connected
  .func7_out(), // not connected
  .rs1_out(rs1_s),
  .rs2_out(rs2_s),
  .rd_out(rd_s),
  .imm_out(imm_ext_s),
  .alu_ctrl_out() // not connected
);

// register file
reg_file i_reg_file (
  .clk(clk),
  .we(), // not connected
  .addr_w(rd_s),
  .addr_r1(rs1_s),
  .addr_r2(rs2_s),
  .data_w(reg_write_data_s),
  .data_r1(src_a_s),
  .data_r2(rd_2_s)
);

// INSERT MAIN CONTROLLER

// ALU source mux
mux_2_way #(
  .MUX_WIDTH(ARCH)
) i_alu_src_mux (
  .sel_in(), // not connected
  .a_in(rd_2_s),
  .b_in(imm_ext_s),
  .val_out(src_b_s)
);

// ALU
alu i_alu (
  .ctrl_in(), // not connected
  .a_in(src_a_s),
  .b_in(src_b_s),
  .result_out(alu_result_s),
  .zero_out() // not connected
);

// data memory
sram_4k #(
  .RAM_WIDTH(ARCH),
  .RAM_DEPTH(DMEM_DEPTH),
  .INIT_FILE(DMEM_INIT_FILE)
) i_imem (
  .clk(clk),
  .addr_a_byte_in(alu_result_s),
  .addr_b_byte_in(alu_result_s),
  .din_a_in(rd_2_s),
  .we_a_in(), // not connected
  .dout_b_out(data_mem_s) 
);

// result source mux
mux_2_way #(
  .MUX_WIDTH(ARCH)
) i_result_src_mux (
  .sel_in(), // not connected
  .a_in(alu_result_s),
  .b_in(data_mem_s),
  .val_out(reg_write_data_s)
);

endmodule // friscv_top