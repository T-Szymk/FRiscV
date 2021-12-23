/******************************************************************************* 
 * Module   : instr_decode
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 22-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Module containing the logic to decode instructions into components
 ******************************************************************************/

import friscv_pkg::*;

module instr_decode (
  input  logic [ARCH-1:0] instr_in,
  
  output logic [7-1:0] op_code_out, 
  output logic [3-1:0] func3_out,
  output logic [7-1:0] func7_out,
  output logic [REGFILE_ADDR_WIDTH-1:0] rs1_out, 
  output logic [REGFILE_ADDR_WIDTH-1:0] rs2_out, 
  output logic [REGFILE_ADDR_WIDTH-1:0] rd_out,
  output logic [ARCH-1:0] imm_out
);

  logic [3-1:0] func3_s;
  logic [7-1:0] op_code_s, 
              func7_s;
  logic [$clog2(REGFILE_DEPTH)-1:0] rs1_s, 
                                    rs2_s, 
                                    rd_s;
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

    rd_s    = '0;
    rs1_s   = '0;
    rs2_s   = '0;
    func3_s = '0;
    func7_s = '0;
    imm_s   = '0;

    case(op_code_s)
      REG : begin // R-TYPE
        rd_s    = instr_in[11:7];
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = instr_in[31:25];
        imm_s   = '0;
      end
      IMM_ARITH : begin // I-TYPE (arithmetic)
        rd_s    = instr_in[11:7];
        rs1_s   = instr_in[19:15];
        rs2_s   = '0;
        func3_s = instr_in[14:12];
        func7_s = '0;
        // sign-extend immediate depending on func3 vals (SLT or SLTU)
        if (instr_in[14:12] == 3'd3) begin
          imm_s = unsigned'(instr_in[31:20]);
        end
        else begin 
          imm_s = signed'(instr_in[31:20]);
        end

      end
      IMM_JUMP : begin // I-TYPE (jump)
        rd_s    = instr_in[11:7];
        rs1_s   = instr_in[19:15];
        rs2_s   = '0;
        func3_s = instr_in[14:12];
        func7_s = '0;
        imm_s   = signed'(instr_in[31:20]); 
      end
      IMM_LOAD : begin // I-TYPE (load)
        rd_s    = instr_in[11:7];
        rs1_s   = instr_in[19:15];
        rs2_s   = '0;
        func3_s = instr_in[14:12];
        func7_s = '0;
        // sign-extend immediate depending on func3 vals (LBU or LHU)
        if (instr_in[14] == 1'b1) begin
          imm_s = unsigned'(instr_in[31:20]);
        end
        else begin 
          imm_s = signed'(instr_in[31:20]);
        end
      end
      STORE : begin // S-TYPE
        rd_s    = '0;
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = '0;
        imm_s   = signed'({instr_in[31:25], instr_in[11:7]});
      end
      BRANCH : begin // B-TYPE
        rd_s    = '0;
        rs1_s   = instr_in[19:15];
        rs2_s   = instr_in[24:20];
        func3_s = instr_in[14:12];
        func7_s = '0;
        // sign-extend immediate depending on func3 vals (BLTU or BGEU)
        if (instr_in[14:13] == 2'b11) begin
          imm_s   = unsigned'({instr_in[31], instr_in[7], 
                               instr_in[30:25], instr_in[11:8], 1'b0});
        end
        else begin 
          imm_s   = signed'({instr_in[31], instr_in[7], 
                             instr_in[30:25], instr_in[11:8], 1'b0});
        end
        
      end
      U_L_LOAD : begin // U-TYPE
        rd_s    = instr_in[11:7];
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = signed'({instr_in[31:12], 12'b0});
      end
      JUMP : begin // J-TYPE
        rd_s    = instr_in[11:7];
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = signed'({instr_in[31], instr_in[19:12], 
                           instr_in[20], instr_in[30:21], 1'b0});
      end                    
      default : begin // illegal opcode
        rd_s    = '0;
        rs1_s   = '0;
        rs2_s   = '0;
        func3_s = '0;
        func7_s = '0;
        imm_s   = '0;
      end
    endcase

  end : main_decoder_logic
  
endmodule // instr_decode