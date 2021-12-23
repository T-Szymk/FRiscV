/******************************************************************************* 
 * Module   : main_controller
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Main controller for the FRiscV CPU. Contains logic to decode the ALU control
 * signals and supporting control signals to control CPU datapath.
 ******************************************************************************/

import friscv_pkg::*;

module main_controller (
  input  logic [3-1:0] func3_in,
  input  logic [7-1:0] func7_in,
  input  logic [7-1:0] op_code_in,
  input  logic zero_in,

  output logic pc_src_out,
  output logic jump_src_out,
  output logic reg_write_out,
  output logic alu_src_out,
  output logic [4-1:0] alu_ctrl_out,
  output logic mem_write_out,
  output logic [2-1:0] result_src_out
);


always_comb begin : main_control

  pc_src_out     = '0;
  jump_src_out   = '0;
  reg_write_out  = '0;
  alu_src_out    = '0;
  alu_ctrl_out   = '0;
  mem_write_out  = '0;
  result_src_out = '0;
  
  unique case(op_code_in) // opcode

    REG : begin // R-TYPE ------------------------------------------------------------

      pc_src_out    = 1'b1;
      reg_write_out = 1'b1; 

      unique case (func3_in) // r-type func3 
        0 : 
          alu_ctrl_out = (func7_in[5] == 1'b0) ? ADD : SUB;
        1 :
          alu_ctrl_out = SLL;
        2 :
          alu_ctrl_out = SLT;
        3 :
          alu_ctrl_out = SLTU;
        4 : 
          alu_ctrl_out = XOR;
        5 : 
          alu_ctrl_out = (func7_in[5] == 1'b0) ? SLR : SAR;
        6 : 
          alu_ctrl_out = OR;
        7 : 
          alu_ctrl_out = AND;
      endcase // r-type func3
    end
    IMM_ARITH : begin // I-TYPE (arithmetic) ----------------------------------------- 

      pc_src_out    = 1'b1;
      reg_write_out = 1'b1;
      alu_src_out   = 1'b1; 
    
      case (func3_in) // I-type arith func3
        0 : 
          alu_ctrl_out = ADD; 
        1 :
          alu_ctrl_out = SLL;
        2 :
          alu_ctrl_out = SLT;
        3 : 
          alu_ctrl_out = XOR;
        4 : 
          alu_ctrl_out = SLTU;
        5 :
        /* note that immediate[11:5] has been passed into func7 to allow logic
           to determine between SRL and SRA more easily */
          alu_ctrl_out = (func7_in[4] == 1'b1) ? SAR : SLR;
        6 : 
          alu_ctrl_out = OR;
        7 : 
          alu_ctrl_out = AND;
      endcase // I-type arith func3
    end
    IMM_JUMP : begin // I-TYPE (indirect jump JALR)

      pc_src_out     = 1'b1;
      jump_src_out   = 1'b1; // takes PC val from ALU output
      reg_write_out  = 1'b1;
      alu_src_out    = 1'b1; 
      result_src_out = 2'b10;
      alu_ctrl_out   = ADD;

    end
    IMM_LOAD : begin // I-TYPE (load) ------------------------------------------------
      
      pc_src_out     = 1'b1;
      reg_write_out  = 1'b1;
      alu_src_out    = 1'b1; 
      result_src_out = 2'b01;
      alu_ctrl_out   = ADD;

    end
    STORE : begin // S-TYPE ----------------------------------------------------------
    
      pc_src_out     = 1'b1;
      alu_src_out    = 1'b1;
      mem_write_out  = 1'b1; 
      alu_ctrl_out   = ADD;
      
    end
    BRANCH : begin // B-TYPE ---------------------------------------------------------

      pc_src_out = zero_in ? 1'b1 : '0; 

      case (func3_in) // B-type func3
        0 : // beq
          alu_ctrl_out = SUB;
      endcase // B-type  func3

    // U_L_LOAD : // U-TYPE INTRODUCE ONCE RELEVANT INSTRUCTIONS ARE ADDED
    end
    JUMP : begin // J-TYPE -----------------------------------------------------------
      
      reg_write_out  = 1'b1;
      alu_src_out    = 1'b1;
      result_src_out = 2'b10;
      alu_ctrl_out   = ADD;
    end
    default : begin // DEFAULT -------------------------------------------------------
    
      pc_src_out     = '0;
      jump_src_out   = '0;
      reg_write_out  = '0;
      alu_src_out    = '0;
      alu_ctrl_out   = '0;
      mem_write_out  = '0;
      result_src_out = '0;
    end
  endcase  // opcode

end : main_control

endmodule // main_controller
