-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated


  --Control signals
  signal s_RegDst : std_logic;
  signal s_Jump : std_logic;
  signal s_Branch : std_logic;
  signal s_MemRead : std_logic;
  signal s_MemtoReg : std_logic;
  signal s_brAz	: std_logic;
 -- signal s_MemWrite : std_logic;
  signal s_ALUSrc : std_logic;
 -- signal s_RegWrite : std_logic;
  signal s_AddSub : std_logic;
  signal s_ctl : std_logic;
  signal s_jReg : std_logic;
  signal s_jLink : std_logic;

  --Fetch/pc signals
  signal s_PC : std_logic_vector(N-1 downto 0);
  signal s_jumpAddress : std_logic_vector(N-1 downto 0);
  signal s_PCi : std_logic_vector(N-1 downto 0);
  signal Temp1 : std_logic_vector(N-1 downto 0);
  signal ALUaddress : std_logic_vector(N-1 downto 0);
  signal jumpAddress : std_logic_vector(N-1 downto 0);
  signal s_PCB4 : std_logic_vector(N-1 downto 0);
  signal s_jmpStrt : std_logic;
  signal s_nRST : std_logic;
  signal s_newPC : std_logic_vector(N-1 downto 0);


  --Sign-extended signal
  signal s_SoZextend : std_logic;
  signal s_SignExtended : std_logic_vector(N-1 downto 0);
  signal s_ShiftedSignExtend : std_logic_vector(N-1 downto 0);

  --ALU signals
  signal s_carryout : std_logic;
  signal s_zero : std_logic;
  signal s_if : std_logic;
  signal s_ALU : std_logic_vector(N-1 downto 0);

  --Register signals
  signal s_intermediateWriteReg : std_logic_vector(4 downto 0);
  signal s_jalpc4 : std_logic_vector(N-1 downto 0);
  signal s_ALU1 : std_logic_vector(N-1 downto 0);
  signal s_ALU2 : std_logic_vector(N-1 downto 0);

  --Data Memory signals
  signal s_DataMem : std_logic_vector(N-1 downto 0);
 -- signal s_WriteData : std_logic_vector(N-1 downto 0);

 --Not used Adder signals
  signal s_overflow1 : std_logic;
  signal s_carryOut1 : std_logic;
  signal s_overflow2 : std_logic;
  signal s_carryOut2 : std_logic;

  component mem is
	generic 
	(DATA_WIDTH : natural := 32;
	ADDR_WIDTH : natural := 10);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

component mux2t1_N is 
	generic 
	(N : integer := 32);
    port(
          i_S          : in std_logic;
          i_D0         : in std_logic_vector((N-1) downto 0);
          i_D1         : in std_logic_vector((N-1) downto 0);
          o_O          : out std_logic_vector((N -1) downto 0));
    end component;




--component fetch is 
--	port (CLK			: in std_logic;
--		  i_Input		: in std_logic_vector(31 downto 0);		--Input address into PC
--		  o_Out			: out std_logic_vector(31 downto 0));	--Output address from program counter
--end component;	

component MIPS_pc is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;




component control is 
	port (opcodeinstruction 		   : in std_logic_vector(5 downto 0);
	functinstruction 		   : in std_logic_vector(5 downto 0);
   	ALUSrc 	     		    	: out std_logic;
   	MemtoReg 	 		   : out std_logic;
   	RegWrite 			   : out std_logic;
   	MemWrite 	 		   : out std_logic;
   	MemRead 	 		   : out std_logic;
   	branch 	     		   	: out std_logic;
   	jump 	     		   : out std_logic;
	jumpReg			   : out std_logic;
	jumpLinky		   : out std_logic;
   	RegDst 	     		   : out std_logic;
	SoZextend		   : out std_logic;
	o_Halt			   : out std_logic;
	o_ctl 	     		   : out std_logic);	--Output address from program counter
end component;	


