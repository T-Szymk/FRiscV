/******************************************************************************* 
 * Module   : alu_tb
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 17-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Test bench for verifying alu.sv module
 ******************************************************************************/

`timescale 1 ns/1 ps

import friscv_pkg::*;
 
module alu_tb;

  logic signed [3:0] dut_ctrl_in;
  logic signed [ARCH-1:0] dut_a_in;
  logic signed [ARCH-1:0] dut_b_in;
  logic signed [ARCH-1:0] dut_result_out;
  logic dut_zero_out;
  
  class TestData;
    rand bit signed [ARCH-1:0] a;
    rand bit signed [ARCH-1:0] b;
  endclass // TestData

  alu i_alu (
    .ctrl_in(dut_ctrl_in),
    .a_in(dut_a_in),
    .b_in(dut_b_in),
    .result_out(dut_result_out),
    .zero_out(dut_zero_out)
  );

  initial begin 
    static TestData data = new();
    {dut_ctrl_in, dut_a_in, dut_b_in} = '0;
    while($time < 100_000) begin
      data.randomize();
      check_and(data.a, data.b);
      check_or(data.a, data.b);
    end
    $finish;
  end

  task check_and(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  begin
    dut_a_in = a;
    dut_b_in = b;
    #1 assert(dut_result_out == (a & b)) else 
       $warning("and_check operation failed! Expected 0x%0x, got 0x%0x.", 
                (a & b), dut_result_out);
  end
  endtask // and

  task check_or(bit [ARCH-1:0] a,
                bit [ARCH-1:0] b);
    dut_a_in = a;
    dut_b_in = b;
    #1 assert(dut_result_out == (a | b)) else 
       $warning("or_check operation failed! Expected 0x%0x, got 0x%0x.", 
                (a | b), dut_result_out);
  endtask // check_or

  task check_xor(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
    dut_a_in = a;
    dut_b_in = b;
    #1 assert(dut_result_out == signed'(a ^ b)) else 
       $warning("xor_check operation failed! Expected 0x%0x, got 0x%0x.", 
                (a ^ b), dut_result_out);
  endtask // check_xor

  task check_add(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_add

  task check_sub(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_sub

  task check_slt(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_slt

  task check_sll(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_sll

  task check_sar(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_sar

  task check_slr(bit [ARCH-1:0] a,
                 bit [ARCH-1:0] b);
  endtask // check_slr

endmodule // alu_tb