/******************************************************************************* 
 * Module   : instr_decode
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 21-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Module to contain the logic to decode instructions
 ******************************************************************************/

import friscv_pkg::*;

module instr_decode (
  input  logic [ARCH-1:0] instr_in,
  
  output logic [6:0] op_code_out, 
  output logic [2:0] func3_out,
  output logic [6:0] func7_out,
  output logic [$clog2(REGFILE_DEPTH)-1:0] rs1_out, 
  output logic [$clog2(REGFILE_DEPTH)-1:0] rs2_out, 
  output logic [$clog2(REGFILE_DEPTH)-1:0] rd_out,
  output logic [ARCH-1:0] imm_out
);
  logic [2:0] func3_s;
  logic [6:0] op_code_s, func7_s;
  logic [$clog2(REGFILE_DEPTH)-1:0] rs1_s, rs2_s, rd_s;
  logic signed [ARCH-1:0] imm_s;
  
  
  assign op_code_s = instr_in[6:0];
  assign op_code_out = op_code_s;
  assign func3_out = func3_s;
  assign func7_out = func7_s;
  assign rs1_out = rs1_s;
  assign rs2_out = rs2_s;
  assign rd_out  = rd_s;
  assign imm_out = imm_s;

  always_comb begin : main_decoder_logic

    case(op_code_s) begin
      REG : // R-TYPE
        rd_s    = instr_in[7:11];
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = instr_in[31:25];
        imm_s   = '0;
      IMM_ARITH, IMM_JUMP, IMM_LOAD : // I-TYPE
        rd_s    = instr_in[7:11];
        rs1_s   = instr_in[19:15];
        rs2_s   = '0;
        func3_s = instr_in[14:12];
        func7_s = '0;
        imm_s   = signed'(instr_in[31:20]);
      STORE : // S-TYPE
        rd_s    = '0;
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = '0;
        imm_s   = signed'({instr_in[31:25], instr_in[11:7]});
      BRANCH : // B-TYPE
        rd_s    = '0;
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = '0;
        imm_s   = signed'({instr_in[31], instr_in[7], 
                           instr_in[30:25], instr_in[11:7]});
      U_L_LOAD : // U-TYPE
        rd_s    = instr_in[7:11];
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = signed'({instr_in[31:12]});
      JUMP : // J-TYPE
        rd_s    = instr_in[7:11];
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = signed'({instr_in[31], instr_in[19:12], 
                           instr_in[20], instr_in[30:21]});
      default : // illegal opcode
        rd_s    = '0;
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = '0;
    endcase

  end : main_decoder_logic
  
endmodule // instr_decode