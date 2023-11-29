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


architecture mixed of MIPS_Processor is

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
  signal s_brAz	: std_logic := '0';
 -- signal s_MemWrite : std_logic;
  signal s_ALUSrc : std_logic;
 -- signal s_RegWrite : std_logic;
  signal s_AddSub : std_logic;
  signal s_ctl : std_logic;
  signal s_jReg : std_logic;
  signal s_jLink : std_logic;

  --D control signals
  signal s_HaltD : std_logic;

  signal s_ALU1D : std_logic_vector(N-1 downto 0);
  signal s_ALU2D : std_logic_vector(N-1 downto 0);
  signal s_RegWrAddrD : std_logic_vector(4 downto 0);

  signal s_MemtoRegD : std_logic;
  signal s_RegWrD : std_logic;
  signal s_RegWrD1 : std_logic;
  signal s_DMemWrD : std_logic;
  signal s_DMemWrD1 : std_logic;
  signal s_MemReadD : std_logic;
  signal s_BranchD : std_logic;
  signal s_JumpD : std_logic;
  signal s_ALUSrcD : std_logic;
  signal s_jLinkD : std_logic;
  signal s_jRegD : std_logic;
  signal s_ctlD : std_logic;
  signal s_zeroD : std_logic;

  --Ex control signals
  signal s_BranchEx : std_logic := '0';
  signal s_JumpEx : std_logic := '0';
  signal s_ALuSrcEx : std_logic;
  signal s_MemtoRegEx : std_logic;
  signal s_RegWriteEx : std_logic;
  signal s_memWriteEx : std_logic;
  signal s_memReadEx : std_logic;
  signal s_HaltEx : std_logic;
  signal s_ctlEX : std_logic;
  signal s_jLinkEX : std_logic;
  signal s_jRegEX : std_logic;
  signal s_OverflowEx : std_logic;
  signal s_rsEx : std_logic_vector(4 downto 0);
  signal s_rtEx : std_logic_vector(4 downto 0);
  signal s_rdEx : std_logic_vector(4 downto 0);
  signal s_SignExtendedEx : std_logic_vector(N-1 downto 0);
  signal s_PCEX : std_logic_vector(N-1 downto 0);
  signal s_SoZextendEx : std_logic;
  signal s_zeroEx : std_logic;

  --M control signals
  signal s_MemtoRegM : std_logic;
  signal s_RegWriteM : std_logic;
  signal s_memWriteM : std_logic;
  signal s_HaltM : std_logic;
  signal s_jLinkM : std_logic;
  signal s_OverflowM : std_logic;
  signal s_ALUM : std_logic_vector(31 downto 0);
  signal s_WriteDataM : std_logic_vector(31 downto 0);
  signal s_InstM : std_logic_vector(4 downto 0);
  signal s_PCM : std_logic_vector(N-1 downto 0);

  --WB control signals
  signal s_MemtoRegWB : std_logic;
  signal s_jLinkWB : std_logic;
--  signal s_RegWriteWB : std_logic;
  signal s_ALUWB : std_logic_vector(31 downto 0);
  signal s_DMemOutWB : std_logic_vector(31 downto 0);
