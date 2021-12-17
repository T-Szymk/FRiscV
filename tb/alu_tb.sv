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
 
module alu_tb #(
    parameter SIMULATION_RUNTIME_PS = 100_000_000 
  );


  logic signed [3:0] dut_ctrl_in;
  logic signed [ARCH-1:0] dut_a_in;
  logic signed [ARCH-1:0] dut_b_in;
  logic signed [ARCH-1:0] dut_result_out;
  logic dut_zero_out;
  
  class TestData;
    rand bit signed [3:0] ctrl;
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

    while($time < SIMULATION_RUNTIME_PS) begin
      data.randomize();
      dut_a_in = data.a;
      dut_b_in = data.b;
      dut_ctrl_in = data.ctrl;
      #1
      case (data.ctrl)
        AND : // AND
          assert(dut_result_out == (data.a & data.b)) else 
          $warning("and operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a & data.b), dut_result_out);
        OR : // OR
          assert(dut_result_out == (data.a | data.b)) else 
          $warning("or operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a | data.b), dut_result_out);
        XOR : // XOR
          assert(dut_result_out == (data.a ^ data.b)) else 
          $warning("xor operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a ^ data.b), dut_result_out);
        ADD : // ADD
          assert(dut_result_out == (data.a + data.b)) else 
          $warning("add operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a + data.b), dut_result_out);
        SUB : // SUB
          assert(dut_result_out == (data.a - data.b)) else 
          $warning("sub operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a - data.b), dut_result_out);
        SLT : // SLT
          assert(dut_result_out == (data.a < data.b)) else 
          $warning("slt operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a < data.b), dut_result_out);
        SLL : // SLL
          assert(dut_result_out == (data.a << data.b)) else 
          $warning("sll operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a << data.b), dut_result_out);
        SAR : // SAR
          assert(dut_result_out == (data.a >>> data.b)) else 
          $warning("sar operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a >>> data.b), dut_result_out);
        SLR : // SLR
          assert(dut_result_out == (data.a >> data.b)) else 
          $warning("slr operation failed! Expected 0x%0x, got 0x%0x.", 
                  (data.a >> data.b), dut_result_out);
        default: 
          assert(dut_result_out == '0) else 
          $warning("Undefined operation failed! Expected 0x%0x, got 0x%0x.", 
                  32'b0, dut_result_out);
      endcase;

    end
    $display("Simulation Complete!");
    $finish;
  end

endmodule // alu_tb