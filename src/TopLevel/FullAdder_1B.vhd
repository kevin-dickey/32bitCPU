-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- FullAdder_1B.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1 bit wide full
-- adder in structural VHDL.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdder_1B is 
	port(i_op1		: in std_logic;
		 i_op2		: in std_logic;
		 i_carryIn	: in std_logic;
		 o_sum		: out std_logic;
		 o_carryOut : out std_logic);
end FullAdder_1B;

architecture structure of FullAdder_1B is

	component andg2 is
		port(i_A	: in std_logic;
			i_B		: in std_logic;
			o_F		: out std_logic);
	end component;

    component org2 is
        port(i_A	: in std_logic;
	        i_B		: in std_logic;
	        o_F		: out std_logic);
    end component;

	component xorg2 is
		port(i_A	: in std_logic;
			 i_B	: in std_logic;
			 o_F	: out std_logic);
	end component;

--------------------------------------------------------------
--	Intermediate signal wires

-- Signal wire following first XOR gate
    signal s_xor1	: std_logic;

-- Signal wire following second XOR gate
    signal s_xor2	: std_logic;

-- Signal wire following first AND gate
    signal s_and1	: std_logic;

-- Signal wire following second AND gate
    signal s_and2	: std_logic;

--------------------------------------------------------------

begin

----------------------
--	Setup the gates --
----------------------

g_Xor1: xorg2
	port MAP(i_A	=> i_op1,
			 i_B	=> i_op2,
			 o_F	=> s_xor1);

g_Xor2: xorg2
	port MAP(i_A	=> s_xor1,
			 i_B	=> i_carryIn,
			 o_F	=> o_sum);

g_And1: andg2
	port MAP(i_A 	=> i_op1,
			 i_B	=> i_op2,
			 o_F	=> s_and1);

g_And2: andg2
	port MAP(i_A 	=> s_xor1,
			 i_B	=> i_carryIn,
			 o_F	=> s_and2);

g_Or1: org2
	port MAP(i_A	=> s_and2,
			 i_B	=> s_and1,
			 o_F	=> o_carryOut);

end structure;
















