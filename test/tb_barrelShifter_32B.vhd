-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- tb_barrelShifter_32B.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for extenders, extends 
-- either by sign or by zeros.
-------------------------------------------------------------------------

-- As of (October 5, 2023 @ 3:22pm): WORKING

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_barrelShifter_32B is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_barrelShifter_32B;

architecture mixed of tb_barrelShifter_32B is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component barrelShifter_32B is
	port(i_Data     : in std_logic_vector(31 downto 0); -- input data to shift
         i_shamt    : in std_logic_vector(4 downto 0);  -- amount to shift by
         i_shift_dir: in std_logic; -- shift direction: 1 means shift left (multiply), 0 means shift right (divide)
         i_shift_typ: in std_logic; -- shift type: 1 means arithmetic, 0 means logical. (logical is for unsigned, arithmetic is for signed)
         o_Output   : out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

signal s_Data, s_Output			: std_logic_vector(31 downto 0);
signal s_shift_dir, s_shift_typ	: std_logic;
signal s_shamt					: std_logic_vector(4 downto 0);


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: barrelShifter_32B 
	port MAP(i_Data			=> s_Data,
			 i_shamt		=> s_shamt,
			 i_shift_dir	=> s_shift_dir,
			 i_shift_typ	=> s_shift_typ,
			 o_Output		=> s_Output);

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER;   -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER;   -- after half a cycle, process begins evaluation again
  end process;


  -- Assign inputs for each test case.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

	-- initialize data
	s_Data <= x"0FF00AA0";
	wait for cCLK_PER;	

	-- shift right 4 times
	s_shift_dir <= '0';
	s_shift_typ <= '1';
	s_shamt <= "00100";
	wait for cCLK_PER; -- expect 00FF00AA

	-- shift left 4 times
	s_shift_dir <= '1';
	s_shift_typ <= '1';
	s_shamt <= "00100";
	wait for cCLK_PER; -- expect FF00AA00 (data being shifted is still 0FF00AA0)

-- shift left 4 times
	s_shift_dir <= '1';
	s_shift_typ <= '0';
	s_shamt <= "00100";
	wait for cCLK_PER; -- expect FF00AA00 (data being shifted is still 0FF00AA0)

	-- shift right 2 times
	s_shift_dir <= '0';
	s_shift_typ <= '1';
	s_shamt <= "00010";
	wait for cCLK_PER; -- expect 03FC02A8 (data being shifted is still 0FF00AA0)

	-- test sra (should keep sign of shifted data)
	s_Data <= x"F0000000";
	s_shift_dir <= '0';
	s_shift_typ <= '1';
	s_shamt <= "00100";
	wait for cCLK_PER;

	-- sra again
	s_Data <= x"FFFFAA00";
	wait for cCLK_PER;
	s_shift_dir <= '0';
	s_shift_typ <= '1';
	s_shamt <= "00100";
	wait for cCLK_PER;

	-- srl
	s_shift_dir <= '0';
	s_shift_typ <= '0';
	s_shamt <= "00100";
	wait for cCLK_PER;

    end process;
end mixed;