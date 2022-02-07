/******************************************************************************* 
 * Module   : pc_tb
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 07-Feb-2022
 *******************************************************************************
 * Description:
 * ============
 * Testbench for pipelined pc
 ******************************************************************************/

import friscv_pkg::*;

module friscv_pipelined_tb;

  timeunit 1ns/1ps;

  bit clk   = 0;
  bit rst_n = 0;

  logic pc_s;
  logic [1:0] pc_src_s;
  logic [XLEN-1:0] imm_s;

  pc i_pc (
    .clk(clk),
    .rst_n(rst_n),
    .pc_src_in(pc_src_s),
    .imm_in(imm_s),
    .pc_out(pc_s)    
  );

  always #5 clk = ~clk;

  initial #20 rst_n = 1;

  property reset_val;
    @(posedge clk) disable iff (rst_n == 1) 
      pc_s == 0;
  endproperty

  assert_rst_val: assert property(reset_val);

endmodule // friscv_pipelined_tb

