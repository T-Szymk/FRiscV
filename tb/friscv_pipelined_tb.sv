/******************************************************************************* 
 * Module   : frisv_pipelined_tb
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 28-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Testbench to hold top level of pipelined FRiscV core.
 ******************************************************************************/

import friscv_sv_pkg::*;

`define SIM 1

module friscv_pipelined_tb;

  timeunit 1ns/1ps;

  parameter IMEM_INIT_FILE = "./fpga/imem_init.mem";
  parameter DMEM_INIT_FILE = "./fpga/dmem_init.mem";

  bit clk = 0, 
      rst_n = 0;

  friscv_fpga_wrapper #(
    .IMEM_INIT_FILE(IMEM_INIT_FILE),
    .DMEM_INIT_FILE(DMEM_INIT_FILE)
  ) i_friscv_fpga_wrapper(
  .clk(clk),
  .rst_n(rst_n)
  );

  always #5 clk = ~clk;

  initial begin 
  #50 rst_n = 1;
  end

endmodule // friscv_pipelined_tb