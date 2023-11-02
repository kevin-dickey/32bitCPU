library IEEE;
use IEEE.std_logic_1164.all;

entity data_hazard is
	port(jr, branch, j, ID_EX_MemtoReg	
		: in std_logic;
	ID_EX_stall, IF_ID_flush
		: out std_logic);
end data_hazard;

architecture dataflow of data_hazard is
begin
-- '0' is stall, '1' is no stall
-- stall when jr or not writing to mem to register
	ID_EX_stall <= '0' when	((jr = '1') or (ID_EX_MemtoReg = '1'))
				else '1';
-- '0' when j, branch, or jr
	IF_ID_flush <= '0' when (jr = '1' or branch = '1' or j = '1')
				else '1';
-- something with the pc

	
end dataflow;