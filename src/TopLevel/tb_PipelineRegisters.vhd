library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
use IEEE.numeric_std.all;	-- For to_usnigned
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

--use work.STD_LOGIC_MATRIX.all;

entity tb_PipelineRegisters is
  generic(gCLK_HPER   : time := 50 ns);
end tb_PipelineRegisters;

architecture behavior of tb_PipelineRegisters is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


component iF_ID is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PCP4          : in std_logic_vector(31 downto 0);     -- Data value input
       o_PCP4          : out std_logic_vector(31 downto 0);
       i_imem          : in std_logic_vector(31 downto 0);
       o_imem          : out std_logic_vector(31 downto 0);
       i_stall	       : in std_logic;
       i_pc_stall	: in std_logic;
       o_pc_stall	: out std_logic);
end component;


component ID_EX is
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

       i_halt          : in std_logic;
       o_halt          : out std_logic;

	i_SoZEx		: in std_logic;
	o_SoZEx 	: out std_logic;

       i_Reg1          : in std_logic_vector(31 downto 0);
       o_Reg1          : out std_logic_vector(31 downto 0);
       i_Reg2          : in std_logic_vector(31 downto 0);
       o_Reg2          : out std_logic_vector(31 downto 0);

       i_PCEX          : in std_logic_vector(31 downto 0);
       o_PCEX          : out std_logic_vector(31 downto 0);

       i_signExtend          : in std_logic_vector(31 downto 0);
       o_signExtend          : out std_logic_vector(31 downto 0);

	i_InstALU		: in std_logic_vector(31 downto 0);
	o_InstALU		: out std_logic_vector(31 downto 0);

       i_rs          : in std_logic_vector(4 downto 0);
       o_rs          : out std_logic_vector(4 downto 0);     
       i_rt          : in std_logic_vector(4 downto 0);
       o_rt          : out std_logic_vector(4 downto 0); 

       i_rd          : in std_logic_vector(4 downto 0);
       o_rd          : out std_logic_vector(4 downto 0);
	
	i_stall		: in std_logic);
       
end component;

component MEM_WB is
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
	--i_stall			: in std_logic;


       i_PCM          : in std_logic_vector(31 downto 0);
       o_PCM          : out std_logic_vector(31 downto 0);

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_ALU2          : in std_logic_vector(31 downto 0);
       o_ALU2          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(4 downto 0);
       o_Inst          : out std_logic_vector(4 downto 0));
       
end component;

component EX_MEM is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegWB          : in std_logic;
       o_MemtoRegWB          : out std_logic;
       i_RegWriteWB          : in std_logic;
       o_RegWriteWB          : out std_logic;

       i_halt          : in std_logic;
       o_halt          : out std_logic;
       i_jLinkWB          : in std_logic;
       o_jLinkWB          : out std_logic;
       i_OverflowWB          : in std_logic;
       o_OverflowWB          : out std_logic;

       i_PCWB          : in std_logic_vector(31 downto 0);
       o_PCWB          : out std_logic_vector(31 downto 0);

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_Dmem          : in std_logic_vector(31 downto 0);
       o_Dmem          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(4 downto 0);
       o_Inst          : out std_logic_vector(4 downto 0));
       
end component;

  signal s_IF_ID_stall : std_logic := '1';
  signal s_InstEX : std_logic_vector(31 downto 0);
  signal s_Inst         : std_logic_vector(31 downto 0); -- TODO: use this signal as the instruction signal 
  signal s_IF_ID_flush : std_logic := '1';  
  signal s_ID_EX_flush_not : std_logic := '0'; -- flush regularly active low, this signal goes into pipeline regs as active high
  signal s_PC_stallF : std_logic;
  signal iCLK : std_logic := '0';
  signal s_IF_ID_flush_not : std_logic := '0';
  signal s_InstF : std_logic_vector(31 downto 0);
  signal s_PC_stall	: std_logic := '0';

  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(31 downto 0); -- TODO: use this signal as the final data memory data input


  --Fetch/pc signals
  signal s_new_and_improved_flushy : std_logic_vector(31 downto 0);
  signal s_PC : std_logic_vector(31 downto 0);
  signal s_PC4 : std_logic_vector(31 downto 0);
  signal s_jumpAddress : std_logic_vector(31 downto 0);
  signal s_PCi : std_logic_vector(31 downto 0);
  signal Temp1 : std_logic_vector(31 downto 0);
  signal ALUaddress : std_logic_vector(31 downto 0);
  signal jumpAddress : std_logic_vector(31 downto 0);
  signal s_PCB4 : std_logic_vector(31 downto 0);
  signal s_jmpStrt : std_logic := '0';
  signal s_nRST : std_logic;
  signal s_newPC : std_logic_vector(31 downto 0);
  signal s_dummyInst : std_logic_vector(31 downto 0);
  signal s_NxtInstAddrMinusFour : std_logic_vector(31 downto 0);