--  signal s_InstWB : std_logic_vector(4 downto 0);
  signal s_PCWB : std_logic_vector(N-1 downto 0);

  --Fetch/pc signals
  signal s_new_and_improved_flushy : std_logic_vector(N-1 downto 0);
  signal s_PC : std_logic_vector(N-1 downto 0);
  signal s_PC4 : std_logic_vector(N-1 downto 0);
  signal s_jumpAddress : std_logic_vector(N-1 downto 0);
  signal s_PCi : std_logic_vector(N-1 downto 0);
  signal Temp1 : std_logic_vector(N-1 downto 0);
  signal ALUaddress : std_logic_vector(N-1 downto 0);
  signal jumpAddress : std_logic_vector(N-1 downto 0);
  signal s_PCB4 : std_logic_vector(N-1 downto 0);
  signal s_jmpStrt : std_logic := '0';
  signal s_nRST : std_logic;
  signal s_newPC : std_logic_vector(N-1 downto 0);
  signal s_InstF : std_logic_vector(N-1 downto 0);
  signal s_dummyInst : std_logic_vector(N-1 downto 0);
  signal s_PC_stallF : std_logic;
  signal s_NxtInstAddrMinusFour : std_logic_vector(N-1 downto 0);


  --Sign-extended signal
  signal s_SoZextend : std_logic;
  signal s_SignExtendedD : std_logic_vector(N-1 downto 0);
  signal s_ShiftedSignExtend : std_logic_vector(N-1 downto 0);

  --ALU signals
  signal s_carryout : std_logic;
  signal s_zero : std_logic;
  signal s_if : std_logic;
  signal s_ALU : std_logic_vector(N-1 downto 0);
  signal s_InstEX : std_logic_vector(N-1 downto 0);

  --Register signals
  signal s_intermediateWriteReg : std_logic_vector(4 downto 0);
  signal s_jalpc4 : std_logic_vector(N-1 downto 0);
  signal s_ALU1 : std_logic_vector(N-1 downto 0);
  signal s_ALU2 : std_logic_vector(N-1 downto 0);

  --Data Memory signals
  signal s_DataMem : std_logic_vector(N-1 downto 0);
 -- signal s_WriteData : std_logic_vector(N-1 downto 0);

  -- Forwarding signals
  signal s_ForwardA_ALU : std_logic_vector(1 downto 0);
  signal s_ForwardB_ALU : std_logic_vector(1 downto 0);
  signal s_A : std_logic_vector(31 downto 0);
  signal s_B : std_logic_vector(31 downto 0);
  signal s_forward1 : std_logic_vector(31 downto 0);
  signal s_forward2 : std_logic_vector(31 downto 0);
  signal s_forward3 : std_logic_vector(31 downto 0);


 --Not used Adder signals
  signal s_overflow1 : std_logic;
  signal s_carryOut1 : std_logic;
  signal s_overflow2 : std_logic;
  signal s_carryOut2 : std_logic;

 --For hazard detection
  signal s_ID_EX_flush : std_logic := '1';
  signal s_ID_EX_flush_not : std_logic := '0'; -- flush regularly active low, this signal goes into pipeline regs as active high
  signal s_ID_EX_stall : std_logic := '1';
  signal s_IF_ID_stall : std_logic := '1';
  signal s_IF_ID_flush : std_logic := '1';
  signal s_IF_ID_flush_not : std_logic := '0';
  signal s_PC_stall	: std_logic := '0';
  signal NA1		: std_logic;
  signal NA2		: std_logic_vector(4 downto 0);
  signal NA3		: std_logic_vector(5 downto 0);
  signal NA4		: std_logic_vector(31 downto 0);


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

component mux2t1 is
  port(i_S	: in std_logic;
       i_D0     : in std_logic;
       i_D1     : in std_logic;
       o_O      : out std_logic);
end component;


component iF_ID is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_PCP4          : in std_logic_vector(31 downto 0);     -- Data value input
       o_PCP4          : out std_logic_vector(31 downto 0);
       i_imem          : in std_logic_vector(31 downto 0);
       o_imem          : out std_logic_vector(31 downto 0);
       i_stall	       : in std_logic;
       i_pc_stall	: in std_logic;
       o_pc_stall	: out std_logic);
end component;


component ID_EX is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegEx          : in std_logic;
       o_MemtoRegEx          : out std_logic;
       i_RegWriteEx          : in std_logic;
       o_RegWriteEx          : out std_logic;




       i_memWriteEx          : in std_logic;
       o_memWriteEx          : out std_logic;
       i_memReadEx          : in std_logic;
       o_memReadEx          : out std_logic;

       i_branchEx          : in std_logic;
       o_branchEx          : out std_logic;
       i_zero          : in std_logic;
       o_zero          : out std_logic;	
       i_jumpEx          : in std_logic;
       o_jumpEx          : out std_logic;
       i_AluSrcEx          : in std_logic;
       o_AluSrcEx          : out std_logic;
       i_ctlEx          : in std_logic;
       o_ctlEx          : out std_logic;
       i_jLinkEX          : in std_logic;
       o_jLinkEX          : out std_logic;
       i_jRegEX          : in std_logic;
       o_jRegEX          : out std_logic;

       i_halt          : in std_logic;
       o_halt          : out std_logic;

	i_SoZEx		: in std_logic;
	o_SoZEx 	: out std_logic;

       i_Reg1          : in std_logic_vector(31 downto 0);
       o_Reg1          : out std_logic_vector(31 downto 0);
       i_Reg2          : in std_logic_vector(31 downto 0);
       o_Reg2          : out std_logic_vector(31 downto 0);

       i_PCEX          : in std_logic_vector(31 downto 0);
       o_PCEX          : out std_logic_vector(31 downto 0);

       i_signExtend          : in std_logic_vector(31 downto 0);
       o_signExtend          : out std_logic_vector(31 downto 0);

	i_InstALU		: in std_logic_vector(31 downto 0);
	o_InstALU		: out std_logic_vector(31 downto 0);

       i_rs          : in std_logic_vector(4 downto 0);
       o_rs          : out std_logic_vector(4 downto 0);     
       i_rt          : in std_logic_vector(4 downto 0);
       o_rt          : out std_logic_vector(4 downto 0); 

       i_rd          : in std_logic_vector(4 downto 0);
       o_rd          : out std_logic_vector(4 downto 0);
	
	i_stall		: in std_logic);
       
