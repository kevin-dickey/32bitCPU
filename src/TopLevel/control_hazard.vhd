library IEEE;
use IEEE.std_logic_1164.all;

entity control_hazard is
	port(i_opcode, i_func		
		: in std_logic_vector(5 downto 0);
	o_control_hazard
		: out std_logic);

end control_hazard;

architecture dataflow of control_hazard is
begin
	o_control_hazard <= '1' when ((i_opcode = "000100") or (i_opcode = "000101"))	
				else '0';
	

end dataflow;