component RippleCarryAdder_N is
	generic(N : integer := 32); -- Default 32-bit ripple carry adder is setup.
	port(i_op1		: in std_logic_vector(N-1 downto 0);
		 i_op2		: in std_logic_vector(N-1 downto 0);
		 i_carryIn	: in std_logic;
		 o_sum		: out std_logic_vector(N-1 downto 0);
		 o_carryOut : out std_logic;
		 o_overflow : out std_logic);
end component;



component proj1_alu is
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
		i_shift_typ	: in std_logic;
		o_carryout	: out std_logic;
		o_overflow	: out std_logic;
		o_zero		: out std_logic;
		o_if		: out std_logic;
		o_ALU		: out std_logic_vector(31 downto 0));
end component;

component register_file is
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


component signExtend is 
	port (i_A		: in std_logic_vector(15 downto 0);
	      i_sign		: in std_logic;
		  o_F			: out std_logic_vector(31 downto 0));
end component;	


  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

begin


  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


--  IMem: mem
--    generic map(ADDR_WIDTH => ADDR_WIDTH,
--                DATA_WIDTH => N)
--    port map(clk  => iCLK,
--             addr => s_IMemAddr(11 downto 2),
--             data => iInstExt,
--             we   => iInstLd,
--             q    => s_Inst);



  
--  DMem: mem
--    generic map(ADDR_WIDTH => ADDR_WIDTH,
--                DATA_WIDTH => N)
--    port map(clk  => iCLK,
--             addr => s_DMemAddr(11 downto 2),
--             data => s_DMemData,
--             we   => s_DMemWr,
--             q    => s_DMemOut);





  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 


    ShiftLeft2a: for i in 0 to 25 generate
	s_jumpAddress(i+2) <= s_Inst(i);
  end generate ShiftLeft2a;
	s_jumpAddress(1) <= '0';
	s_jumpAddress(0) <= '0';

    JumpPC: for i in 28 to 31 generate
	s_jumpAddress(i) <= s_PC(i);
  end generate JumpPC;

    ShiftLeft2b: for i in 0 to 29 generate
	s_ShiftedSignExtend(i+2) <= s_SignExtended(i);
  end generate ShiftLeft2b;
	s_ShiftedSignExtend(1) <= '0';
	s_ShiftedSignExtend(0) <= '0';

ADDERI: RippleCarryAdder_N port map(
              i_op1     => s_ShiftedSignExtend,  -- ith instance's data 0 input hooked up to ith data 0 inputmight need another array for carry bits(then could add again or implement using the carry bit(add then add the previous term with the current bit, two adds per iteration of the for loop))
              i_op2      => s_PC,  -- ith instance's data output hooked up to ith data output.
	      i_carryIn      => '0',
	      o_overflow      => s_overflow1,
	      o_carryOut      => s_carryOut1,
	      o_sum      => Temp1);	

    s_brAz <= s_zero and s_Branch;

    MUXI2: mux2t1_N port map(
              i_S      => s_brAz,      -- All instances share the same select input.
              i_D0     => s_PC,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => Temp1,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => ALUaddress);  -- ith instance's data output hooked up to ith data output.

    s_jmpStrt <= s_Jump and (not iRST);
    MUXI: mux2t1_N port map(
              i_S      => s_jmpStrt,      -- All instances share the same select input.
              i_D0     => ALUaddress,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_jumpAddress,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_newPC);  -- ith instance's data output hooked up to ith data output.

--PC: Fetch port map(
--              CLK     => iCLK,
--	      i_Input      => s_PCi, 
--	      o_Out      => s_PC);
    jumpRegMux: mux2t1_N port map(
              i_S      => s_jReg,      -- All instances share the same select input.
              i_D0     => s_newPC,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_ALU1,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_PCi);  -- ith instance's data output hooked up to ith data output.
	

PC: MIPS_pc port map(i_CLK => iCLK,
       i_RST => iRST,
       i_D  => s_PCi,
       o_Q  => s_NextInstAddr);

