/******************************************************************************* 
 * Module   : load_data_ext
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Formats data returned from data memory depending on instructions used.
 ******************************************************************************/

import friscv_pkg::*;

module load_data_ext(
  input  logic [ARCH-1:0] w_data_in,
  input  logic [7-1:0] op_code_in,
  input  logic [3-1:0] func3_in,

  output logic [ARCH-1:0] w_data_out
);

always_comb begin 
  case (op_code_in)
    IMM_LOAD :
      case (func3_in)
      	0 : // load sign-extended byte
      	  w_data_out = signed'(w_data_in[7:0]);
      	1 : // load sign-extended half-word
      	  w_data_out = signed'(w_data_in[15:0]);
      	2 : // load sign-extended word
      	  w_data_out = signed'(w_data_in[31:0]);
      	4 : // load zero-extended byte 
      	  w_data_out = unsigned'(w_data_in[7:0]);
      	5 : // load zero-extended half-word
      	  w_data_out = unsigned'(w_data_in[15:0]);
          default :
            w_data_out = w_data_in;
        endcase
  	default : 
		  w_data_out = w_data_in;
  endcase
end

endmodule // load_data_ext