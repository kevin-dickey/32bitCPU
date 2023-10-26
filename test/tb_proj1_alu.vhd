library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_proj1_alu is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_proj1_alu;

architecture mixed of tb_proj1_alu  is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component proj1_alu  is
  port(i_RST		: in std_logic;
		i_CLK		: in std_logic;
		i_ALUSrc 	: in std_logic;
		i_ALU1		: in std_logic_vector(31 downto 0);
		i_ALU2		: in std_logic_vector(31 downto 0);
		i_immediate	: in std_logic_vector(31 downto 0);
		i_opcode	: in std_logic_vector(5 downto 0);
		i_func		: in std_logic_vector(5 downto 0);
		i_shift		: in std_logic_vector(4 downto 0);
		i_ctl		: in std_logic;
		o_carryout	: out std_logic;
		o_if		: out std_logic;
		o_ALU		: out std_logic_vector(31 downto 0));
end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal s_CLK, s_reset : std_logic := '0';

constant N : integer := 32;

-- TODO: change input and output signals as needed.
signal s_ALU1   	: std_logic_vector(31 downto 0) := x"00000000";
signal s_ALU2   	: std_logic_vector(31 downto 0) := x"00000000";
signal s_ALUSrc   	: std_logic;
signal s_nAdd_Sub	: std_logic;
signal s_immediate	: std_logic_vector(31 downto 0);
signal s_opcode		: std_logic_vector(5 downto 0);
signal s_func		: std_logic_vector(5 downto 0);
signal s_shift		: std_logic_vector(4 downto 0);
signal s_ctl		: std_logic;
signal s_zero		: std_logic;
signal s_carryout	: std_logic;
signal s_ALU		: std_logic_vector(31 downto 0);



begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: proj1_alu
    port MAP(i_RST		=> s_reset,	
		i_CLK		=> s_CLK,
		i_ALUSrc 	=> s_ALUSrc,
		i_ALU1		=> s_ALU1,
		i_ALU2		=> s_ALU2,
		i_immediate	=> s_immediate,
		i_opcode	=> s_opcode,
		i_func		=> s_func,
		i_shift		=> s_shift,
		i_ctl		=> s_ctl,
		o_carryout	=> s_carryout,
		o_if		=> s_zero,
		o_ALU		=> s_ALU);
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
  	s_reset <= '0';   
    wait for gCLK_HPER/2;
	s_reset <= '1';
    wait for gCLK_HPER*2;
	s_reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    -- Test case 1:
	s_ALU1 <= x"FFFFFFFF";
	s_ALU2 <= x"00000000";
	s_immediate <= x"FFFFFFFF";
	s_ALUSrc <= '0';
	s_func <= "000000";
	s_opcode <= "100100";	--and
	s_shift <= "00000";
	s_ctl <= '0';

wait for gCLK_HPER/2;

    -- Expect output to be FFFFFFFF

    -- Test case 2:
	s_ALU1 <= x"000FF000";
	s_ALU2 <= x"00000000";
	s_immediate <= x"00000000";
	s_ALUSrc <= '0';
	s_func <= "000000";
	s_opcode <= "000000";	--shift
	s_shift <= "00100";
	s_ctl <= '1';

wait for gCLK_HPER/2;
    -- Expect output to be 

    -- Test case 3:
	s_ALU1 <= x"00000000";
	s_ALU2 <= x"00000000";
	s_immediate <= x"FFFFFFFF";
	s_ALUSrc <= '1';
	s_func <= "000000";
	s_opcode <= "001111";	--lui
	s_shift <= "00010";
	s_ctl <= '0';

wait for gCLK_HPER/2;
    -- Expect output to be

    -- Test case 4:
	s_ALU1 <= x"FFF00000";
	s_ALU2 <= x"00000FFF";
	s_immediate <= x"00000000";
	s_ALUSrc <= '0';
	s_func <= "100000";
	s_opcode <= "000000";	--add
	s_shift <= "00000";


wait for gCLK_HPER/2;
  
	s_ALU1 <= x"FFFFFFFF";
	s_ALU2 <= x"00000000";
	s_immediate <= x"0000FFFF";
	s_ALUSrc <= '1';
	s_func <= "100000";
	s_opcode <= "000000";	--subi
	s_shift <= "00000";
	s_ctl <= '1'; --0 for add 1 for sub

wait for gCLK_HPER/2;

	s_ALU1 <= x"0000FFFF";
	s_ALU2 <= x"0000FFFF";
	s_immediate <= x"0000FFFF";
	s_ALUSrc <= '0';
	s_func <= "101010";
	s_opcode <= "001010";	--slti
	s_shift <= "00000";
	s_ctl <= '1'; --0 for add 1 for sub

wait for gCLK_HPER / 2;

	s_ALU1 <= x"0000FFFF";
	s_ALU2 <= x"0000FFFF";
	s_immediate <= x"00000000";
	s_ALUSrc <= '1';
	s_func <= "000000";
	s_opcode <= "000100";	--beq
	s_shift <= "00000";
	s_ctl <= '0'; --0 for add 1 for sub

wait for gCLK_HPER / 2;


	s_ALU1 <= x"0000FFFF";
	s_ALU2 <= x"00000000";
	s_immediate <= x"00000000";
	s_ALUSrc <= '1';
	s_func <= "000000";
	s_opcode <= "101010";	--sw
	s_shift <= "00000";
	s_ctl <= '0'; --0 for add 1 for sub

wait for gCLK_HPER / 2;

  
  end process;

end mixed;
