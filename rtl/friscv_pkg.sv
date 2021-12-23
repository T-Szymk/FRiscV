/******************************************************************************* 
 * Module   : friscv_pkg
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 23-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * SV package containing definitions and values that are used within the friscv
 * project.
 ******************************************************************************/

package friscv_pkg;

  // global
  localparam ARCH = 32;
  localparam ARCH_BYTES = ARCH / 8;
  
  localparam REGFILE_DEPTH = 32;
  localparam REGFILE_ADDR_WIDTH = $clog2(REGFILE_DEPTH);
  
  /* Note that the width of the address ports of the imem and dmem modules are 
     wide enough for byte addressing to be possible. The actual RAM is word
     addressed but this conversion takes place within the module. 
     The true RAM depth is defined by xMEM_DEPTH */
  localparam IMEM_DEPTH_BYTES = 4096;
  localparam IMEM_DEPTH       = IMEM_DEPTH_BYTES / ARCH_BYTES;
  localparam IMEM_ADDR_WIDTH = $clog2(IMEM_DEPTH_BYTES);
  
  localparam DMEM_DEPTH_BYTES = 4096; 
  localparam DMEM_DEPTH       = DMEM_DEPTH_BYTES / ARCH_BYTES;
  localparam DMEM_ADDR_WIDTH = $clog2(DMEM_DEPTH_BYTES);

  // Instruction Decode
  enum logic [6:0] { REG       = 7'b0110011,
                     IMM_ARITH = 7'b0010011,
                     IMM_JUMP  = 7'b1100111,
                     IMM_LOAD  = 7'b0000011,
                     STORE     = 7'b0100011,
                     BRANCH    = 7'b1100011,
                     U_L_LOAD  = 7'b0110111,
                     U_AUIPC   = 7'b0010111,
                     JUMP      = 7'b1101111
                   } OPCODES;

  // ALU
  enum logic [3:0] { AND  = 4'b0000,
                     OR   = 4'b0001,
                     XOR  = 4'b0010,
                     ADD  = 4'b0011,
                     SUB  = 4'b0100,
                     SLT  = 4'b0101,
                     SLL  = 4'b0110,
                     SAR  = 4'b0111,
                     SLR  = 4'b1000,
                     SLTU = 4'b1001
                   } ALU_OPS;

endpackage // friscv_pkg