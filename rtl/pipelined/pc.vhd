--------------------------------------------------------------------------------
-- Module   : pc_tb
-- Project  : FRiscV
-- Author   : Tom Szymkowiak
-- Mod. Date: 07-Feb-2022
--------------------------------------------------------------------------------
-- Description:
-- ============
-- Testbench for pipelined pc
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.friscv_pkg.all;

entity pc is 
  port(
    clk        : in  std_logic;
    rst_n      : in  std_logic;
    pc_src_in  : in  std_logic_vector(1 downto 0);
    alt_pc_in  : in  std_logic_vector(XLEN-1 downto 0);

    pc_out     : out std_logic_vector(XLEN-1 downto 0);
    pc_nxt_out : out std_logic_vector(XLEN-1 downto 0)
  );
end entity pc;

--------------------------------------------------------------------------------

architecture rtl of pc is 

  component mux_4_way is
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
  end component mux_4_way;


  signal pc_r, pc_a_s, 
         pc_b_s           : unsigned(XLEN-1 downto 0);            
  signal pc_int_s,
         exception_addr_s : std_logic_vector(XLEN-1 downto 0);

begin  -------------------------------------------------------------------------

  i_pc_src_mux : mux_4_way
    generic map (
      MUX_WIDTH => XLEN
    )
    port map(
      sel_in  => pc_src_in, 
      a_in    => std_logic_vector(pc_a_s),
      b_in    => std_logic_vector(pc_b_s), 
      c_in    => std_logic_vector(to_unsigned(XLEN_BYTES, XLEN)),
      d_in    => (others => '0'), 
      val_out => pc_int_s    
    );

  sync_pc : process(clk) is                                    ----------
  begin 

    if rising_edge(clk) then

      if rst_n = '0' then  -- synch reset
        pc_r <= (others => '0'); 
      else
        pc_r <= unsigned(pc_int_s);
      end if;

    end if;

  end process sync_pc;                                                ----------

  pc_a_s <= pc_r + unsigned(alt_pc_in);
  pc_b_s <= pc_r + to_unsigned(XLEN_BYTES, XLEN);

  exception_addr_s <= EXCEPTION_ADDRESS; -- defined in friscv_pkg

end architecture rtl;

--------------------------------------------------------------------------------

