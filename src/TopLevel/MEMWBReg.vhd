library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity MEM_WB is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_wb          : in std_logic;
       o_wb          : out std_logic;
       i_m          : in std_logic;
       o_m          : out std_logic;
       i_halt          : in std_logic;
       o_halt          : out std_logic;

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_ALU2          : in std_logic_vector(31 downto 0);
       o_ALU2          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(31 downto 0);
       o_Inst          : out std_logic_vector(31 downto 0));
       
end MEM_WB;

-- architecture
architecture mixed of MEM_WB is
	
  component reg_N is
	generic(N : integer := 32);		-- set to 32-bit by default
	port(i_In		: in std_logic_vector(N-1 downto 0);		-- N-bit input
		 i_Clk		: in std_logic;								
	 	 i_WrEn		: in std_logic;								
		 i_Reset	: in std_logic;								
		 o_Out		: out std_logic_vector(N-1 downto 0));		-- N-bit output
  end component;

	component dffg is
		port(i_CLK        : in std_logic;     -- Clock input
       		 i_RST        : in std_logic;     -- Reset input
       		 i_WE         : in std_logic;     -- Write enable input
       		 i_D          : in std_logic;     -- Data value input
       		 o_Q          : out std_logic);   -- Data value output
	end component;

  signal s_RST_data : std_logic_vector(31 downto 0) := x"00400000";
  signal s_Q : std_logic_vector(31 downto 0);

begin

--with i_RST select 
--	s_Q <= s_RST_data when '1',
--	       i_D	  when '0',
--               x"00000000" when others;

  dffWB: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> '1',
		i_D	=> i_wb,
		o_Q	=> o_wb);

  dffM: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> '1',
		i_D	=> i_m,
		o_Q	=> o_m);

  dffEX: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> '1',
		i_D	=> i_halt,
		o_Q	=> o_halt);

  RegSignALU: reg_N
	port MAP(i_In	=> i_ALU,
		i_Clk	=> i_CLK,
		i_WrEn	=> '1',
		i_Reset	=> '0',
		o_Out	=> o_ALU);

  RegSignALU2: reg_N
	port MAP(i_In	=> i_ALU2,
		i_Clk	=> i_CLK,
		i_WrEn	=> '1',
		i_Reset	=> '0',
		o_Out	=> o_ALU2);

  RegInst: reg_N
	port MAP(i_In	=> i_Inst,
		i_Clk	=> i_CLK,
		i_WrEn	=> '1',
		i_Reset	=> '0',
		o_Out	=> o_Inst);

end architecture;