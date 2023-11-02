-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a register file intended for use with
-- MIPS. 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.bus_array_type.all;

entity register_file is
	generic(N : integer := 32);
	port(i_WrAddr 	: in std_logic_vector(4 downto 0);	  -- write port; chooses which single 32-bit register to write to
		 i_WrEnable	: in std_logic;						  -- enables the write port (5:32 decoder) to update register referenced at i_Wr with data
		 i_Data  	: in std_logic_vector(31 downto 0);   -- data to be written 
		 i_CLK		: in std_logic;
		 i_Rst  	: in std_logic;
		 i_RAddr1 	: in std_logic_vector(4 downto 0);
		 i_RAddr2 	: in std_logic_vector(4 downto 0);
		 o_Rd1	 	: out std_logic_vector(31 downto 0);  -- read port 1
		 o_Rd2	 	: out std_logic_vector(31 downto 0)); -- read port 2

end register_file;

architecture structural of register_file is

	component reg_N is
		generic(N : integer := 32);
		port(i_In		: in std_logic_vector(N-1 downto 0);		-- N-bit input
		 	 i_Clk		: in std_logic;								-- Clock signal, synchronous for all DFFs in N-bit register
		 	 i_WrEn		: in std_logic;								-- Write enable (0 if reading), synchronous for all DFFs in N-bit register
			 i_Reset	: in std_logic;								-- Reset signal, synchronous for all DFFs in N-bit register
			 o_Out		: out std_logic_vector(N-1 downto 0));		-- N-bit output
	end component;

	component decoder_5_32 is
		port(i_S	: in std_logic_vector(4 downto 0);
		 	 i_En	: in std_logic;							-- not super necessary, should connect to i_WrEn on register file
		 	 o_O	: out std_logic_vector(31 downto 0));
	end component;

	component mux32t1_32B is
		port(i_S	: in std_logic_vector(4 downto 0);
			 i_In	: in bus_array;							-- 32 32-bit buses, each index references a 32-bit register
			 o_O	: out std_logic_vector(31 downto 0));
	end component;

	signal s_regSelectLines : std_logic_vector(31 downto 0); -- for the decoder
	signal s_regOutput		: bus_array; -- lines running from registers to read ports

begin

	-- Instantiate the zero register, will always hold the value 0
	g_zeroRegister: reg_N	
		port MAP(i_In	 => i_Data,	-- essentially redundant, will never have any effect on value stored in this register
				 i_Clk	 => i_CLK,
				 i_WrEn	 => s_regSelectLines(0),
				 i_Reset => '1',	-- will always be continuously reset to 0, will NOT jump/oscillate for nanoseconds to input data b/c of structure of dffg_falling.vhd (asynch. reset & if statement structure)
				 o_Out	 => s_regOutput(0));

	-- Instantiate N (31) 32-bit registers.
	G_NRegisters: for i in 1 to N-1 generate	
		REGi: reg_N port map(
						i_In	=> i_Data,
						i_Clk	=> i_CLK,
						i_WrEn	=> s_regSelectLines(i),
						i_Reset	=> i_Rst,
						o_Out	=> s_regOutput(i));
	end generate G_NRegisters;

	g_decoder_5_32: decoder_5_32
		port MAP(i_S	=> i_WrAddr,
				 i_En	=> i_WrEnable,
				 o_O	=> s_regSelectLines);

	g_readPortOne: mux32t1_32B
		port MAP(i_S	=> i_RAddr1,
				 i_In	=> s_regOutput,
				 o_O	=> o_Rd1);

	g_readPortTwo: mux32t1_32B
		port MAP(i_S	=> i_RAddr2,
				 i_In	=> s_regOutput,
				 o_O	=> o_Rd2);

end structural;











