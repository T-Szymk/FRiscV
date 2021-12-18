/******************************************************************************* 
 * Module   : alu
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 18-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * ALU to be used with FRiscV CPU.
 * Designed for RV32I ISA.
 ******************************************************************************/

import friscv_pkg::*;

module alu (
    input  logic [3:0] ctrl_in,
    input  logic [ARCH-1:0] a_in,
    input  logic [ARCH-1:0] b_in,
    output logic [ARCH-1:0] result_out,
    output logic zero_out
  );

  logic signed [ARCH-1:0] a_s, b_s, result_s;

  assign zero_out = (result_out == '0) ? 1 : '0; // zero out is 1'b1 when output is 0  
  // assignmets to allow east sign extensions
  assign a_s = a_in;
  assign b_s = b_in;
  assign result_out = result_s;

  // main operation of ALU
  always_comb begin
    case (ctrl_in)

    	AND : // AND
    	  result_s = a_s & b_s;
    	OR : // OR
    	  result_s = a_s | b_s;
    	XOR : // XOR
    	  result_s = a_s ^ b_s;
    	ADD : // ADD
    	  result_s = a_s + b_s;
    	SUB : // SUB
    	  result_s = a_s - b_s;
    	SLT : // SLT
    	  result_s = a_s < b_s;
    	SLL : // SLL
    	  result_s = a_s << b_s;
    	SAR : // SAR
    	  result_s = a_s >>> b_s;
    	SLR : // SLR
    	  result_s = a_s >> b_s;
    	default : result_s = '0;
  
    endcase // ctrl_in
  end

endmodule // alu