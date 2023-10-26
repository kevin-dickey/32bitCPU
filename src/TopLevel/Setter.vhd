library IEEE;
use IEEE.std_logic_1164.all;

entity Setter is

port(i_A : in std_logic;
	 o_F : out std_logic);

end Setter;

architecture dataflow of Setter is 
begin
	o_F <= i_A;	

end dataflow;