--****************************************************************************** 
-- Module   : friscv_pkg
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 28-Dec-2021
--******************************************************************************
-- Description:
-- ============
-- VHDL package containing definitions and values that are used within the 
-- friscv project.
--******************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.MATH_REAL.ALL;

PACKAGE friscv_pkg IS 
  
  CONSTANT ARCH       : INTEGER := 32;
  CONSTANT ARCH_BYTES : INTEGER := ARCH / 8;
  
  CONSTANT REGFILE_DEPTH      : INTEGER := 32;
  CONSTANT REGFILE_ADDR_WIDTH : INTEGER := INTEGER(CEIL(LOG2(REAL(REGFILE_DEPTH))));
  
  -- Note that the width of the address ports of the imem and dmem modules are 
  -- wide enough for byte addressing to be possible. The actual RAM is word
  -- addressed but this conversion takes place within the module. 
  -- The true RAM depth is defined by xMEM_DEPTH 
  CONSTANT IMEM_DEPTH_BYTES : INTEGER := 4096;
  CONSTANT IMEM_DEPTH       : INTEGER := IMEM_DEPTH_BYTES / ARCH_BYTES;
  CONSTANT IMEM_ADDR_WIDTH  : INTEGER := INTEGER(CEIL(LOG2(REAL(IMEM_DEPTH_BYTES))));
  
  CONSTANT DMEM_DEPTH_BYTES : INTEGER := 4096; 
  CONSTANT DMEM_DEPTH       : INTEGER := DMEM_DEPTH_BYTES / ARCH_BYTES;
  CONSTANT DMEM_ADDR_WIDTH  : INTEGER := INTEGER(CEIL(LOG2(REAL(DMEM_DEPTH_BYTES))));

END friscv_pkg;