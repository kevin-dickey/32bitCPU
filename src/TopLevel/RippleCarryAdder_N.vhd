-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- RippleCarryAdder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit wide 
-- ripple carry adder in structural VHDL.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity RippleCarryAdder_N is
	generic(N : integer := 32); -- Default 32-bit ripple carry adder is setup.
	port(i_op1		: in std_logic_vector(N-1 downto 0);
		 i_op2		: in std_logic_vector(N-1 downto 0);
		 i_carryIn	: in std_logic;
		 o_sum		: out std_logic_vector(N-1 downto 0);
		 o_CarryOut : out std_logic;
		 o_overflow : out std_logic);
end RippleCarryAdder_N;

architecture structure of RippleCarryAdder_N is
	
	component FullAdder_1B is
		port(i_op1		: in std_logic;
			 i_op2		: in std_logic;
			 i_carryIn	: in std_logic;
			 o_sum		: out std_logic;
			 o_carryOut	: out std_logic);
	end component;

	component xorg2 is
		port(i_A          : in std_logic;
       		 i_B          : in std_logic;
       		 o_F          : out std_logic);
	end component;

	signal s_internalCarry : std_logic_vector(N-1 downto 0);
	signal s_ovfl	: std_logic;

begin

	-- Instantiate first FA, as it is setup slightly different from others
	g_FA0: FullAdder_1B
		port MAP(i_op1		=>	i_op1(0),
				 i_op2		=>	i_op2(0),
				 i_carryIn	=>	i_carryIn,
				 o_sum		=>	o_sum(0),
				 o_carryOut	=>	s_internalCarry(0));

	-- Instantiate N-1 1-bit full adders.
	G_NBit_FA: for i in 1 to N-1 generate		-- maybe change to: 0 to N-2, test first
		FAI: FullAdder_1B port map(
				i_op1		=>	i_op1(i),
				i_op2		=>	i_op2(i),
				i_carryIn	=>	s_internalCarry(i-1),
				o_sum		=> 	o_sum(i),
				o_carryOut	=>	s_internalCarry(i));
	end generate G_NBit_FA;

	g_XOR: xorg2
		port MAP(i_A	=> s_internalCarry(30),
			 i_B	=> s_internalCarry(31),
			 o_F	=> s_ovfl); 

	o_overflow <= s_ovfl;
	o_CarryOut <= s_internalCarry(31);
	

end structure;










