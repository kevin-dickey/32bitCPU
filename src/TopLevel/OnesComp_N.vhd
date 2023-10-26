---------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
---------------------------------------------------------------------------
-- OnesComp_N.vhd
---------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N bit wide one's
-- complementor in structural VHDL.
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity OnesComp_N is
	generic(N : integer := 32);
	port(i_In	: in std_logic_vector(N-1 downto 0);
	     o_Out	: out std_logic_vector(N-1 downto 0));
end OnesComp_N;

architecture structure of OnesComp_N is


component invg is
   port(i_A	: in std_logic;
	o_F	: out std_logic);
end component;

begin

-- Instantiate N inverter/NOT gate instances.
   G_N_Invg: for i in 0 to N-1 generate
     InvgI: invg port map(
         i_A      => i_In(i),   -- ith instance's data input hooked up to its own inverter (NOT gate)
         o_F      => o_Out(i));  -- ith instance's data output hooked up to ith data output.
   end generate G_N_Invg;

end structure;