---------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
---------------------------------------------------------------------------
-- Forwarding_Unit.vhd
---------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a forwarding unit
-- based on a 5-state pipelined cpu using the MIPS ISA. 
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Forwarding_Unit is
	port(i_IDEX_Rs		: in std_logic_vector(4 downto 0);	-- holds rs address from ID/EX pipeline register
		 i_IDEX_Rt		: in std_logic_vector(4 downto 0);	-- holds rt address from ID/EX pipeline register
		 i_EXMEM_Rd		: in std_logic_vector(4 downto 0);	-- holds destination register from EX/MEM pipeline register
		 i_MEMWB_Rd		: in std_logic_vector(4 downto 0);	-- holds destination register from MEM/WB pipeline register
		 i_EXMEM_RegWr	: in std_logic;
		 i_MEMWB_RegWr	: in std_logic;
		 o_ForwardA_ALU : out std_logic_vector(1 downto 0);	-- select line for mux going into the A input of the ALU
		 o_ForwardB_ALU : out std_logic_vector(1 downto 0));	-- select line for mux going into the B input of the ALU

-- Forwarding select line key (o_ForwardA/B_ALU)
-- 00 : source=ID/EX  : ALU operand comes from register file
-- 01 : source=MEM/WB : ALU operand is forwarded from data memory (or an earlier ALU result)
-- 10 : source=EX/MEM : ALU operand is forwarded from the prior ALU result


end Forwarding_Unit;

architecture mixed of Forwarding_Unit is

	signal s_Forward_A, s_Forward_B : std_logic_vector(1 downto 0) := '0';

	begin
		process (i_IDEX_Rs, i_IDEX_Rt, i_EXMEM_Rd, i_MEMWB_Rd, i_EXMEM_RegWr, i_MEMWB_RegWr)
		begin

		-- may need to check instruction type here? not super sure.
		-- being in a process may not work, will have to revise if so

		-- forwarding from mem stage:
		-- if (MEM/WB.RegWrite == 1) and (MEM/WB.RegRd != 0) and not(EX/MEM.RegWrite and (EX/MEM.RegRd != 0) and (EX/MEM.RegRd == ID/EX.RegRs)) and (MEM/WB.RegRd == ID/EX.RegRs))
		--		ForwardA = 11
		-- forwarding from ex stage basically the same

		---- actual code below ----

		-- forwarding from EX/MEM to ALU input A
		if ((i_EXMEM_RegWr = '1') and (i_EXMEM_Rd /= "00000") and (i_EXMEM_Rd = i_IDEX_Rs)) then
			s_Forward_A = "10";

		-- forwarding from MEM/WB to ALU input A
		elsif ((i_MEMWB_RegWr = '1') and (i_MEMWB_Rd /= "00000") and (i_MEMWB_Rd = i_IDEX_Rs)) then
			s_Forward_A = "01";
		else
			s_Forward_A = "00";
		end if;

		-- if (MEM/WB.RegWrite == 1) and (MEM/WB.RegRd != 0) and not(EX/MEM.RegWrite and (EX/MEM.RegRd != 0) and (EX/MEM.RegRd == ID/EX.RegRs)) and (MEM/WB.RegRd == ID/EX.RegRs))
		--		ForwardB = 11

		-- forwarding from EX/MEM to ALU input B
		if ((i_EXMEM_RegWr = '1') and (i_EXMEM_Rd /= "00000") and (i_EXMEM_Rd = i_IDEX_Rs)) then
			s_Forward_B = "10";

		-- forwarding from MEM/WB to ALU input B
		elsif ((i_MEMWB_RegWr = '1') and (i_MEMWB_Rd /= "00000") and (i_MEMWB_Rd = i_IDEX_Rs)) then
			s_Forward_B = "01";
		else
			s_Forward_B = "00";
		end if;
	end process;

	o_ForwardA_ALU <= s_Forward_A;
	o_ForwardB_ALU <= s_Forward_B;

end mixed;
