/******************************************************************************* 
 * Module   : mux_4_way
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 22-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Variable width 4-way multiplexer.
 ******************************************************************************/

import friscv_pkg::*;

module mux_4_way #(
  parameter MUX_WIDTH = 8
) (
  input  logic [1:0] sel_in,
  input  logic [MUX_WIDTH-1:0] a_in,
  input  logic [MUX_WIDTH-1:0] b_in,
  input  logic [MUX_WIDTH-1:0] c_in,
  input  logic [MUX_WIDTH-1:0] d_in,

  output logic [MUX_WIDTH-1:0] val_out
);

  assign val_out = (sel_in == 1) ? b_in : (sel_in == 2) ? c_in : (sel_in == 3) ? d_in : a_in;  

endmodule // mux_4_way