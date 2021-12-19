/******************************************************************************* 
 * Module   : friscv_pkg
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 17-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * SV package containing definitions and values that are used within the friscv
 * project.
 ******************************************************************************/

package friscv_pkg;

  // global
  localparam ARCH = 32;
  localparam REGFILE_DEPTH = 32;
  localparam IMEM_DEPTH_BYTES = 4096;
  localparam DMEM_DEPTH_BYTES = 4096; 

  // ALU
  enum logic [3:0] { AND = 4'b0000,
                     OR  = 4'b0001,
                     XOR = 4'b0010,
                     ADD = 4'b0011,
                     SUB = 4'b0100,
                     SLT = 4'b0101,
                     SLL = 4'b0110,
                     SAR = 4'b0111,
                     SLR = 4'b1000
                   } ALU_OPS;

endpackage // friscv_pkg