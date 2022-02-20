--------------------------------------------------------------------------------
-- Module   : mux_4_way
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 20-FEB-2022
--------------------------------------------------------------------------------
-- Description:
-- ============
-- Variable width 4-way multiplexer.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.friscv_vhdl_pkg.all;

entity mux_4_way is
  generic(
    MUX_WIDTH : integer := 8
  );
  port (
    sel_in  : in  std_logic_vector(1 downto 0);   
    a_in    : in  std_logic_vector(MUX_WIDTH-1 downto 0);
    b_in    : in  std_logic_vector(MUX_WIDTH-1 downto 0);
    c_in    : in  std_logic_vector(MUX_WIDTH-1 downto 0);
    d_in    : in  std_logic_vector(MUX_WIDTH-1 downto 0);

    val_out : out std_logic_vector(MUX_WIDTH-1 downto 0)     
  );
end entity mux_4_way;

--------------------------------------------------------------------------------

architecture rtl of mux_4_way is
begin 

  val_out <= b_in when sel_in = "01" else
             c_in when sel_in = "10" else
             d_in when sel_in = "11" else
             (others => '0'); 

end architecture rtl;

--------------------------------------------------------------------------------