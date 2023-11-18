library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity MIPS_pc is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
--       i_PC_stall   : in std_logic;
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end MIPS_pc;

-- architecture
architecture mixed of MIPS_pc is
	
  component reg_N is
	generic(N : integer := 32);		-- set to 32-bit by default
	port(i_In		: in std_logic_vector(N-1 downto 0);		-- N-bit input
		 i_Clk		: in std_logic;								
	 	 i_WrEn		: in std_logic;								
		 i_Reset	: in std_logic;								
		 o_Out		: out std_logic_vector(N-1 downto 0));		-- N-bit output
  end component;

  signal s_RST_data : std_logic_vector(31 downto 0) := x"00400000";
  signal s_Q : std_logic_vector(31 downto 0);

begin

with i_RST select 
	s_Q <= s_RST_data when '1',
	       i_D	  when '0',
               x"00000000" when others;

   
  PC: reg_N
	port MAP(i_In	=> s_Q,
		i_Clk	=> i_CLK,
		i_WrEn	=> '1',
		i_Reset	=> '0',
		o_Out	=> o_Q);

end architecture;
