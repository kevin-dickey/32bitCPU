library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Project1_xor is
  port(i_1    : in std_logic_vector(31 downto 0);
    i_2    : in std_logic_vector(31 downto 0);
    o_q    : out std_logic_vector(31 downto 0));
end Project1_xor;

architecture behavior of Project1_xor is
begin
process(i_1, i_2) is
begin

o_q(0) <= i_1(0) xor i_2(0);
o_q(1) <= i_1(1) xor i_2(1);
o_q(2) <= i_1(2) xor i_2(2);
o_q(3) <= i_1(3) xor i_2(3);
o_q(4) <= i_1(4) xor i_2(4);
o_q(5) <= i_1(5) xor i_2(5);
o_q(6) <= i_1(6) xor i_2(6);
o_q(7) <= i_1(7) xor i_2(7);
o_q(8) <= i_1(8) xor i_2(8);
o_q(9) <= i_1(9) xor i_2(9);
o_q(10) <= i_1(10) xor i_2(10);
o_q(11) <= i_1(11) xor i_2(11);
o_q(12) <= i_1(12) xor i_2(12);
o_q(13) <= i_1(13) xor i_2(13);
o_q(14) <= i_1(14) xor i_2(14);
o_q(15) <= i_1(15) xor i_2(15);
o_q(16) <= i_1(16) xor i_2(16);
o_q(17) <= i_1(17) xor i_2(17);
o_q(18) <= i_1(18) xor i_2(18);
o_q(19) <= i_1(19) xor i_2(19);
o_q(20) <= i_1(20) xor i_2(20);
o_q(21) <= i_1(21) xor i_2(21);
o_q(22) <= i_1(22) xor i_2(22);
o_q(23) <= i_1(23) xor i_2(23);
o_q(24) <= i_1(24) xor i_2(24);
o_q(25) <= i_1(25) xor i_2(25);
o_q(26) <= i_1(26) xor i_2(26);
o_q(27) <= i_1(27) xor i_2(27);
o_q(28) <= i_1(28) xor i_2(28);
o_q(29) <= i_1(29) xor i_2(29);
o_q(30) <= i_1(30) xor i_2(30);
o_q(31) <= i_1(31) xor i_2(31);

end process;
 
end behavior;

