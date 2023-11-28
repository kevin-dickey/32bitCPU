library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity ID_EX is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegEx          : in std_logic;
       o_MemtoRegEx          : out std_logic;
       i_RegWriteEx          : in std_logic;
       o_RegWriteEx          : out std_logic;

       i_memWriteEx          : in std_logic;
       o_memWriteEx          : out std_logic;
       i_memReadEx          : in std_logic;
       o_memReadEx          : out std_logic;

       i_branchEx          : in std_logic;
       o_branchEx          : out std_logic;
       i_zero          : in std_logic;
       o_zero          : out std_logic;	
       i_jumpEx          : in std_logic;
       o_jumpEx          : out std_logic;
       i_AluSrcEx          : in std_logic;
       o_AluSrcEx          : out std_logic;
       i_ctlEx          : in std_logic;
       o_ctlEx          : out std_logic;
       i_jLinkEX          : in std_logic;
       o_jLinkEX          : out std_logic;
       i_jRegEX          : in std_logic;
       o_jRegEX          : out std_logic;

	i_SoZEx	: in std_logic;
	o_SoZEx : out std_logic;


       i_halt          : in std_logic;
       o_halt          : out std_logic;

       i_Reg1          : in std_logic_vector(31 downto 0);
       o_Reg1          : out std_logic_vector(31 downto 0);
       i_Reg2          : in std_logic_vector(31 downto 0);
       o_Reg2          : out std_logic_vector(31 downto 0);

       i_PCEX          : in std_logic_vector(31 downto 0);
       o_PCEX          : out std_logic_vector(31 downto 0);

       i_signExtend          : in std_logic_vector(31 downto 0);
       o_signExtend          : out std_logic_vector(31 downto 0);

       i_InstALU          : in std_logic_vector(31 downto 0);
       o_InstALU          : out std_logic_vector(31 downto 0);

       i_rs          : in std_logic_vector(4 downto 0);
       o_rs          : out std_logic_vector(4 downto 0);     
       i_rt          : in std_logic_vector(4 downto 0);
       o_rt          : out std_logic_vector(4 downto 0); 

       i_rd          : in std_logic_vector(4 downto 0);
       o_rd          : out std_logic_vector(4 downto 0);

	i_stall		: in std_logic);
       
end ID_EX;

-- architecture
architecture mixed of ID_EX is
	
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

	component mux2t1 is
		port(i_S	: in std_logic;
     		 i_D0     : in std_logic;
      		 i_D1     : in std_logic;
      		 o_O      : out std_logic);
	end component;


  signal s_RST_data : std_logic_vector(31 downto 0) := x"00400000";
  signal s_Q : std_logic_vector(31 downto 0);

begin

	

--with i_RST select 
--	s_Q <= s_RST_data when '1',
--	       i_D	  when '0',
--               x"00000000" when others;

  dffWBReg: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_MemtoRegEx,
		o_Q	=> o_MemtoRegEx);

  dffWBWrite: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_RegWriteEx,
		o_Q	=> o_RegWriteEx);

  dffMWrite: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_memWriteEx,
		o_Q	=> o_memWriteEx);

  dffMRead: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_memReadEx,
		o_Q	=> o_memReadEx);

  dffEXBranch: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_branchEx,
		o_Q	=> o_branchEx);

  dffEXZero: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_zero,
		o_Q	=> o_zero);

  dffEXJump: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_jumpEx,
		o_Q	=> o_jumpEx);

  dffEXAluSrc: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_AluSrcEx,
		o_Q	=> o_AluSrcEx);

  dffEXctl: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_ctlEx,
		o_Q	=> o_ctlEx);

  dffEXjLink: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_jLinkEX,
		o_Q	=> o_jLinkEX);

  dffEXjReg: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_jRegEX,
		o_Q	=> o_jRegEX);

  dffHalt: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_halt,
		o_Q	=> o_halt);

  dffSoZExtend: dffg
	port MAP(i_CLK	=> i_CLK,
		i_RST	=> i_RST,
		i_WE	=> i_stall,
		i_D	=> i_SoZEx,
		o_Q	=> o_SoZEx);

  Reg1Reg: reg_N
	port MAP(i_In	=> i_Reg1,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_Reg1);

  Reg2Reg: reg_N
	port MAP(i_In	=> i_Reg2,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_Reg2);

  RegInstruct: reg_N
	port MAP(i_In	=> i_InstALU,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_InstALU);

  RegPCEX: reg_N
	port MAP(i_In	=> i_PCEX,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_PCEX);

  RegSignExt: reg_N
	port MAP(i_In	=> i_signExtend,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_signExtend);

  RegRd: reg_N
  	generic map(N => 5)
	port MAP(i_In	=> i_rd,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_rd);

  RegRs: reg_N
  	generic map(N => 5)
	port MAP(i_In	=> i_rs,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_rs);

  RegRt: reg_N
  	generic map(N => 5)
	port MAP(i_In	=> i_rt,
		i_Clk	=> i_CLK,
		i_WrEn	=> i_stall,
		i_Reset	=> i_RST,
		o_Out	=> o_rt);

end architecture;
