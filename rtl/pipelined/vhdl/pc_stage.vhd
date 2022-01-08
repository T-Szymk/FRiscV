--****************************************************************************** 
-- Module   : pc_stage
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 28-Dec-2021
--******************************************************************************
-- Description:
-- ============
-- Program counter stage for pipelined implementation of FRiscV
--******************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.friscv_pkg.ALL;

ENTITY pc_stage IS 
  PORT (
    clk       : IN  STD_LOGIC;
    rst_n     : IN  STD_LOGIC;
    pc_sel_in : IN  STD_LOGIC;
    branch_in : IN  STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);

    pc_out    : OUT STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0) 
  );
END pc_stage;

--******************************************************************************
ARCHITECTURE rtl OF pc_stage IS 

  SIGNAL pc_r,
         pc_out_r,
         pc_incr_s : UNSIGNED(ARCH-1 DOWNTO 0);
  SIGNAL pc_s : STD_LOGIC_VECTOR(ARCH-1 DOWNTO 0);

  COMPONENT mux_2_way
  GENERIC (
    MUX_WIDTH_g : INTEGER
  );
  PORT (
    sel_in  : IN  STD_LOGIC;
    a_in    : IN  STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0);
    b_in    : IN  STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0);
    val_out : OUT STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0)
  );
  END COMPONENT;

BEGIN

  i_mux_2_way : mux_2_way
  GENERIC MAP (
    MUX_WIDTH_g => ARCH
  )
  PORT MAP (
    sel_in  => pc_sel_in,
    a_in    => STD_LOGIC_VECTOR(pc_incr_s),
    b_in    => branch_in,
    val_out => pc_s
  );
  
  -- assign 
  PROCESS (clk, rst_n) IS 
  BEGIN
    IF rst_n = '0' THEN 
      pc_r     <= (OTHERS => '0');
      pc_out_r <= (OTHERS => '0');
    ELSIF RISING_EDGE(clk) THEN
      pc_r <= UNSIGNED(pc_s);
      pc_out_r <= pc_r;
    END IF; 
  END PROCESS;

  -- increment PC register by 4 in preparation for the next CC
  pc_increment : PROCESS (pc_r) IS 
  BEGIN 
    pc_incr_s <= pc_r + 4;
  END PROCESS pc_increment;

  -- assign outputs 
  pc_out <= STD_LOGIC_VECTOR(pc_out_r);

END rtl;
--******************************************************************************