end component;

component MEM_WB is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegM          : in std_logic;
       o_MemtoRegM          : out std_logic;
       i_RegWriteM          : in std_logic;
       o_RegWriteM          : out std_logic;

       i_memWriteM          : in std_logic;
       o_memWriteM          : out std_logic;
       i_memReadM          : in std_logic;
       o_memReadM          : out std_logic;

       i_halt          : in std_logic;
       o_halt          : out std_logic;
       i_jLinkM          : in std_logic;
       o_jLinkM          : out std_logic;
       i_OverflowM          : in std_logic;
       o_OverflowM          : out std_logic;
	--i_stall			: in std_logic;


       i_PCM          : in std_logic_vector(31 downto 0);
       o_PCM          : out std_logic_vector(31 downto 0);

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_ALU2          : in std_logic_vector(31 downto 0);
       o_ALU2          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(4 downto 0);
       o_Inst          : out std_logic_vector(4 downto 0));
       
end component;

component EX_MEM is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input

       i_MemtoRegWB          : in std_logic;
       o_MemtoRegWB          : out std_logic;
       i_RegWriteWB          : in std_logic;
       o_RegWriteWB          : out std_logic;

       i_halt          : in std_logic;
       o_halt          : out std_logic;
       i_jLinkWB          : in std_logic;
       o_jLinkWB          : out std_logic;
       i_OverflowWB          : in std_logic;
       o_OverflowWB          : out std_logic;

       i_PCWB          : in std_logic_vector(31 downto 0);
       o_PCWB          : out std_logic_vector(31 downto 0);

       i_ALU          : in std_logic_vector(31 downto 0);
       o_ALU          : out std_logic_vector(31 downto 0);
       i_Dmem          : in std_logic_vector(31 downto 0);
       o_Dmem          : out std_logic_vector(31 downto 0);

       i_Inst          : in std_logic_vector(4 downto 0);
       o_Inst          : out std_logic_vector(4 downto 0));
       
end component;

--component fetch is 
--	port (CLK			: in std_logic;
--		  i_Input		: in std_logic_vector(31 downto 0);		--Input address into PC
--		  o_Out			: out std_logic_vector(31 downto 0));	--Output address from program counter
--end component;	

component MIPS_pc is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
  --     i_PC_stall   : in std_logic;
       i_D          : in std_logic_vector(31 downto 0);     -- Data value input
       o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
end component;


component Forwarding_Unit is
	port(i_IDEX_Rs		: in std_logic_vector(4 downto 0);	-- holds rs address from ID/EX pipeline register
	     i_IDEX_Rt		: in std_logic_vector(4 downto 0);	-- holds rt address from ID/EX pipeline register
	     i_EXMEM_Rd		: in std_logic_vector(4 downto 0);	-- holds destination register from EX/MEM pipeline register
	     i_MEMWB_Rd		: in std_logic_vector(4 downto 0);	-- holds destination register from MEM/WB pipeline register
	     i_EXMEM_RegWr	: in std_logic;
	     i_MEMWB_RegWr	: in std_logic;
	     o_ForwardA_ALU 	: out std_logic_vector(1 downto 0);	-- select line for mux going into the A input of the ALU
	     o_ForwardB_ALU 	: out std_logic_vector(1 downto 0));	-- select line for mux going into the B input of the ALU

	-- Forwarding select line key (o_ForwardA/B_ALU)
	-- 00 : source=ID/EX  : ALU operand comes from register file
	-- 01 : source=MEM/WB : ALU operand is forwarded from data memory (or an earlier ALU result)
	-- 10 : source=EX/MEM : ALU operand is forwarded from the prior ALU result
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

