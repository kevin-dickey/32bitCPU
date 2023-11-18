library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity MEM_WB is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegM          : in std_logic;
       o_MemtoRegM          : out std_logic;
       i_RegWriteM          : in std_logic;
       o_RegWriteM          : out std_logic;

       i_memWriteM          : in std_logic;
       o_memWriteM          : out std_logic;
       i_memReadM          : in std_logic;
       o_memReadM          : out std_logic;

       i_halt          : in std_logic;
       o_halt          : out std_logic;
       i_jLinkM          : in std_logic;
       o_jLinkM          : out std_logic;
       i_OverflowM          : in std_logic;
       o_OverflowM          : out std_logic;

	i_stall		: in std_logic;

       i_PCM          : in std_logic_vector(31 downto 0);
       o_PCM          : out std_logic_vector(31 downto 0);

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_ALU2          : in std_logic_vector(31 downto 0);
       o_ALU2          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(4 downto 0);
       o_Inst          : out std_logic_vector(4 downto 0));
       
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

  dffMemtoReg: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> '1',
		i_D	=> i_MemtoRegM,
		o_Q	=> o_MemtoRegM);

  dffRegWrite: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_RegWriteM,
		o_Q	=> o_RegWriteM);

  dffmemWrite: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_memWriteM,
		o_Q	=> o_memWriteM);

  dffmemRead: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_memReadM,
		o_Q	=> o_memReadM);

  dffHaltEX: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_halt,
		o_Q	=> o_halt);


  dffjLinkEX: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_jLinkM,
		o_Q	=> o_jLinkM);

  dffOverEX: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_OverflowM,
		o_Q	=> o_OverflowM);

  RegPCWB: reg_N
	port MAP(i_In	=> i_PCM,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> '0',
		o_Out	=> o_PCM);

  RegSignALU: reg_N
	port MAP(i_In	=> i_ALU,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> '0',
		o_Out	=> o_ALU);

  RegSignALU2: reg_N
	port MAP(i_In	=> i_ALU2,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> '0',
		o_Out	=> o_ALU2);

  RegInst: reg_N
  	generic map(N => 5)
	port MAP(i_In	=> i_Inst,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> '0',
		o_Out	=> o_Inst);

end architecture;
