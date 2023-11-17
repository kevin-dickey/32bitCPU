library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_unit is
	port(jr, branch, jump, ID_EX_MemtoReg, ID_EX_RegDst, EX_MEM_MemtoReg, EX_MEM_RegDst	
		: in std_logic;
	EX_MEM_mux
		: in std_logic_vector (4 downto 0);
	i_opcode, i_func		
		: in std_logic_vector(5 downto 0);
	ID_EX_Instr, EX_MEM_Instr, Instr
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, o_control_hazard
		: out std_logic);
end hazard_unit;

architecture mixed of hazard_unit is
   process (i_Instr, i_Instr_IDEX, i_Instr_EXMEM, i_Instr_MEMWB, i_RegWr_IDEX, i_RegWr_EXMEM, i_RegWr_MEMWB, i_Jump_IDEX, i_BranchTaken_IDEX)
    begin
        if (jump = '1' or branch = '1') then
		PC_stall <= '1';
		ID_EX_stall <= '1';
		ID_EX_flush <= '0';
		IF_ID_stall <= '1';
		IF_ID_flush <= '0';
              
        elsif (EX_MEM_MemtoReg = '1') and ((ID_EX_RegDst = '1' and (ID_EX_Instr(15 downto 11) = Instr(25 downto 21) or ID_EX_Instr(15 downto 11) = Instr(20 downto 16))) or
                                     (ID_EX_RegDst = '0' and (ID_EX_Instr(20 downto 16) = Instr(25 downto 21) or ID_EX_Instr(20 downto 16) = Instr(20 downto 16)))) then

		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '0';
		IF_ID_flush <= '0';		
            
        elsif (EX_MEM_MemtoReg = '1') and ((EX_MEM_RegDst = '1' and (EX_MEM_Instr(15 downto 11) = Instr(25 downto 21) or EX_MEM_Instr(15 downto 11) = Instr(20 downto 16))) or
                                         (EX_MEM_MemtoReg = '0' and (EX_MEM_Instr(20 downto 16) = Instr(25 downto 21) or EX_MEM_Instr(20 downto 16) = Instr(20 downto 16)))) then
		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '0';
		IF_ID_stall <= '0';
		IF_ID_flush <= '1';
         
        elsif (EX_MEM_RegWB = '1') and ((EX_MEM_RegDstWB = '1' and (EX_MEM_Instr(15 downto 11) = Instr(25 downto 21) or EX_MEM_Instr(15 downto 11) = Instr(20 downto 16))) or
                                         (EX_MEM_RegDstWB = '0' and (EX_MEM_Instr(20 downto 16) = Instr(25 downto 21) or EX_MEM_Instr(20 downto 16) = Instr(20 downto 16)))) then
		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '0';
		IF_ID_stall <= '0';
		IF_ID_flush <= '1';

        elsif (branch = '1') then
          	PC_stall <= '1';
		ID_EX_stall <= '1';
		ID_EX_flush <= '0';
		IF_ID_stall <= '1';
		IF_ID_flush <= '0';

        else
		PC_stall <= '1';
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';
      end if;
    end process;
                            

 
  
end mixed;