--D control signals
  signal s_HaltD : std_logic;

  signal s_ALU1D : std_logic_vector(31 downto 0);
  signal s_ALU2D : std_logic_vector(31 downto 0);
  signal s_RegWrAddrD : std_logic_vector(4 downto 0);

  signal s_MemtoRegD : std_logic;
  signal s_RegWrD : std_logic;
  signal s_RegWrD1 : std_logic;
  signal s_DMemWrD : std_logic;
  signal s_DMemWrD1 : std_logic;
  signal s_MemReadD : std_logic;
  signal s_BranchD : std_logic;
  signal s_JumpD : std_logic;
  signal s_ALUSrcD : std_logic;
  signal s_jLinkD : std_logic;
  signal s_jRegD : std_logic;
  signal s_ctlD : std_logic;
  signal s_zeroD : std_logic;

  --Ex control signals
  signal s_BranchEx : std_logic := '0';
  signal s_JumpEx : std_logic := '0';
  signal s_ALuSrcEx : std_logic;
  signal s_MemtoRegEx : std_logic;
  signal s_RegWriteEx : std_logic;
  signal s_memWriteEx : std_logic;
  signal s_memReadEx : std_logic;
  signal s_HaltEx : std_logic;
  signal s_ctlEX : std_logic;
  signal s_jLinkEX : std_logic;
  signal s_jRegEX : std_logic;
  signal s_OverflowEx : std_logic;
  signal s_rsEx : std_logic_vector(4 downto 0);
  signal s_rtEx : std_logic_vector(4 downto 0);
  signal s_rdEx : std_logic_vector(4 downto 0);
  signal s_SignExtendedEx : std_logic_vector(31 downto 0);
  signal s_PCEX : std_logic_vector(31 downto 0);
  signal s_SoZextendEx : std_logic;
  signal s_zeroEx : std_logic;

  --M control signals
  signal s_MemtoRegM : std_logic;
  signal s_RegWriteM : std_logic;
  signal s_memWriteM : std_logic;
  signal s_HaltM : std_logic;
  signal s_jLinkM : std_logic;
  signal s_OverflowM : std_logic;
  signal s_ALUM : std_logic_vector(31 downto 0);
  signal s_WriteDataM : std_logic_vector(31 downto 0);
  signal s_InstM : std_logic_vector(4 downto 0);
  signal s_PCM : std_logic_vector(31 downto 0);

  --WB control signals
  signal s_MemtoRegWB : std_logic;
  signal s_jLinkWB : std_logic;
--  signal s_RegWriteWB : std_logic;
  signal s_ALUWB : std_logic_vector(31 downto 0);
  signal s_DMemOutWB : std_logic_vector(31 downto 0);
--  signal s_InstWB : std_logic_vector(4 downto 0);
  signal s_PCWB : std_logic_vector(31 downto 0);


begin

IFID: iF_ID 
  port map(i_CLK => iCLK,
       i_RST => s_IF_ID_flush_not or (not s_PC_stallF),
       i_PCP4 => s_PC4,
       o_PCP4 => s_PC,
       i_imem => s_Inst,
       o_imem => s_InstF,
       i_stall => s_IF_ID_stall,
       i_pc_stall => s_PC_stall,
       o_pc_stall => s_PC_stallF);

