/******************************************************************************* 
 * Module   : pc
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 20-Feb-2021
 *******************************************************************************
 * Description:
 * ============
 * Program counter for  pipelined FRiscV
 ******************************************************************************/

import friscv_pkg::*;

module pc (
  input  logic clk,
  input  logic rst_n,
  input  logic [1:0] pc_src_in, 
  input  logic [XLEN-1:0] alt_pc_in,
  
  output logic [XLEN-1:0] pc_out,
  output logic [XLEN-1:0] pc_nxt_out  
);

  logic [XLEN-1:0] pc_r; 
  logic [XLEN-1:0] pc_a_s; 
  logic [XLEN-1:0] pc_b_s; 
  logic [XLEN-1:0] pc_int_s;
  logic [XLEN-1:0] exception_addr_s;

  assign exception_addr_s = EXCEPTION_ADDRESS;

  /* pc_src mux fed by incremented pc. Can be word incremented or 
     immediate incremented */
  assign pc_a_s = pc_r + alt_pc_in;
  assign pc_b_s = pc_r + XLEN_BYTES;

  assign pc_out = pc_r;

  // pc source mux
  mux_4_way #(
    .MUX_WIDTH(XLEN)
  ) i_pc_src_mux (
    .sel_in(pc_src_in),
    .a_in(pc_a_s),
    .b_in(pc_b_s),
    .c_in(exception_addr_s),
    .d_in('0),
    .val_out(pc_int_s)
  );

  always_ff @(posedge clk or negedge rst_n) begin
  	if(~rst_n) begin
  		pc_r <= '0;
  	end else begin
  		pc_r <= pc_int_s;
  	end
  end

endmodule // pc
