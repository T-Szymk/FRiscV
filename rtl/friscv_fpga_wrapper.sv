/******************************************************************************* 
 * Module   : friscv_fpga_wrapper
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 24-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * FPGA wrapper to contain clock and memory for FPGA implementation.
 ******************************************************************************/

import friscv_pkg::*;

module friscv_fpga_wrapper(
  input logic clk,
  input logic rst_n,

  output logic [7-1:0] dbg_opcode_out,
  output logic [7-1:0] dbg_func7_out,
  output logic [3-1:0] dbg_func3_out
);

  parameter IMEM_INIT_FILE = "imem_init.mem";
  parameter DMEM_INIT_FILE = "dmem_init.mem";

  logic clk_s,
        mem_write_s;
  logic [ARCH-1:0] read_addr_s,
                   instr_s,
                   alu_result_s,
                   data_mem_s,
                   w_data_s;


  // clock generator
 clk_wiz_0 i_clk_wiz_0 (
  .clk_out1(clk_s),
  .resetn(rst_n),
  .clk_in1(clk)
 );

  // instruction memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(IMEM_DEPTH_BYTES),
    .INIT_FILE(IMEM_INIT_FILE)
  ) i_imem (
    .clk(clk_s),
    .addr_a_byte_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .addr_b_byte_in(read_addr_s[IMEM_ADDR_WIDTH-1:0]),
    .din_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .we_a_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .dout_b_out(instr_s) 
  );

  // data memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(DMEM_DEPTH_BYTES),
    .INIT_FILE(DMEM_INIT_FILE)
  ) i_dmem (
    .clk(clk_s),
    .addr_a_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .addr_b_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .din_a_in(w_data_s),
    .we_a_in(mem_write_s),
    .dout_b_out(data_mem_s) 
  );
  
  // FRiscV top design
  friscv_top i_friscv_top (
    .clk(clk_s),
    .rst_n(rst_n),
    .instr_in(instr_s),
    .data_mem_in(data_mem_s),
    .read_addr_out(read_addr_s),
    .alu_result_out(alu_result_s),
    .w_data_out(w_data_s),
    .mem_write_out(mem_write_s),
    .dbg_opcode_out(dbg_opcode_out),
    .dbg_func7_out(dbg_func7_out),
    .dbg_func3_out(dbg_func3_out)
  );

endmodule // friscv_fpga_wrapper