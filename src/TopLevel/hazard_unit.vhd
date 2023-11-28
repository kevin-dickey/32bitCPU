library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_unit is
	port(jr, branch, jump, ID_EX_MemtoReg, ID_EX_RegDst, EX_MEM_MemtoReg, EX_MEM_RegDst, EX_MEM_RegDstWB, EX_MEM_RegWB, aluSrc			: in std_logic;
	EX_MEM_mux, RegWrAddr, RegExAddr, RegDecAddr
		: in std_logic_vector(4 downto 0);
	ID_EX_Instr, EX_MEM_Instr, Instr
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, o_control_hazard
		: out std_logic);
end hazard_unit;

architecture mixed of hazard_unit is
begin
   process (Instr, aluSrc, RegExAddr, EX_MEM_MemtoReg, ID_EX_RegDst, ID_EX_Instr, EX_MEM_Instr, EX_MEM_RegDstWB, EX_MEM_RegWB, jump, branch, jr, RegWrAddr)

-- pc stall: active high
-- other stalls: active low
-- flush: active low
    begin
        if (branch = '1') then --and branch'stable(10 ps)) then
		PC_stall <= '0'; 
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '0';
		IF_ID_flush <= '0';
        
	elsif (jump = '1' or jr = '1') then
		PC_stall <= '0'; 
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '0';

	-- load word
        elsif (EX_MEM_MemtoReg = '1') and  (((ID_EX_Instr(20 downto 16) = RegExAddr) and (aluSrc = '1')) or (ID_EX_Instr(25 downto 21) = RegExAddr)) then

--(((RegExAddr = RegWrAddr )) or((RegDecAddr = RegWrAddr ))) or
-- or RegExAddr = Instr(20 downto 16)
-- or RegDecAddr = Instr(20 downto 16)
		PC_stall <= '1';
		ID_EX_stall <= '0';
		ID_EX_flush <= '1';
		IF_ID_stall <= '0';
		IF_ID_flush <= '1';		

         -- store word
        elsif (EX_MEM_RegWB = '1') and (((RegExAddr = RegWrAddr or RegExAddr = Instr(20 downto 16))) or
                                         ((RegDecAddr = RegWrAddr or RegDecAddr = Instr(20 downto 16)))) then
		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';

        else
		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';
      end if;
    end process;
                            

 
  
end mixed;
