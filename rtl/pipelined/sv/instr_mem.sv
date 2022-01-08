/******************************************************************************* 
 * Module   : instr_mem
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 08-Jan-2022
 *******************************************************************************
 * Description:
 * ============
 * Wrapper to hold instruction memory and 
 ******************************************************************************/

import friscv_sv_pkg::*;

module instr_mem #(
  parameter RAM_WIDTH = ARCH,  // Specify RAM data width
  parameter RAM_DEPTH = 4096,  // Specify RAM depth (number of entries)
  parameter INIT_FILE = ""     // Specify name/location of RAM initialization 
) (
  input  logic clk,
  input  logic rst_n,
  input  logic [$clog2(RAM_DEPTH)-1:0] instr_addr_byte_in,

  output logic [RAM_WIDTH-1:0] instr_data_out 
);

  logic [RAM_WIDTH-1:0] data_out_r, data_out_s;
  
  sram_4k #(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH),
    .INIT_FILE(INIT_FILE)
  ) i_sram_4k (
    .clk(clk),
    .addr_a_byte_in(), // not connected as write not used for instr memory
    .addr_b_byte_in(instr_addr_byte_in),
    .din_a_in(),       // not connected as write not used for instr memory
    .we_a_in(),        // not connected as write not used for instr memory
    .dout_b_out(data_out_s) 
  );


  always_ff @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
      data_out_r <= 0;
    end else begin
      data_out_r <= data_out_s;
    end
  end

  assign instr_data_out = data_out_r;

endmodule // instr_mem