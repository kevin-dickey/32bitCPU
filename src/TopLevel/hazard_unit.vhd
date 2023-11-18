library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_unit is
	port(jr, branch, jump, ID_EX_MemtoReg, ID_EX_RegDst, EX_MEM_MemtoReg, EX_MEM_RegDst, EX_MEM_RegDstWB, EX_MEM_RegWB	
		: in std_logic;
	EX_MEM_mux, RegWrAddr, RegExAddr, RegDecAddr
		: in std_logic_vector(4 downto 0);
	ID_EX_Instr, EX_MEM_Instr, Instr
		: in std_logic_vector (31 downto 0);
	ID_EX_stall, ID_EX_flush, IF_ID_flush, IF_ID_stall, PC_stall, o_control_hazard
		: out std_logic);
end hazard_unit;

architecture mixed of hazard_unit is
begin
   process (Instr, EX_MEM_MemtoReg, ID_EX_RegDst, ID_EX_Instr, EX_MEM_Instr, EX_MEM_RegDstWB, EX_MEM_RegWB, jump, branch, jr, RegWrAddr)
    begin
        if (branch = '1') then
		PC_stall <= '1'; --maybe 1
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';
        
	elsif (jump = '1' or jr = '1') then
		PC_stall <= '1'; --maybe 1
		ID_EX_stall <= '1';
		ID_EX_flush <= '0';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';
        elsif (EX_MEM_MemtoReg = '1') and (((RegExAddr = RegWrAddr or RegExAddr = Instr(20 downto 16))) or
                                     ((RegDecAddr = RegWrAddr or RegDecAddr = Instr(20 downto 16)))) then

		PC_stall <= '0';
		ID_EX_stall <= '0';
		ID_EX_flush <= '0';
		IF_ID_stall <= '0';
		IF_ID_flush <= '0';		
            
        elsif (EX_MEM_MemtoReg = '1') and (((RegExAddr = RegWrAddr or RegExAddr = Instr(20 downto 16))) or
                                         (EX_MEM_MemtoReg = '0' and (RegDecAddr = RegWrAddr or RegDecAddr = Instr(20 downto 16)))) then
		PC_stall <= '0';
		ID_EX_stall <= '0';
		ID_EX_flush <= '0';
		IF_ID_stall <= '0';
		IF_ID_flush <= '0';
         
        elsif (EX_MEM_RegWB = '1') and (((RegExAddr = RegWrAddr or RegExAddr = Instr(20 downto 16))) or
                                         ((RegDecAddr = RegWrAddr or RegDecAddr = Instr(20 downto 16)))) then
		PC_stall <= '0';
		ID_EX_stall <= '0';
		ID_EX_flush <= '0';
		IF_ID_stall <= '0';
		IF_ID_flush <= '0';

        else
		PC_stall <= '0';
		ID_EX_stall <= '1';
		ID_EX_flush <= '1';
		IF_ID_stall <= '1';
		IF_ID_flush <= '1';
      end if;
    end process;
                            

 
  
end mixed;
