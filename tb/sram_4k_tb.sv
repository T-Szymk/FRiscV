/******************************************************************************* 
 * Module   : sram_4k_tb
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 19-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Test bench for verifying sram_4k.sv module
 ******************************************************************************/

import friscv_pkg::*;

module sram_4k #(
  parameter RAM_WIDTH = ARCH,
  parameter RAM_DEPTH = 4096,
  parameter INIT_FILE = "imem_init.mem",
  parameter SIMULATION_RUNTIME = 100_000 // determine units from timescale or 
); 

  timeunit 1ns/1ps;

  bit clk    = 1'b0;
  bit we_a_s = 1'b0;
  bit en_b_s = 1'b0;
  bit [$clog2(RAM_DEPTH)-1:0] addr_a_byte_s = '0;
  bit [$clog2(RAM_DEPTH)-1:0] addr_b_byte_s = '0;
  bit [RAM_WIDTH-1:0] din_a_s  = '0;
  bit [RAM_WIDTH-1:0] dout_b_s = '0;

  sram_4k #(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH),
    .INIT_FILE(INIT_FILE)
  ) i_sram (
    .clk(clk),
    .addr_a_byte_in(addr_a_byte_s),
    .addr_b_byte_in(addr_b_byte_s),
    .din_a_in(din_a_s),
    .we_a_in(we_a_s),
    .en_b_in(en_b_s),
    .dout_b_out(dout_b_s)
  );


endmodule // sram_4k