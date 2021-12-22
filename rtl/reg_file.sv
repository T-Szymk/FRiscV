/******************************************************************************* 
 * Module   : reg_file
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 18-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Register file for use within the FRiscV CPU.
 * Design based on regfile implementation in H/H pg 297
 ******************************************************************************/

import friscv_pkg::*;

module reg_file (
  
  input  logic clk,
  input  logic we,
  input  logic [REGFILE_ADDR_WIDTH-1:0] addr_w, 
  input  logic [REGFILE_ADDR_WIDTH-1:0] addr_r1, 
  input  logic [REGFILE_ADDR_WIDTH-1:0] addr_r2,
  input  logic [ARCH-1:0] data_w, // write-back data input
  
  output logic [ARCH-1:0] data_r1, 
  output logic [ARCH-1:0] data_r2 
);

  logic [ARCH-1:0] reg_file_mem [REGFILE_DEPTH-1:0];
  
  // register 0 is hard-wired to 0
  assign data_r1 = (addr_r1 == 0) ? 0 : reg_file_mem[addr_r1];
  assign data_r2 = (addr_r2 == 0) ? 0 : reg_file_mem[addr_r2];

  always_ff @(posedge clk) begin : proc_reg_write
    if (we == 1'b1) begin
      reg_file_mem[addr_w] <= data_w;
    end 
  end : proc_reg_write  

endmodule // reg_file