component AdderSubtractor_N is
	generic(N : integer := 32);
	port(i_A			: in std_logic_vector(N-1 downto 0);
		 i_B			: in std_logic_vector(N-1 downto 0);
		 i_nAdd_Sub		: in std_logic;
	 	 o_Sums			: out std_logic_vector(N-1 downto 0);
		 o_Carry_Out	: out std_logic;
		 o_Overflow		: out std_logic;
		 o_Zero			: out std_logic);
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
	--	i_forwardA_sel	: in std_logic_vector(1 downto 0);
	--	i_forwardB_sel	: in std_logic_vector(1 downto 0);
	--	i_forwardB_alu	: in std_logic_vector(31 downto 0);
	--	i_forwardB_wb	: in std_logic_vector(31 downto 0);
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

--component hazard_detection is
--	port(jr, branch, jump, ID_EX_MemtoReg, EX_MEM_MemtoReg	
--			: in std_logic;
--		rd, rt, EX_MEM_mux
--			: in std_logic_vector (4 downto 0);
--		i_opcode, i_func		
--			: in std_logic_vector(5 downto 0);
--		ID_EX, EX_MEM
--			: in std_logic_vector (31 downto 0);
--		ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, --o_control_hazard
--			: out std_logic);
--end component;

component hazard_unit is
	port(jr, branch, jump, ID_EX_MemtoReg, ID_EX_RegDst, EX_MEM_MemtoReg, EX_MEM_RegDst, EX_MEM_RegDstWB, EX_MEM_RegWB, aluSrc, EX_RegWr, MEM_RegWr, branchD			: in std_logic;
	RegMemAddr, RegWrAddr, RegExAddr, RegDecAddr
		: in std_logic_vector(4 downto 0);
	ID_EX_Instr, EX_MEM_Instr, Instr
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, o_control_hazard
		: out std_logic);
end component;

component andg2 is
	port(i_A	: in std_logic;
	     i_B	: in std_logic;
	     o_F	: out std_logic);
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
	s_jumpAddress(i+2) <= s_InstEX(i);	-- originally s_InstF, changing to EX made jal_1.s work, but not base tests... could be issue with base tests, nops, control, or something top-level
  end generate ShiftLeft2a;
	s_jumpAddress(1) <= '0';
	s_jumpAddress(0) <= '0';

    JumpPC: for i in 28 to 31 generate
	s_jumpAddress(i) <= s_PCEX(i);
  end generate JumpPC;

    ShiftLeft2b: for i in 0 to 29 generate
	s_ShiftedSignExtend(i+2) <= s_SignExtendedEx(i);
  end generate ShiftLeft2b;
	s_ShiftedSignExtend(1) <= '0';
	s_ShiftedSignExtend(0) <= '0';

ADDERI: RippleCarryAdder_N port map(
              i_op1     => s_ShiftedSignExtend, 
              i_op2      => s_PCEX,  
	      i_carryIn      => '0',
	      o_overflow      => s_overflow1,
	      o_carryOut      => s_carryOut1,
	      o_sum      => Temp1);	-- Temp1 is the branch address


process (s_ALU1D, s_ALU2D, s_zeroD, s_InstF)
begin
if (s_ALU1D = s_ALU2D) then
	if (s_InstF(31 downto 26) = "000100") then	
	s_zeroD <= '1';	-- values equal, beq -- so branch
	elsif (s_InstF(31 downto 26) = "000101") then
	s_zeroD <= '0';	-- values equal, bne -- dont branch
	end if;
else
	if (s_InstF(31 downto 26) = "000100") then	
	s_zeroD <= '0';	-- values not equal, beq -- dont branch
	elsif (s_InstF(31 downto 26) = "000101") then
	s_zeroD <= '1';	-- values not equal, bne -- so branch
	end if;
end if;
end process;

braz_and: andg2
	port map(i_A => s_zeroEx,
		 i_B => s_BranchEx,
		 o_F => s_brAz);

