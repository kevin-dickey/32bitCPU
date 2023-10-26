-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- AdderSubtractor_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit wide 
-- Adder/Subtractor in structural VHDL.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity AdderSubtractor_N is
	generic(N : integer := 32);
	port(i_A			: in std_logic_vector(N-1 downto 0);
		 i_B			: in std_logic_vector(N-1 downto 0);
		 i_nAdd_Sub		: in std_logic;
	 	 o_Sums			: out std_logic_vector(N-1 downto 0);
		 o_Carry_Out	: out std_logic;
		 o_Overflow		: out std_logic;
		 o_Zero			: out std_logic);
end AdderSubtractor_N;

architecture structure of AdderSubtractor_N is
	
	component mux2t1_N is
		generic(N : integer := 32);		-- unsure if necessary
		port(i_S	: in std_logic;
			 i_D0	: in std_logic_vector(N-1 downto 0);
			 i_D1	: in std_logic_vector(N-1 downto 0);
			 o_O	: out std_logic_vector(N-1 downto 0));
	end component;

	component OnesComp_N is
		generic(N : integer := 32);		-- unsure if necessary
		port(i_In	: in std_logic_vector(N-1 downto 0);
			 o_Out	: out std_logic_vector(N-1 downto 0));
	end component;

	component RippleCarryAdder_N is
		generic(N : integer := 32);		-- unsure if necessary
		port(i_op1		: in std_logic_vector(N-1 downto 0);
			 i_op2		: in std_logic_vector(N-1 downto 0);
		 	 i_carryIn	: in std_logic;
		 	 o_sum		: out std_logic_vector(N-1 downto 0);
		 	 o_CarryOut : out std_logic;
			 o_overflow : out std_logic);
	end component;

	-- add 32-bit and gate here

	signal s_invertedB : std_logic_vector(N-1 downto 0);
	signal s_operatorB : std_logic_vector(N-1 downto 0);

begin

	g_NBit_Inveter: OnesComp_N
		port MAP(i_In	=> i_B,
				 o_Out	=> s_invertedB);

	g_NBit_MUX: mux2t1_N
		port MAP(i_S	=> i_nAdd_Sub,
				 i_D0	=> i_B,
				 i_D1	=> s_invertedB,
				 o_O	=> s_operatorB);
	
	g_NBit_RCAdder: RippleCarryAdder_N
		port MAP(i_op1		=> i_A,
			 	 i_op2		=> s_operatorB,
		 	 	 i_carryIn	=> i_nAdd_Sub,
		 		 o_sum		=> o_Sums,
		 	 	 o_CarryOut => o_Carry_Out,
				 o_overflow => o_Overflow);
	
	-- set o_Zero based on output of 32-bit and gate
	process(o_Sums)
	begin
		if (o_Sums = x"00000000") then
			o_Zero <= '1';
		else
			o_Zero <= '0';
	end if;
	end process;


end structure;
