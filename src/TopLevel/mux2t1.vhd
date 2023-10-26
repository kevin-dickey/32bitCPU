-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an 1 bit wide 2:1
-- mux using structural VHDL.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_S	: in std_logic;
       i_D0     : in std_logic;
       i_D1     : in std_logic;
       o_O      : out std_logic);

end mux2t1;

architecture structure of mux2t1 is

   component invg is
      port(i_A	: in std_logic;
           o_F	: out std_logic);
   end component;

   component andg2 is
      port(i_A	: in std_logic;
           i_B	: in std_logic;
           o_F	: out std_logic);
   end component;

   component org2 is
      port(i_A	: in std_logic;
	   i_B	: in std_logic;
	   o_F	: out std_logic);
   end component;


--------------------------------------------------------------
-- Intermediate signal wires, s_Inv is for negated signal wire
--			      s_W0 is for ~S & D0 wire
--			      s_W1 is for S & D1 wire
--------------------------------------------------------------
   signal s_Inv, s_W0, s_W1 : std_logic;


begin

---------------------
-- Setup the gates --
---------------------

g_NotS: invg
   port MAP(i_A		=> i_S,
	    o_F		=> s_Inv);

g_And1: andg2
   port MAP(i_A		=> i_D0,
            i_B		=> s_Inv,
	    o_F		=> s_W0);

g_And2: andg2
   port MAP(i_A		=> i_D1,
            i_B		=> i_S,
	    o_F		=> s_W1);

g_Or: org2
   port MAP(i_A		=> s_W0,
	    i_B		=> s_W1,
 	    o_F		=> o_O);

end structure;