--    process(s_zero)
--    begin
--    if (s_zero'stable(500 ps)) then
--        s_brAz <= s_zero and s_BranchEx;
--    else
--      s_brAz <= '0';
--    end if;
--    end process;

    MUXI2: mux2t1_N port map(
              i_S      => s_brAz,      
              i_D0     => s_PC4,  
              i_D1     => Temp1, 
              o_O      => ALUaddress); -- branch address

    s_jmpStrt <= s_JumpEx and (not iRST);
    MUXI: mux2t1_N port map(
              i_S      => s_jmpStrt,   
              i_D0     => ALUaddress,  
              i_D1     => s_jumpAddress,
              o_O      => s_newPC); 

    jumpRegMux: mux2t1_N port map(
              i_S      => s_jRegEx,      
              i_D0     => s_newPC,  
              i_D1     => s_A,  -- was s_ALU1
              o_O      => s_PCi); 

    pcLooperMux: mux2t1_N port map(
              i_S      => not s_PC_stallF,      
              i_D0     => s_PCi,  		-- keep updating pc
              i_D1     => s_NxtInstAddrMinusFour,  	-- loop that shit
              o_O      => s_new_and_improved_flushy); 
	

PC: MIPS_pc port map(i_CLK => iCLK,
       i_RST => iRST,
       i_D  => s_new_and_improved_flushy, --Should be s_PCi
      -- i_PC_stall => s_PC_stall,
       o_Q  => s_NextInstAddr);

NXTINSTMINUSFOURADDR: AdderSubtractor_N 
	port map(i_A		=> s_NextInstAddr,	
		 i_B		=> x"00000004",	
		 i_nAdd_Sub	=> '1',	
	 	 o_Sums		=> s_NxtInstAddrMinusFour,	
		 o_Carry_Out	=> open,
		 o_Overflow	=> open,
		 o_Zero		=> open);


ADDER4I: RippleCarryAdder_N port map(
              i_op1     => s_NextInstAddr,  -- ith instance's data 0 input hooked up to ith data 0 inputmight need another array for carry bits(then could add again or implement using the carry bit(add then add the previous term with the current bit, two adds per iteration of the for loop))
              i_op2      => x"00000004",
	      i_carryIn      => '0',
	      o_overflow      => s_overflow2,
	      o_carryOut      => s_carryOut2,
	      o_sum      => s_PC4);	



IMem: mem
	generic map(ADDR_WIDTH => ADDR_WIDTH,
                 DATA_WIDTH => N)
	port map(addr => s_IMemAddr(11 downto 2), 
		 we => iInstLd,
		 data => iInstExt,
		 clk  => iCLK,
		 q => s_dummyInst);

s_Inst(31) <= s_dummyInst(31) and (not iRST);
s_Inst(30) <= s_dummyInst(30) and (not iRST);
s_Inst(29) <= s_dummyInst(29) and (not iRST);
s_Inst(28) <= s_dummyInst(28) and (not iRST);
s_Inst(27) <= s_dummyInst(27) and (not iRST);
s_Inst(26) <= s_dummyInst(26) and (not iRST);
s_Inst(25) <= s_dummyInst(25) and (not iRST);
s_Inst(24) <= s_dummyInst(24) and (not iRST);
s_Inst(23) <= s_dummyInst(23) and (not iRST);
s_Inst(22) <= s_dummyInst(22) and (not iRST);
s_Inst(21) <= s_dummyInst(21) and (not iRST);
s_Inst(20) <= s_dummyInst(20) and (not iRST);
s_Inst(19) <= s_dummyInst(19) and (not iRST);
s_Inst(18) <= s_dummyInst(18) and (not iRST);
s_Inst(17) <= s_dummyInst(17) and (not iRST);
s_Inst(16) <= s_dummyInst(16) and (not iRST);
s_Inst(15) <= s_dummyInst(15) and (not iRST);
s_Inst(14) <= s_dummyInst(14) and (not iRST);
s_Inst(13) <= s_dummyInst(13) and (not iRST);
s_Inst(12) <= s_dummyInst(12) and (not iRST);
s_Inst(11) <= s_dummyInst(11) and (not iRST);
s_Inst(10) <= s_dummyInst(10) and (not iRST);
s_Inst(9) <= s_dummyInst(9) and (not iRST);
s_Inst(8) <= s_dummyInst(8) and (not iRST);
s_Inst(7) <= s_dummyInst(7) and (not iRST);
s_Inst(6) <= s_dummyInst(6) and (not iRST);
s_Inst(5) <= s_dummyInst(5) and (not iRST);
s_Inst(4) <= s_dummyInst(4) and (not iRST);
s_Inst(3) <= s_dummyInst(3) and (not iRST);
s_Inst(2) <= s_dummyInst(2) and (not iRST);
s_Inst(1) <= s_dummyInst(1) and (not iRST);
s_Inst(0) <= s_dummyInst(0) and (not iRST);

s_IF_ID_flush_not <= not s_IF_ID_flush;
s_ID_EX_flush_not <= not s_ID_EX_flush;

hazard: hazard_unit
	port map(jr => s_jRegEx,
		branch => s_brAz,
		jump => s_JumpEx,
		aluSrc => s_ALUSrcD,
		ID_EX_MemtoReg => s_MemReadEx,
		ID_EX_RegDst => s_RegWrD,
		EX_MEM_MemtoReg => s_MemtoRegEx, -- s_MemtoRegEx

		EX_MEM_RegDst => s_RegDst,  -- dont use currently
		EX_MEM_RegDstWB => s_RegDst, -- dont use currently

		EX_RegWr => s_RegWriteEx,
		MEM_RegWr => s_RegWriteM,
		branchD => s_BranchD,

		EX_MEM_RegWB => s_memWriteEx, -- was s_MemtoRegWB
		RegWrAddr => s_RegWrAddr,
		RegExAddr => s_rdEx,
		RegDecAddr => s_RegWrAddrD,
		RegMemAddr => s_InstM, --no use
		ID_EX_Instr => s_InstF,
		EX_MEM_Instr => s_InstEx, 
		Instr => s_NextInstAddr,
		ID_EX_stall => s_ID_EX_stall,
		ID_EX_flush => s_ID_EX_flush,
		IF_ID_flush => s_IF_ID_flush,
		IF_ID_stall => s_IF_ID_stall,
		PC_stall => s_pc_stall);


IFID: iF_ID 
  port map(i_CLK => iCLK,
       i_RST => s_IF_ID_flush_not or (not s_PC_stallF),
       i_PCP4 => s_PC4,
       o_PCP4 => s_PC,
       i_imem => s_Inst,
       o_imem => s_InstF,
       i_stall => s_IF_ID_stall,
       i_pc_stall => s_PC_stall,
       o_pc_stall => s_PC_stallF);

    HazMemtoRegMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,   
              i_D0     => '0', 
              i_D1     => s_MemtoReg,
              o_O      => s_MemtoRegD);

    HazRegWriteMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,      
              i_D0     => '0',  
              i_D1     => s_RegWrD1,
              o_O      => s_RegWrD);  

    HazmemWriteMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,    
              i_D0     => '0', 
              i_D1     => s_DMemWrD1,
              o_O      => s_DMemWrD);  

    HazmemReadMUX: mux2t1

	port map(
              i_S      => s_ID_EX_flush,   
              i_D0     => '0', 
              i_D1     => s_MemRead,  
              o_O      => s_MemReadD); 

    HazBranchMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,     
              i_D0     => '0', 
              i_D1     => s_Branch, 
              o_O      => s_BranchD); 

    HazJumpMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,  
              i_D0     => '0', 
              i_D1     => s_Jump, 
              o_O      => s_JumpD);

    HazAluSrcMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,    
              i_D0     => '0', 
              i_D1     => s_ALUSrc, 
              o_O      => s_ALUSrcD); 

    HazJLinkMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,    
              i_D0     => '0', 
              i_D1     => s_jLink, 
              o_O      => s_jLinkD); 

    HazJRegMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,    
              i_D0     => '0', 
              i_D1     => s_jReg, 
              o_O      => s_jRegD); 

    HazCtlMUX: mux2t1
	port map(
              i_S      => s_ID_EX_flush,    
              i_D0     => '0', 
              i_D1     => s_ctl, 
              o_O      => s_ctlD); 