ADDER4I: RippleCarryAdder_N port map(
              i_op1     => s_NextInstAddr,  -- ith instance's data 0 input hooked up to ith data 0 inputmight need another array for carry bits(then could add again or implement using the carry bit(add then add the previous term with the current bit, two adds per iteration of the for loop))
              i_op2      => x"00000004",  -- ith instance's data output hooked up to ith data output.
	      i_carryIn      => '0',
	      o_overflow      => s_overflow2,
	      o_carryOut      => s_carryOut2,
	      o_sum      => s_PC);	



IMem: mem --need to have the right values here
	generic map(ADDR_WIDTH => ADDR_WIDTH,
                 DATA_WIDTH => N)
	port map(addr => s_IMemAddr(11 downto 2), -- need fixed
		 we => iInstLd,
		 data => iInstExt,
		 clk  => iCLK,
		 q => s_Inst);


 controlI: control
	port map(opcodeinstruction  => 	s_Inst(31 downto 26),
	functinstruction  => s_Inst(5 downto 0),
   	ALUSrc  => s_ALUSrc,
   	MemtoReg   => s_MemtoReg,
   	RegWrite  => s_RegWr,
   	MemWrite  => s_DMemWr,
   	MemRead  => s_MemRead,
   	branch  => s_Branch,
   	jump  => s_Jump,
	jumpReg => s_jReg,
	jumpLinky => s_jLink,
   	RegDst  => s_RegDst,
	SoZextend => s_SoZextend,
	o_Halt => s_Halt,
	o_ctl => s_ctl);

signExtendI: signExtend
	port map(i_A => s_Inst(15 downto 0),
		 i_sign => s_SoZextend,
		 o_F => s_SignExtended);

    WriteMUX: mux2t1_N 
  	generic map(N => 5)
	port map(
              i_S      => s_RegDst,      -- All instances share the same select input.
              i_D0     => s_Inst(20 downto 16),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_Inst(15 downto 11),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_intermediateWriteReg);  -- ith instance's data output hooked up to ith data output.

    JALMux: mux2t1_N 
  	generic map(N => 5)
	port map(
              i_S      => s_jLink,      -- All instances share the same select input.
              i_D0     => s_intermediateWriteReg,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => "11111",  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_RegWrAddr);  -- ith instance's data output hooked up to ith data output.

Registers: register_file 
  port map(i_WrAddr => s_RegWrAddr, 
	   i_RAddr1 => s_Inst(25 downto 21),
	   i_RAddr2 => s_Inst(20 downto 16),
	   i_Data => s_RegWrData,
	   i_Rst => iRST,
	   i_WrEnable => s_RegWr,
	   i_CLK => iCLK,
	   o_Rd1 => s_ALU1,
           o_Rd2 => s_ALU2);


ALUI: proj1_alu
	port map(i_RST => iRST,
		i_CLK => iCLK,
		i_ALUSrc => s_ALUSrc,
		i_ALU1 => s_ALU1,
		i_ALU2 => s_ALU2,
		i_immediate => s_SignExtended,
		i_opcode => s_Inst(31 downto 26),
		i_func => s_Inst(5 downto 0),
		i_shift => s_Inst(10 downto 6),
		i_ctl => s_ctl,
		i_shift_typ => s_SoZextend,
		o_carryout => s_carryout,
		o_if => s_if,
		o_overflow => s_Ovfl,
		o_zero => s_zero,
		o_ALU => s_ALU);

oALUOut <= s_ALU;

s_DMemData <= s_ALU2;
s_DMemAddr <= s_ALU;

 DMem: mem --need to have the right values here
	port map(addr => s_DMemAddr(11 downto 2), -- need fixed
		 we => s_DMemWr,--need fixed
		 data => s_DMemData,
		 clk  => iCLK,
		 q => s_DMemOut);

    MUXDataMem: mux2t1_N port map(
              i_S      => s_MemtoReg,      -- All instances share the same select input.
              i_D0     => s_ALU,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_DMemOut,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_jalpc4);

    WriteDataMUX: mux2t1_N port map(
              i_S      => s_jLink,      -- All instances share the same select input.
              i_D0     => s_jalpc4,  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => s_PC,  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => s_RegWrData);


end structure;

