-------------------------------------------------------------------------------- 
-- Module   : friscv_pkg
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 20-Feb-2022
--------------------------------------------------------------------------------
-- Description:
-- ============
-- VHDL package containing definitions and values that are used within the 
-- friscv project.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

package friscv_pkg is 

  constant XLEN       : integer := 32;
  constant XLEN_BYTES : integer := XLEN / 8; 

  constant REGFILE_DEPTH      : integer := 32;
  constant REGFILE_ADDR_WIDTH : integer := integer(ceil(log2(real(REGFILE_DEPTH))));
  
  -- Note that the width of the address ports of the imem and dmem modules are 
  -- wide enough for byte addressing to be possible. The actual RAM is word
  -- addressed but this conversion takes place within the module. 
  -- The true RAM depth is defined by xMEM_DEPTH 
  constant IMEM_DEPTH_BYTES : integer := 4096;
  constant IMEM_DEPTH       : integer := IMEM_DEPTH_BYTES / XLEN_BYTES;
  constant IMEM_ADDR_WIDTH  : integer := integer(ceil(log2(real(IMEM_DEPTH_BYTES))));
  
  constant DMEM_DEPTH_BYTES : integer := 4096; 
  constant DMEM_DEPTH       : integer := DMEM_DEPTH_BYTES / XLEN_BYTES;
  constant DMEM_ADDR_WIDTH  : integer := integer(ceil(log2(real(DMEM_DEPTH_BYTES))));
  
  -- address to be used if exception condition is detected
  constant EXCEPTION_ADDRESS : std_logic_vector(32-1 downto 0) := x"00000000";

  -- TODO:  Refactor the code below in a "vhdl-friendly manner"
  ---- Instruction Decode
  --enum logic [6:0] { REG       = 7'b0110011,
  --                   IMM_ARITH = 7'b0010011,
  --                   IMM_JUMP  = 7'b1100111,
  --                   IMM_LOAD  = 7'b0000011,
  --                   STORE     = 7'b0100011,
  --                   BRANCH    = 7'b1100011,
  --                   U_L_LOAD  = 7'b0110111,
  --                   U_AUIPC   = 7'b0010111,
  --                   JUMP      = 7'b1101111
  --                 } OPCODES;
  ---- ALU
  --enum logic [3:0] { AND  = 4'b0000,
  --                   OR   = 4'b0001,
  --                   XOR  = 4'b0010,
  --                   ADD  = 4'b0011,
  --                   SUB  = 4'b0100,
  --                   SLT  = 4'b0101,
  --                   SLL  = 4'b0110,
  --                   SAR  = 4'b0111,
  --                   SLR  = 4'b1000,
  --                   SLTU = 4'b1001
  --                 } ALU_OPS;

END;