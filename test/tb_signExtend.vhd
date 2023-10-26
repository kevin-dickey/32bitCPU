library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_signExtend is

	--generic(gCLK_HPER	: time := 50ns);
end tb_signExtend;

architecture behavior of tb_signExtend is

--constant cCLK_PER : time := gCLK_HPER * 2;

component signExtend
	port(i_A	: in std_logic_vector(15 downto 0);
		i_sign	: in std_logic;
		o_F	: out std_logic_vector(31 downto 0));
end component;

signal s_1	: std_logic_vector(15 downto 0);
signal ctl	: std_logic;
signal s_q	: std_logic_vector(31 downto 0);

begin
DUT0: signExtend
port map(i_A	=> s_1,
	i_sign  => ctl,
	o_F	=> s_q);
 
  P_TEST_CASES: process
  begin

   
	ctl <= '1';
    s_1   <= x"0001";  
    wait for 25ns;

ctl <= '0';
s_1   <= x"0001";  
wait for 25ns;

ctl <= '0';
s_1   <= x"FFFF";  
wait for 25ns;

ctl <= '1';
s_1   <= x"FFFF";  
wait for 25ns;

  end process;

end behavior;
