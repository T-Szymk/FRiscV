/******************************************************************************* 
 * Module   : mux_2_way
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 20-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Variable width 2-way multiplexer.
 ******************************************************************************/

import friscv_pkg::*;

module mux_2_way #(
  parameter MUX_WIDTH = 8
) (
  input  logic sel_in,
  input  logic [MUX_WIDTH-1:0] a_in,
  input  logic [MUX_WIDTH-1:0] b_in,

  output logic [MUX_WIDTH-1:0] val_out
);

  assign val_out = sel_in ? b_in : a_in;  

endmodule // mux_2_way