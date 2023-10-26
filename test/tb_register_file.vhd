-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- tb_register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for a register file.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O
use work.bus_array_type.all;	-- For custom 32x32-bit bus (32x32 2D array)

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_register_file is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_register_file ;

architecture mixed of tb_register_file  is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component register_file  is
	generic(N : integer := 32);
	port(i_WrAddr 	: in std_logic_vector(4 downto 0);	  -- write port; chooses which single 32-bit register to write to
		 i_WrEnable	: in std_logic;						  -- enables the write port (5:32 decoder) to update register referenced at i_Wr with data
		 i_Data  	: in std_logic_vector(31 downto 0);   -- data to be written 
		 i_CLK		: in std_logic;
		 i_Rst  	: in std_logic;
		 i_RAddr1 	: in std_logic_vector(4 downto 0);
		 i_RAddr2 	: in std_logic_vector(4 downto 0);
		 o_Rd1	 	: out std_logic_vector(31 downto 0);  -- read port 1
		 o_Rd2	 	: out std_logic_vector(31 downto 0)); -- read port 2
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
--signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_WrAddr		: std_logic_vector(4 downto 0) := "00000";
signal s_WrEnable	: std_logic := '1';
signal s_Data		: std_logic_vector(31 downto 0);
signal s_CLK		: std_logic := '0';
signal s_Rst		: std_logic := '0';
signal s_RAddr1		: std_logic_vector(4 downto 0);
signal s_RAddr2		: std_logic_vector(4 downto 0);
signal s_Rd1		: std_logic_vector(31 downto 0);
signal s_Rd2		: std_logic_vector(31 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: register_file 
  port map(
		i_WrAddr	=> s_WrAddr,
		i_WrEnable	=> s_WrEnable,
		i_Data		=> s_Data,
		i_CLK		=> s_CLK,
		i_Rst		=> s_Rst,
		i_RAddr1	=> s_RAddr1,
		i_RAddr2	=> s_RAddr2,
		o_Rd1		=> s_Rd1,
		o_Rd2		=> s_Rd2);
						
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    s_CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    s_CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	s_Rst <= '0';   
    wait for gCLK_HPER/2;
	s_Rst <= '1';
    wait for gCLK_HPER*2;
	s_Rst <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

----------------------------------------------
-- Test each register got the data as expected
----------------------------------------------

-- Current debugging notes: s_regOutput (in register_file.vhd) or s_Rd1/s_Rd2 not working.

	s_WrEnable <= '1';

--  Test case 1 (reg0), should show all zeros 
	s_Data <= x"d0000007";
	s_WrAddr <= "00000"; -- write data to reg 0 (should not work)
	s_RAddr1 <= "00000";
	s_RAddr2 <= "00000";
    wait for gCLK_HPER*2;

--  Test case 2 (reg1)
	s_WrAddr <= "00001"; 
	s_RAddr1 <= "00001"; -- data should update on next pos edge of clock
	s_RAddr2 <= "00000"; -- should be zeros
    wait for gCLK_HPER*2;

--  Test case 3 (reg2)
	s_Data <= x"abababab";
	s_WrAddr <= "00010"; 
	s_RAddr1 <= "00010"; -- data should update on next pos edge of clock
	s_RAddr2 <= "00001"; -- should be d0000007
    wait for gCLK_HPER*2;

--  Test case 4 (reg30)
	s_Data <= x"ffffffff";
	s_WrAddr <= "11110";
	s_RAddr1 <= "11110"; -- data should update on next pos edge of clock
	s_RAddr2 <= "11000"; -- should be zeros (reg never set)
    wait for gCLK_HPER*2;

--  Test case 5 (reg31)
	s_Data <= x"ddddaaaa";
	s_WrAddr <= "11111";
	s_RAddr1 <= "11111"; -- data should update on next pos edge of clock
	s_RAddr2 <= "00001"; -- should be d0000007
    wait for gCLK_HPER*2;

--  Test case 6 (reg27)
	s_Data <= x"fabcfabc";
	s_WrAddr <= "11011";
	s_RAddr1 <= "11011"; -- data should update on next pos edge of clock
	s_RAddr2 <= "00001"; -- should be d0000007
    wait for gCLK_HPER*2;

  end process;

end mixed;