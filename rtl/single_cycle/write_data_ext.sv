/******************************************************************************* 
 * Module   : write_data_ext
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Formats data returned from or delivered to data memory depending on 
 * instructions used.
 ******************************************************************************/

import friscv_pkg::*;

module write_data_ext(
  input  logic [ARCH-1:0] w_data_in,
  input  logic [ARCH-1:0] rd_data_in,
  input  logic [7-1:0] op_code_in,
  input  logic [3-1:0] func3_in,

  output logic [ARCH-1:0] w_data_out,
  output logic [ARCH-1:0] rd_data_out
);

always_comb begin 

    w_data_out  = w_data_in;
  	rd_data_out = rd_data_in;
  
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
    STORE : 
      case (func3_in)
      	0 : // store byte
      	  rd_data_out = rd_data_in[7:0];
      	1 : // store half word
      	  rd_data_out = rd_data_in[15:0];
      	2 : // store word
      	  rd_data_out = rd_data_in[31:0];
      	default :  
      	  rd_data_out = rd_data_in;
       endcase
  	default : begin
		  w_data_out  = w_data_in;
		  rd_data_out = rd_data_in;
    end
  endcase
end

endmodule // write_data_ext