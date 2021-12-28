--****************************************************************************** 
-- Module   : mux_2_way
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 28-Dec-2021
--******************************************************************************
-- Description:
-- ============
-- Variable width 2-way multiplexer.
--******************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_2_way IS 
  GENERIC (
    MUX_WIDTH_g : INTEGER := 8 
  );
  PORT (
    sel_in  : IN STD_LOGIC;
    a_in    : IN STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0);
    b_in    : IN STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0);

    val_out : OUT STD_LOGIC_VECTOR(MUX_WIDTH_g-1 DOWNTO 0)
  );
END mux_2_way;

--******************************************************************************
ARCHITECTURE behavioral OF mux_2_way IS 
BEGIN

  val_out <= b_in WHEN sel_in = '1' ELSE
             a_in; 

END behavioral;
--******************************************************************************