IDEX: ID_EX
  port map(i_CLK => iCLK,
       i_RST => s_ID_EX_flush_not,

       i_MemtoRegEx => '0',
       o_MemtoRegEx => open,
       i_RegWriteEx => s_RegWrD,
       o_RegWriteEx => s_RegWriteEx,

       i_memWriteEx => '0',
       o_memWriteEx => open,
       i_memReadEx => '0',
       o_memReadEx => open,

       i_branchEx => '0',
       o_branchEx => open,
       i_zero => '0',
       o_zero => open,
       i_jumpEx => '0',
       o_jumpEx => open,
       i_AluSrcEx => '0',
       o_AluSrcEx => open,
       i_ctlEx => '0',
       o_ctlEx => open,
       i_jLinkEX => '0',
       o_jLinkEX => open,
       i_jRegEX => '0',
       o_jRegEX => open,


       i_halt => '0',
       o_halt => open,

	i_SoZEx	=> '0',
	o_SoZEx => open,

       i_Reg1 => x"0",
       o_Reg1 => open,
       i_Reg2 => x"0",
       o_Reg2 => open,

       i_PCEX => x"0",
       o_PCEX => open,

       i_signExtend => x"0",
       o_signExtend => open,

	i_InstALU  => s_InstF,
	o_InstALU  => s_InstEX,	

       i_rs => x"0",
       o_rs => open,
       i_rt => x"0",
       o_rt => open,

       i_rd => s_RegWrAddrD,
       o_rd => s_rdEx,
	
	i_stall => '0');


EXMEM: EX_MEM
  port map(i_CLK => iCLK,
       i_RST => '0',

       i_MemtoRegWB => '0',
       o_MemtoRegWB => open,
       i_RegWriteWB => s_RegWriteM,
       o_RegWriteWB => s_RegWr,

       i_halt => '0',
       o_halt => open,
       i_jLinkWB => '0',
       o_jLinkWB => open,
       i_OverflowWB => '0',
       o_OverflowWB => open,

       i_PCWB => x"0",
       o_PCWB => open,

       i_ALU => x"0",
       o_ALU => open,
       i_Dmem => x"0",
       o_Dmem => open,

       i_Inst => s_InstM,
       o_Inst => s_RegWrAddr);

MEMWB: MEM_WB
  port map(i_CLK => iCLK,
       i_RST => '0',

       i_MemtoRegM => '0',
       o_MemtoRegM => open,
       i_RegWriteM => s_RegWriteEx,
       o_RegWriteM => s_RegWriteM,

       i_memWriteM => '0',
       o_memWriteM => open,
       i_memReadM => '0',
       o_memReadM => open,

       i_halt => '0',
       o_halt => open,
       i_jLinkM => '0',
       o_jLinkM => open,
       i_OverflowM => '0',
       o_OverflowM => open,

	--i_stall		=> s_ID_EX_stall,

       i_PCM => x"0",
       o_PCM => open,

       i_ALU => x"0",
       o_ALU => open,
       i_ALU2 => x"0",
       o_ALU2 => open,

       i_Inst => s_rdEx,
       o_Inst => s_InstM);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    iCLK <= '0';
    wait for gCLK_HPER;
    iCLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- reset all regs to 0 as intial state
--    Write_RST <= '1';
    wait for cCLK_PER;
--    Write_RST <= '0';

	--Resets
	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"1180FFF3";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "11001";
	
	wait for cCLK_PER;

	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"ADCF0000";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "01010";

	wait for cCLK_PER;

	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"21CEFFFC";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "11111";

	wait for cCLK_PER;
	s_IF_ID_flush_not <= '1';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"01105822";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "01010";

	wait for cCLK_PER;
	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"91011121";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "01010";

	wait for cCLK_PER;

  	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '0';
	
	s_ID_EX_flush_not <= '0';

	
	--Values that go through multiple registers
	s_Inst <= x"54723212";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "01010";

	wait for cCLK_PER;

	s_IF_ID_flush_not <= '0';
	s_PC_stallF <= '1';
	
	s_ID_EX_flush_not <= '1';

	
	--Values that go through multiple registers
	s_Inst <= x"76281028";
	s_RegWrD <= '1';
	s_RegWrAddrD <= "01010";

	wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
