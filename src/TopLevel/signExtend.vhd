library IEEE;
use IEEE.std_logic_1164.all;

entity signExtend is

  port(i_A          : in std_logic_vector(15 downto 0);
	i_sign		: in std_logic;
       o_F          : out std_logic_vector(31 downto 0));

end signExtend;

architecture structure of signExtend is
begin
process(i_sign, i_A)
begin
case(i_sign) is
	when '0' => 
		case(i_A(15)) is
		when '1' =>
			o_F <= x"FFFF" & i_A;
		when others =>
			o_F <= x"0000" & i_A;
		end case;

	when others =>
		o_F <= x"0000" & i_A;
end case;

end process;
end structure;