IDEX: ID_EX
  port map(i_CLK => iCLK,
       i_RST => s_ID_EX_flush_not,

       i_MemtoRegEx => s_MemtoRegD,
       o_MemtoRegEx => s_MemtoRegEx,
       i_RegWriteEx => s_RegWrD,
       o_RegWriteEx => s_RegWriteEx,

       i_memWriteEx => s_DMemWrD,
       o_memWriteEx => s_memWriteEx,
       i_memReadEx => s_MemReadD,
       o_memReadEx => s_memReadEx,

       i_branchEx => s_BranchD,
       o_branchEx => s_BranchEx,
       i_zero => s_zeroD,
       o_zero => s_zeroEx,
       i_jumpEx => s_JumpD,
       o_jumpEx => s_JumpEx,
       i_AluSrcEx => s_ALUSrcD,
       o_AluSrcEx => s_ALuSrcEx,
       i_ctlEx => s_ctl,
       o_ctlEx => s_ctlEX,
       i_jLinkEX => s_jLink,
       o_jLinkEX => s_jLinkEX,
       i_jRegEX => s_jReg,
       o_jRegEX => s_jRegEx,


       i_halt => s_HaltD,
       o_halt => s_HaltEx,

	i_SoZEx	=> s_SoZextend,
	o_SoZEx => s_SoZextendEx,

       i_Reg1 => s_ALU1D,
       o_Reg1 => s_ALU1,
       i_Reg2 => s_ALU2D,
       o_Reg2 => s_ALU2,

       i_PCEX => s_PC,
       o_PCEX => s_PCEX,

       i_signExtend => s_SignExtendedD,
       o_signExtend => s_SignExtendedEx,

	i_InstALU  => s_InstF,
	o_InstALU  => s_InstEX,	

       i_rs => s_InstF(25 downto 21),
       o_rs => s_rsEx,
       i_rt => s_InstF(20 downto 16),
       o_rt => s_rtEx,

       i_rd => s_RegWrAddrD,
       o_rd => s_rdEx,
	
	i_stall => s_ID_EX_stall);


