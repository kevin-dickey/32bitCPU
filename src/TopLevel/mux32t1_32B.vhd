-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- mux32t1_32B.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of a
-- 32-bit 32:1 MUX. 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.bus_array_type.all;

entity mux32t1_32B is
	port(i_S	: in std_logic_vector(4 downto 0);
		 i_In	: in bus_array;							-- 32 32-bit buses, each index references a 32-bit register
		 o_O	: out std_logic_vector(31 downto 0));
													
end mux32t1_32B;

architecture dataflow of mux32t1_32B is

	begin

	with i_S select o_O <=
		i_In(0) when "00000",  
		i_In(1) when "00001",
		i_In(2) when "00010",
		i_In(3) when "00011",
		i_In(4) when "00100",
		i_In(5) when "00101",
		i_In(6) when "00110",
		i_In(7) when "00111",
		i_In(8) when "01000",
		i_In(9) when "01001",
		i_In(10) when "01010",
		i_In(11) when "01011",
		i_In(12) when "01100",
		i_In(13) when "01101",
		i_In(14) when "01110",
		i_In(15) when "01111",
		i_In(16) when "10000",
		i_In(17) when "10001",
		i_In(18) when "10010",
		i_In(19) when "10011",
		i_In(20) when "10100",
		i_In(21) when "10101",
		i_In(22) when "10110",
		i_In(23) when "10111",
		i_In(24) when "11000",
		i_In(25) when "11001",
		i_In(26) when "11010",
		i_In(27) when "11011",
		i_In(28) when "11100",
		i_In(29) when "11101",
		i_In(30) when "11110",
		i_In(31) when "11111",
		"00000000000000000000000000000000" when others;

end dataflow;



