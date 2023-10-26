-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- tb_RippleCarryAdder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for an N-bit ripple carry
-- adder.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_RippleCarryAdder_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_RippleCarryAdder_N;

architecture mixed of tb_RippleCarryAdder_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component RippleCarryAdder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_op1		: in std_logic_vector(N-1 downto 0);
	   i_op2		: in std_logic_vector(N-1 downto 0);
	   i_carryIn	: in std_logic;
	   o_sum		: out std_logic_vector(N-1 downto 0);
       o_carryOut   : out std_logic;
	   o_overflow	: out std_logic);
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

constant N : integer := 32;

-- TODO: change input and output signals as needed.
signal s_op1   		: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_op2   		: std_logic_vector(N-1 downto 0) := x"00000000";
signal s_carryIn    : std_logic := '0';
signal s_sum    	: std_logic_vector(N-1 downto 0);
signal s_carryOut	: std_logic;
signal s_overflow	: std_logic;


begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: RippleCarryAdder_N
  port map(
	   i_op1		=> s_op1,
	   i_op2 		=> s_op2,
	   i_carryIn  	=> s_carryIn,
	   o_sum  		=> s_sum,
	   o_carryOut 	=> s_carryOut,
	   o_overflow	=> s_overflow);
  --You can also do the above port map in one line using the below format: http://www.ics.uci.edu/~jmoorkan/vhdlref/compinst.html

  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
    s_op1   	<= x"0000000A";  
    s_op2   	<= x"00000007";
    s_carryIn	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00000011

    -- Test case 2: should have overflow = 1
    s_op1   	<= x"7FFFFFFF";  
    s_op2   	<= x"0000000F";
    s_carryIn	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00000012

    -- Test case 3:
    s_op1   	<= x"9FFFFFFF";  
    s_op2   	<= x"EFFFFFFF";
    s_carryIn	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x00000006

    -- Test case 4:
    s_op1   	<= x"01001011";  
    s_op2   	<= x"00011101";
    s_carryIn	<= '0';
    wait for gCLK_HPER*2;
    -- Expect output to be 0x01012112

	-- Test case 5:
    s_op1   	<= x"FFFFFFFF";  
    s_op2   	<= x"FFFFFFFF";
    s_carryIn	<= '0';
    wait for gCLK_HPER*2;

  end process;

end mixed;