EXMEM: EX_MEM
  port map(i_CLK => iCLK,
       i_RST => '0',

       i_MemtoRegWB => s_MemtoRegM,
       o_MemtoRegWB => s_MemtoRegWB,
       i_RegWriteWB => s_RegWriteM,
       o_RegWriteWB => s_RegWr,

       i_halt => s_HaltM,
       o_halt => s_Halt,
       i_jLinkWB => s_jLinkM,
       o_jLinkWB => s_jLinkWB,
       i_OverflowWB => s_OverflowM,
       o_OverflowWB => s_Ovfl,

       i_PCWB => s_PCM,
       o_PCWB => s_PCWB,

       i_ALU => s_DMemAddr,
       o_ALU => s_ALUWB,
       i_Dmem => s_DMemOut,
       o_Dmem => s_DMemOutWB,

       i_Inst => s_InstM,
       o_Inst => s_RegWrAddr);
       
 controlI: control
	port map(opcodeinstruction  => 	s_InstF(31 downto 26),
	functinstruction  => s_InstF(5 downto 0),
   	ALUSrc  => s_ALUSrc,
   	MemtoReg   => s_MemtoReg,
   	RegWrite  => s_RegWrD1,
   	MemWrite  => s_DMemWrD1,
   	MemRead  => s_MemRead,
   	branch  => s_Branch,
   	jump  => s_Jump,
	jumpReg => s_jReg,
	jumpLinky => s_jLink,
   	RegDst  => s_RegDst,
	SoZextend => s_SoZextend,
	o_Halt => s_HaltD,
	o_ctl => s_ctl);

signExtendI: signExtend
	port map(i_A => s_InstF(15 downto 0),
		 i_sign => s_SoZextend,
		 o_F => s_SignExtendedD);

    WriteMUX: mux2t1_N 
  	generic map(N => 5)
	port map(
              i_S      => s_RegDst,    
              i_D0     => s_InstF(20 downto 16), 
              i_D1     => s_InstF(15 downto 11), 
              o_O      => s_intermediateWriteReg); 

    JALMux: mux2t1_N 
  	generic map(N => 5)
	port map(
              i_S      => s_jLink,    
              i_D0     => s_intermediateWriteReg,  
              i_D1     => "11111",
              o_O      => s_RegWrAddrD);  

Registers: register_file 
  port map(i_WrAddr => s_RegWrAddr, 
	   i_RAddr1 => s_InstF(25 downto 21),
	   i_RAddr2 => s_InstF(20 downto 16),
	   i_Data => s_RegWrData,
	   i_Rst => iRST,
	   i_WrEnable => s_RegWr,
	   i_CLK => iCLK,
	   o_Rd1 => s_ALU1D,
           o_Rd2 => s_ALU2D);

forwarding: Forwarding_Unit		-- ex/mem and mem/wb pipeline register names are swapped
	port map(i_IDEX_Rs	=> s_rsEx,
	     i_IDEX_Rt		=> s_rtEx,
	     i_EXMEM_Rd		=> s_InstM,
	     i_MEMWB_Rd		=> s_RegWrAddr,
	     i_EXMEM_RegWr	=> s_RegWriteM,
	     i_MEMWB_RegWr	=> s_RegWr,
	     o_ForwardA_ALU 	=> s_ForwardA_ALU,
	     o_ForwardB_ALU 	=> s_ForwardB_ALU);

