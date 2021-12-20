/******************************************************************************* 
 * Module   : pc
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 20-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Program counter for FRiscV
 ******************************************************************************/

import friscv_pkg::*;

module pc (
  input  logic clk,
  input  logic rst_n,
  input  logic [ARCH-1:0] pc_in,

  output logic [ARCH-1:0] pc_out  
);

  logic [ARCH-1:0] pc_r;

  assign pc_out = pc_r;

  always_ff @(posedge clk or negedge rst_n) begin
  	if(~rst_n) begin
  		pc_r <= '0;
  	end else begin
  		pc_r <= pc_in + ARCH_BYTES;
  	end
  end

endmodule // pc
