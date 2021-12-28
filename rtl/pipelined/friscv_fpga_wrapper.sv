/******************************************************************************* 
 * Module   : friscv_fpga_wrapper
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 28-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * FPGA wrapper to contain clock and memory for FPGA implementation.
 ******************************************************************************/

import friscv_sv_pkg::*;

module friscv_fpga_wrapper # (
  parameter IMEM_INIT_FILE = "imem_init.mem",
  parameter DMEM_INIT_FILE = "dmem_init.mem"
) (
  input logic clk,
  input logic rst_n
);

  logic clk_s,
        mem_write_s;
  logic [ARCH-1:0] read_addr_s,
                   instr_s,
                   alu_result_s,
                   data_mem_s,
                   w_data_s;

    `ifndef SIM // Synthesis or Vivado simulation //////////////////////////////

      // clock generator
      clk_wiz_0 i_clk_wiz_0 (
       .clk_out1(clk_s),
       .resetn(rst_n),
       .clk_in1(clk)
      );

    `else  // For use with Modelsim/Questa /////////////////////////////////////

      assign clk_s = clk;

    `endif // SIM //////////////////////////////////////////////////////////////
  
  // instruction memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(IMEM_DEPTH_BYTES),
    .INIT_FILE(IMEM_INIT_FILE)
  ) i_imem (
    .clk(clk_s),
    .addr_a_byte_in(), // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .addr_b_byte_in(read_addr_s[IMEM_ADDR_WIDTH-1:0]),
    .din_a_in(),       // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .we_a_in(),        // KEEP DISCONNECTED AS INSTR MEM READ ONLY
    .dout_b_out(instr_s) 
  );
   
  // data memory
  sram_4k #(
    .RAM_WIDTH(ARCH),
    .RAM_DEPTH(DMEM_DEPTH_BYTES),
    .INIT_FILE(DMEM_INIT_FILE)
  ) i_dmem (
    .clk(clk_s),
    .addr_a_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .addr_b_byte_in(alu_result_s[DMEM_ADDR_WIDTH-1:0]),
    .din_a_in(w_data_s),
    .we_a_in(mem_write_s),
    .dout_b_out(data_mem_s) 
  );
  
  // FRiscV top design
  friscv_top i_friscv_top (
    .clk(clk_s),
    .rst_n(rst_n),
    .i_mem_d_in(instr_s),
    .d_mem_rd_in(data_mem_s),
    .i_mem_addr_out(), // UNCONNECTED     
    .d_mem_addr_out(), // UNCONNECTED    
    .d_mem_wd_out(),   // UNCONNECTED  
    .d_mem_we_out()    // UNCONNECTED 
  );

endmodule // friscv_fpga_wrapper