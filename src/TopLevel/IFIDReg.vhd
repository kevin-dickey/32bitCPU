library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity iF_ID is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PCP4          : in std_logic_vector(31 downto 0);     -- Data value input
       o_PCP4          : out std_logic_vector(31 downto 0);
       i_imem          : in std_logic_vector(31 downto 0);
       o_imem          : out std_logic_vector(31 downto 0);
       i_stall		: in std_logic);
end iF_ID;

-- architecture
architecture mixed of iF_ID is
	
  component reg_N is
	generic(N : integer := 32);		-- set to 32-bit by default
	port(i_In		: in std_logic_vector(N-1 downto 0);		-- N-bit input
		 i_Clk		: in std_logic;								
	 	 i_WrEn		: in std_logic;								
		 i_Reset	: in std_logic;								
		 o_Out		: out std_logic_vector(N-1 downto 0));
  end component;

  signal s_RST_data : std_logic_vector(31 downto 0) := x"00400000";
  signal s_Q : std_logic_vector(31 downto 0);

begin

--with i_RST select 
--	s_Q <= s_RST_data when '1',
--	       i_D	  when '0',
--               x"00000000" when others;

   
  PCP4Reg: reg_N
	port MAP(i_In	=> i_PCP4,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_PCP4);

  ImemReg: reg_N
	port MAP(i_In	=> i_imem,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_imem);



end architecture;
