/******************************************************************************* 
 * Module   : instr_mem
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 08-Jan-2022
 *******************************************************************************
 * Description:
 * ============
 * Test bench for the instr_mem module of FRiscV
 ******************************************************************************/

import friscv_sv_pkg::*;

module instr_mem_tb #(
  parameter RAM_WIDTH = ARCH,
  parameter RAM_DEPTH = 4096,
  parameter INIT_FILE = "test_mem_init.mem",
  parameter SIMULATION_RUNTIME = 100_000 // determine units from timescale or 
) (); 
  
  timeunit 1ns/1ps;

  bit clk, rst_n;
  bit unsigned [$clog2(RAM_DEPTH)-1:0] addr_dut;
  bit unsigned [ARCH-1:0] data_dut;
  
  // dut instantiation
  instr_mem #(
    .RAM_WIDTH(RAM_WIDTH),
    .RAM_DEPTH(RAM_DEPTH),
    .INIT_FILE(INIT_FILE)
  ) i_instr_mem (
    .clk(clk),
    .rst_n(rst_n),
    .instr_addr_byte_in(addr_dut),
    .instr_data_out(data_dut)
  );

  always #5 clk = ~clk; // clock generation

  initial begin
    {clk, rst_n} <= '0;
    addr_dut     <= '0;
    @(negedge clk);
    @(negedge clk);
    
    rst_n <= 1'b1;
    
    for(int i = 0; i < 65; i++) begin
      addr_dut <= i;
      @(negedge clk);
      if (i <= 63) begin
        assert(data_dut == (i / 4)) else
          $error ("FAILED: Expecting data value of %0h from address, but got %0h", (i-1), addr_dut, data_dut);
      end else begin
        assert(data_dut == 'hDEADBEEF) else
          $error ("FAILED: Expecting data value of 0xDEADBEEF, but got %0h", data_dut);
      end
    end
    
    #5;
    
    $finish;
  end
 
  function int imod(int x, divisor);
    return x - (divisor * (x / divisor));
  endfunction // imod

endmodule