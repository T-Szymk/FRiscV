/******************************************************************************* 
 * Module   : alu
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * ALU to be used with FRiscV CPU.
 * Designed for RV32I ISA.
 ******************************************************************************/

import friscv_pkg::*;

module alu (
    input  logic [4-1:0] ctrl_in,
    input  logic [ARCH-1:0] a_in,
    input  logic [ARCH-1:0] b_in,
    output logic [ARCH-1:0] result_out,
    output logic zero_out
  );

  logic signed [ARCH-1:0] a_s, b_s, result_s;

  assign zero_out = (result_out == '0) ? 1 : '0; // zero out is 1'b1 when output is 0  
  // assignmets to allow sign extensions
  assign a_s = signed'(a_in);
  assign b_s = signed'(b_in);
  assign result_out = result_s;

  // main operation of ALU
  always_comb begin
    case (ctrl_in)

    	AND : 
    	  result_s = a_s & b_s;

    	OR :
    	  result_s = a_s | b_s;

    	XOR : 
    	  result_s = a_s ^ b_s;

    	ADD : 
    	  result_s = a_s + b_s;

    	SUB : 
    	  result_s = a_s - b_s;

    	SLT : 
    	  result_s = a_s < b_s;
      /* Note that for shift instructions, only lowest bits of immediate value 
         are used (as per the RISC-V spec.) */
    	SLL : 
    	  result_s = a_s <<  unsigned'(b_s[4:0]);

    	SAR :
    	  result_s = a_s >>> unsigned'(b_s[4:0]);

    	SLR :
    	  result_s = a_s >>  unsigned'(b_s[4:0]);

      SLTU :
        result_s = a_s <  unsigned'(b_s);

    	default : result_s = '0;
  
    endcase // ctrl_in
  end

endmodule // alu