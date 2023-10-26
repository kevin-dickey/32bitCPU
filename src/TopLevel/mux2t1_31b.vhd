library IEEE;
use IEEE.std_logic_1164.all;
entity mux2t1_31b is

  port(i_S	: in std_logic;
       i_D0     : in std_logic_vector(31 downto 0);
       i_D1     : in std_logic_vector(31 downto 0);
       o_O      : out std_logic_vector(31 downto 0));

end mux2t1_31b;

architecture behavior of mux2t1_31b is

begin
process(i_S) is
begin

if i_S = '0' then
	o_O <= i_D0;
else
	o_O <= i_D1;
end if;
end process;
 
end behavior;












