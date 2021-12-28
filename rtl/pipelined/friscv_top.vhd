--****************************************************************************** 
-- Module   : friscv_top
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 28-Dec-2021
--******************************************************************************
-- Description:
-- ============
-- Top module for friscv CPU. Contains all components and interfaces to
-- external memory and clock/reset.
--******************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.friscv_pkg.ALL;

ENTITY friscv_top IS 
  PORT (
    clk           : IN  STD_LOGIC;
    rst_n         : IN  STD_LOGIC;
    -- inputs from memory
    i_mem_d_in    : IN  STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);
    d_mem_rd_in   : IN  STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);
    -- outputs to memory
    i_mem_addr_out : OUT STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);
    d_mem_addr_out : OUT STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);    
    d_mem_wd_out   : OUT STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0); 
    d_mem_we_out   : OUT STD_LOGIC    
  );
END friscv_top;

--******************************************************************************

ARCHITECTURE structural OF friscv_top IS 

-- SIGNALS/CONSTANTS/TYPES --

  SIGNAL pc_sel_s : STD_LOGIC;

  SIGNAL branch_val_s,
         pc_val_s      : STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);

-- COMPONENT DECLARATIONS --

  COMPONENT pc_stage
    PORT (
      clk       : IN  STD_LOGIC;
      rst_n     : IN  STD_LOGIC;
      pc_sel_in : IN  STD_LOGIC;
      branch_in : IN  STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);
      pc_out    : OUT STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0) 
    );
  END COMPONENT;

BEGIN -- ARCHITECTURE structural -----------------------------------------------

-- COMPONENT INSTANCES --

-- program counter
i_pc_stage : pc_stage
  PORT MAP (
    clk       => clk,        
    rst_n     => rst_n,    
    pc_sel_in => pc_sel_s,       
    branch_in => branch_val_s,       
    pc_out    => pc_val_s    
  );

END structural;
--******************************************************************************