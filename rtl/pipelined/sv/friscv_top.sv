/******************************************************************************* 
 * Module   : friscv_fpga_top
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 04-Jan-2022
 *******************************************************************************
 * Description:
 * ============
 * Top module for friscv CPU. Contains all components and interfaces to
 * external memory and clock/reset.
 ******************************************************************************/

import friscv_sv_pkg::*;

module friscv_top(

  input  logic clk,
  input  logic rst_n,
  /* inputs from memories */
  input logic [ARCH-1:0] i_mem_d_in,
  input logic [ARCH-1:0] d_mem_rd_in,
  /* outputs to memories */
  output logic [ARCH-1:0] i_mem_addr_out,
  output logic [ARCH-1:0] d_mem_addr_out,
  output logic [ARCH-1:0] d_mem_wd_out,
  output logic            d_mem_we_out

);
  /* signals and constants */

  logic pc_sel_s;
  logic [ARCH-1:0] branch_val_s, pc_val_s;


  pc_stage i_pc_stage (
    .clk(clk),
    .rst_n(rst_n),
    .pc_sel_in(pc_sel_s),
    .branch_in(branch_val_s),
    .pc_out(pc_val_s)
  );
  
endmodule // friscv_top