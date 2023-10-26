library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O

-- Usually name your testbench similar to below for clarity tb_<name>
-- TODO: change all instances of tb_TPU_MV_Element to reflect the new testbench.
entity tb_control is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_control;

architecture mixed of tb_control  is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
-- TODO: change component declaration as needed.
component control is

  port(opcodeinstruction 		   : in std_logic_vector(5 downto 0);
	functinstruction 		   : in std_logic_vector(5 downto 0);

--   	ALUSrc_op 	     		   : out std_logic_vector(5 downto 0);
   	ALUSrc 	     		    	: out std_logic;
   	MemtoReg 	 		   : out std_logic;
   	RegWrite 			   : out std_logic;
   	MemWrite 	 		   : out std_logic;
   	MemRead 	 		   : out std_logic;
   	branch 	     		   	: out std_logic;
   	jump 	     		   : out std_logic;
   	RegDst 	     		   : out std_logic;
	
--	LoR 	     		   : out std_logic; --logical or arithmatic 
	SoZextend 	     		   : out std_logic;--sign or zero extend
	o_ctl 	     		   : out std_logic);

end component;

-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal s_CLK, s_reset : std_logic := '0';

constant N : integer := 32;

-- TODO: change input and output signals as needed.
signal s_opcodeinstruction 		   : std_logic_vector(5 downto 0);
signal	s_functinstruction 		   : std_logic_vector(5 downto 0);

--   	ALUSrc_op 	     		   : out std_logic_vector(5 downto 0);
signal   	s_ALUSrc 	     		    	: std_logic;
signal   	s_MemtoReg 	 		   : std_logic;
signal   	s_RegWrite 			   : std_logic;
signal   	s_MemWrite 	 		   : std_logic;
signal   	s_MemRead 	 		   : std_logic;
signal   	s_branch 	     		   	: std_logic;
signal   	s_jump 	     		   : std_logic;
signal   	s_RegDst 	     		   : std_logic;
	
--	LoR 	     		   : out std_logic; --logical or arithmatic 
signal	s_SoZextend 	     		   : std_logic;--sign or zero extend
signal	s_o_ctl 	     		   : std_logic;






begin

  -- TODO: Actually instantiate the component to test and wire all signals to the corresponding
  -- input or output. Note that DUT0 is just the name of the instance that can be seen 
  -- during simulation. What follows DUT0 is the entity name that will be used to find
  -- the appropriate library component during simulation loading.
  DUT0: control
    port MAP(opcodeinstruction		=> s_opcodeinstruction,	
functinstruction		=> s_functinstruction,	
		ALUSrc		=> s_ALUSrc,
		MemtoReg 	=> s_MemtoReg,
		RegWrite		=> s_RegWrite,
		MemWrite		=> s_MemWrite,
		MemRead	=> s_MemRead,
		branch	=> s_branch,
		jump		=> s_jump,
		RegDst		=> s_RegDst,
		SoZextend		=> s_SoZextend,
		o_ctl	=> s_o_ctl);

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

    -- Test case 1:addi
	s_opcodeinstruction <= "001000";
	s_functinstruction <= "000010";

wait for gCLK_HPER/2;

    -- Test case 2:slti
	s_opcodeinstruction <= "001010";
	s_functinstruction <= "000000";

wait for gCLK_HPER/2;
    -- Test case 3:and 
	s_opcodeinstruction <= "000000";
	s_functinstruction <= "100100";

wait for gCLK_HPER/2;
    -- Test case 5:jal
	s_opcodeinstruction <= "000011";
	s_functinstruction <= "100101";

wait for gCLK_HPER/2;
    -- Test case 5:beq
	s_opcodeinstruction <= "000100";
	s_functinstruction <= "100101";

wait for gCLK_HPER/2;
    -- Test case 6: sw
	s_opcodeinstruction <= "100011";
	s_functinstruction <= "100101";

wait for gCLK_HPER/2;
  
  end process;

end mixed;
