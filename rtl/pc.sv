/******************************************************************************* 
 * Module   : pc
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 22-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Program counter for FRiscV
 ******************************************************************************/

import friscv_pkg::*;

module pc (
  input  logic clk,
  input  logic rst_n,
  input  logic auipc_in,
  input  logic pc_src_in, 
  input  logic [ARCH-1:0] imm_in,
  
  // word increment is exposed to be used by JAL
  output logic [ARCH-1:0] pc_incr_out, 
  output logic [ARCH-1:0] pc_out  
);

  logic [ARCH-1:0] pc_r, 
                   pc_a_s, 
                   pc_b_s, 
                   pc_int_s;

  // pc source mux
  mux_2_way #(
    .MUX_WIDTH(ARCH)
  ) i_pc_src_mux (
    .sel_in(pc_src_in),
    .a_in(pc_a_s),
    .b_in(pc_b_s),
    .val_out(pc_int_s)
  );

  // auipc mux : 0 sends PC + word to result mux, 
  //             1 sends PC + imm  to result mux 
  mux_2_way #(
    .MUX_WIDTH(ARCH)
  ) i_auipc_mux (
    .sel_in(auipc_in),
    .a_in(pc_b_s),
    .b_in(pc_a_s),
    .val_out(pc_incr_out)
  );
  
  /* pc_src mux fed by incremented pc. Can be word incremented or 
     immediate incremented */
  assign pc_a_s = pc_r + imm_in;
  assign pc_b_s = pc_r + ARCH_BYTES;

  assign pc_out = pc_r;

  always_ff @(posedge clk or negedge rst_n) begin
  	if(~rst_n) begin
  		pc_r <= '0;
  	end else begin
  		pc_r <= pc_int_s;
  	end
  end

endmodule // pc
