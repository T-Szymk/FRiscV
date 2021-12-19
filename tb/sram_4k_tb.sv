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

module sram_4k_tb #(
  parameter RAM_WIDTH = ARCH,
  parameter RAM_DEPTH = 4096,
  parameter INIT_FILE = "test_mem_init.mem",
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

  always #5 clk <= ~clk;

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

  task test_byte_address;
    $info("Running test_byte_address()");
    we_a_s = 1'b1;
    addr_a_byte_s = 32'h00000002;
    din_a_s = 32'hDEADBEEF;
    en_b_s = 1'b1;
    addr_b_byte_s = '0;
    @(posedge clk); 
    assert(dout_b_s == 32'hDEADBEEF) else 
          $warning("test_byte_address failed at address 0x%0x!\n", 
                   addr_b_byte_s,
                   "Expected: 0xDEADBEEF\n",
                   "Read: 0x%0x", dout_b_s);
    addr_a_byte_s = 32'h00000003;
    din_a_s = 32'hBEEFDEAD;
    en_b_s = 1'b1;
    addr_b_byte_s = '0;
    @(posedge clk); 
    assert(dout_b_s == 32'hBEEFDEAD) else 
          $warning("test_byte_address failed at address 0x%0x!\n", 
                   addr_b_byte_s,
                   "Expected: 0xBEEFDEAD\n",
                   "Read: 0x%0x", dout_b_s);
    addr_a_byte_s = 32'h00000004;
    din_a_s = 32'hDEAFBEAD;
    en_b_s = 1'b1;
    addr_b_byte_s = 32'h00000004;
    @(posedge clk); 
    assert(dout_b_s == 32'hBEEFDEAD) else 
          $warning("test_byte_address failed at address 0x%0x!\n", 
                   addr_b_byte_s,
                   "Expected: 0xDEADBEEF\n",
                   "Read: 0x%0x", dout_b_s);
    assert(dout_b_s == 32'hDEAFBEAD) else 
          $warning("test_byte_address failed at address 0x%0x!\n", 
                   addr_b_byte_s,
                   "Expected: 0xDEAFBEAD\n",
                   "Read: 0x%0x", dout_b_s);
  endtask // test_byte_address

  initial begin : main_tb_loop
    test_byte_address();
    $info("Simulation Complete!");
    $finish;
  end : main_tb_loop

endmodule // sram_4k