chooseImmOrReg :  mux2t1_N	--between immediate and reg value
port MAP (i_S	=> s_ALuSrcEx,
	i_D0	=> s_forward2,
	i_D1	=> s_SignExtendedEx,
	o_O	=> s_B);

-- Forwarding select line key (o_ForwardA/B_ALU)
-- 00 : source=ID/EX  : ALU operand comes from register file
-- 01 : source=MEM/WB : ALU operand is forwarded from data memory (or an earlier ALU result)
-- 10 : source=EX/MEM : ALU operand is forwarded from the prior ALU result
chooseForwardingB_1 :  mux2t1_N	
port MAP (i_S	=> s_ForwardB_ALU(0),
	  i_D0	=> s_ALU2,
	  i_D1	=> s_RegWrData,
	  o_O	=> s_forward1);

chooseForwardingB_2 :  mux2t1_N	
port MAP (i_S	=> s_ForwardB_ALU(1),
	  i_D0	=> s_forward1,
	  i_D1	=> s_DMemAddr,
	  o_O	=> s_forward2);

chooseForwardingA_1 :  mux2t1_N	
port MAP (i_S	=> s_ForwardA_ALU(0),
	  i_D0	=> s_ALU1,
	  i_D1	=> s_RegWrData,
	  o_O	=> s_forward3);

chooseForwardingA_2 :  mux2t1_N	
port MAP (i_S	=> s_ForwardA_ALU(1),
	  i_D0	=> s_forward3,
	  i_D1	=> s_DMemAddr,
	  o_O	=> s_A);


ALUI: proj1_alu
	port map(i_RST => iRST,
		i_CLK => iCLK,
		i_ALUSrc => s_ALuSrcEx,
		i_ALU1 => s_A,
		i_ALU2 => s_B,
		i_immediate => s_B,
		i_opcode => s_InstEX(31 downto 26),
		i_func => s_InstEX(5 downto 0),
		i_shift => s_InstEX(10 downto 6),
		i_ctl => s_ctlEX,
		i_shift_typ => s_SoZextendEx,
	--	i_forwardA_sel => s_ForwardA_ALU,
	--	i_forwardB_sel => s_ForwardB_ALU,
	--	i_forwardB_alu => s_DMemAddr,
	--	i_forwardB_wb => s_RegWrData,
		o_carryout => s_carryout,
		o_if => s_if,
		o_overflow => s_OverflowEx,
		o_zero => s_zero,
		o_ALU => s_ALU);



oALUOut <= s_ALU;

--s_DMemData <= s_ALU2;
--s_DMemAddr <= s_ALU;

MEMWB: MEM_WB
  port map(i_CLK => iCLK,
       i_RST => '0',

       i_MemtoRegM => s_MemtoRegEx,
       o_MemtoRegM => s_MemtoRegM,
       i_RegWriteM => s_RegWriteEx,
       o_RegWriteM => s_RegWriteM,

       i_memWriteM => s_memWriteEx,
       o_memWriteM => s_DMemWr,
       i_memReadM => s_memReadEx,
       o_memReadM => s_memWriteM,

       i_halt => s_HaltEx,
       o_halt => s_HaltM,
       i_jLinkM => s_jLinkEX,
       o_jLinkM => s_jLinkM,
       i_OverflowM => s_OverflowEx,
       o_OverflowM => s_OverflowM,

	--i_stall		=> s_ID_EX_stall,

       i_PCM => s_PCEX,
       o_PCM => s_PCM,

       i_ALU => s_ALU,
       o_ALU => s_DMemAddr,
       i_ALU2 => s_forward2,
       o_ALU2 => s_DMemData,

       i_Inst => s_rdEx,
       o_Inst => s_InstM);

 DMem: mem 
	port map(addr => s_DMemAddr(11 downto 2), 
		 we => s_DMemWr,
		 data => s_DMemData,
		 clk  => iCLK,
		 q => s_DMemOut);

    MUXDataMem: mux2t1_N port map(
              i_S      => s_MemtoRegWB,      
              i_D0     => s_ALUWB, 
              i_D1     => s_DMemOutWB,  
              o_O      => s_jalpc4);

    WriteDataMUX: mux2t1_N port map(
              i_S      => s_jLinkWB,      
              i_D0     => s_jalpc4, 
              i_D1     => s_PCWB, 
              o_O      => s_RegWrData);


end mixed;


