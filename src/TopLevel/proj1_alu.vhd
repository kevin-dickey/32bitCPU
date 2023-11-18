library IEEE;
use IEEE.std_logic_1164.all;
-----------------------------------------------------------------------------------
--	
--	Brock Dykhuis
--	
-----------------------------------------------------------------------------------
entity proj1_alu is
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
	--	i_forwardB_sel	: in std_logic_vector(1 downto 0);
	--	i_forwardA_sel	: in std_logic_vector(1 downto 0);
	--	i_forwardB_alu	: in std_logic_vector(31 downto 0);
	--	i_forwardB_wb	: in std_logic_vector(31 downto 0);
		o_carryout	: out std_logic;
		o_overflow	: out std_logic;
		o_zero		: out std_logic;
		o_if		: out std_logic;
		o_ALU		: out std_logic_vector(31 downto 0));
end proj1_alu;


architecture mixed of proj1_alu is 

	component AdderSubtractor_N is
	generic(N : integer := 32);
	port(i_A			: in std_logic_vector(N-1 downto 0);
		 i_B			: in std_logic_vector(N-1 downto 0);
		 i_nAdd_Sub		: in std_logic;
	 	 o_Sums			: out std_logic_vector(N-1 downto 0);
		 o_Carry_Out		: out std_logic;
		 o_Overflow		: out std_logic;
		 o_Zero			: out std_logic);
	end component;

	component mux2t1_N is 
	generic(N: integer := 32);
	port(i_S	        : in std_logic;
		 i_D0           : in std_logic_vector (31 downto 0);
		 i_D1		: in std_logic_vector (31 downto 0);
		 o_O		: out std_logic_vector (31 downto 0));
	end component;

	component barrelShifter_32B is
    	port(i_Data     : in std_logic_vector(31 downto 0); -- input data to shift
        	i_shamt    : in std_logic_vector(4 downto 0);  -- amount to shift by
        	i_shift_dir: in std_logic; -- shift direction: 1 means shift left (multiply), 0 means shift right (divide)
        	i_shift_typ: in std_logic; -- shift type: 1 means arithmetic, 0 means logical. (logical is for unsigned, arithmetic is for signed)
        	o_Output   : out std_logic_vector(31 downto 0));
	end component;

	component invg is
		port(i_A          : in std_logic;
       		     o_F          : out std_logic);
	end component;

--	component Setter is
--		port(i_A : in std_logic;
--		     o_F : out std_logic);
--	end component;

signal s_B : std_logic_vector(31 downto 0);
signal s_A : std_logic_vector(31 downto 0);
signal s_add_sub :std_logic_vector(31 downto 0);
signal s_barrel :std_logic_vector(31 downto 0);
signal s_cOut : std_logic;
signal s_overflow : std_logic;
signal s_zero	: std_logic;
signal s_zeroNot : std_logic;
--signal s_forward1 : std_logic_vector(31 downto 0);
--signal s_forward2 : std_logic_vector(31 downto 0);


begin
--chooseImmOrReg :  mux2t1_N	--between immediate and reg value
--port MAP (i_S	=> i_ALUSrc,
--	i_D0	=> i_ALU2,
--	i_D1	=> i_immediate,
--	o_O	=> s_forward1);

--chooseForwardingB_1 :  mux2t1_N	
--port MAP (i_S	=> i_forwardB_sel(0),
--	  i_D0	=> s_forward1,
--	  i_D1	=> i_forwardB_wb,
--	  o_O	=> s_forward2);

--chooseForwardingB_2 :  mux2t1_N	
--port MAP (i_S	=> i_forwardB_sel(1),
--	  i_D0	=> s_forward2,
--	  i_D1	=> i_forwardB_alu,
--	  o_O	=> s_B);

--chooseForwardingA_1 :  mux2t1_N	
--port MAP (i_S	=> i_forwardA_sel(0),
--	  i_D0	=> i_ALU1,
--	  i_D1	=> i_forwardB_wb,
--	  o_O	=> s_forward2);

--chooseForwardingA_2 :  mux2t1_N	
--port MAP (i_S	=> i_forwardA_sel(1),
--	  i_D0	=> s_forward2,
--	  i_D1	=> i_forwardB_alu,
--	  o_O	=> s_A);

q1: AdderSubtractor_N
port MAP( i_A		=> i_ALU1,
	i_B		=> i_ALU2,
	i_nAdd_Sub	=> i_ctl,
	o_Sums		=> s_add_sub,
	o_Carry_Out	=> open,
	o_Overflow	=> s_overflow,
	o_Zero		=> s_zero);


q2: barrelShifter_32B
port MAP(i_Data		=> i_ALU2,
       i_shamt		=> i_shift,
       i_shift_dir	=> i_ctl,
       i_shift_typ	=> i_shift_typ,
       o_Output		=> s_barrel);

ntgt: invg
port MAP(i_A	=> s_zero,
	 o_F	=> s_zeroNot);

--setter: Setter
--port MAP(i_A => s_overflow,
	 --o_F => o_overflow);

--end structual;

process(i_opcode, i_func, s_add_sub, s_barrel, s_zeroNot, i_ALU1, i_ALU2, i_immediate, s_overflow) is
begin

--s_zero <= '0';

case(i_opcode) is
    when "000000" => --R format

	case(i_func) is
	when "100000"  =>	--add
		o_ALU <= s_add_sub;
		o_if <= '0';
		o_overflow <= s_overflow;
	when "100001" =>	--addu
		o_ALU <= s_add_sub;
		o_if <= '0';
		o_overflow <= '0';
	when "100010" =>	--sub
		o_ALU <= s_add_sub;
		o_if <= '0';
		o_overflow <= s_overflow;
	when "100011" =>	--subu
		o_ALU <= s_add_sub;
		o_if <= '0';
		o_overflow <= '0';
	when "100111" =>	 --nor
		for i in 0 to 31 loop
		o_ALU(i) <= i_ALU1(i) nor i_ALU2(i);
		end loop;
		o_if <= '0';
		o_overflow <= '0';
	when "100101" =>	--or
		for i in 0 to 31 loop
		o_ALU(i) <= i_ALU1(i) or i_ALU2(i);
		end loop;
		o_if <= '0';
		o_overflow <= '0';
	when "100110" =>	--xor
		for i in 0 to 31 loop
		o_ALU(i) <= i_ALU1(i) xor i_ALU2(i);
		end loop;
		o_if <= '0';
		o_overflow <= '0';
	when "101010" =>	--slt
		if (s_add_sub(31) = '1') then
			o_ALU <= x"00000001";
		else
			o_ALU <= x"00000000";
		end if;
		o_overflow <= '0';
	when "000000" =>	--sll
		o_ALU <= s_barrel;
		o_overflow <= '0';
	when "000010" => 	--srl
		o_ALU <= s_barrel;
		o_overflow <= '0';
	when "000011" => 	--sra
		o_ALU <= s_barrel;
		o_overflow <= '0';

	when "100100" =>	--and
	for i in 0 to 31 loop
	o_ALU(i) <= i_ALU1(i) and i_ALU2(i);
	end loop;
	o_if <= '0';
	o_overflow <= '0';

	when others =>
		o_if <= '1';
		o_ALU <= x"00000000";
--		o_overflow <= '0';
	end case;
-- begin I format
	
when "001000" => --addi
	o_ALU <= s_add_sub;
	o_if <= '0';
	o_overflow <= s_overflow;
when "001001" => --addiu
	o_ALU <= s_add_sub;
	o_if <= '0';
	o_overflow <= '0';

when "001100" =>	--andi
	for i in 0 to 31 loop
	o_ALU(i) <= i_ALU1(i) and i_ALU2(i);
	end loop;
	o_if <= '0';
	o_overflow <= '0';
when "001111" =>	--lui
	o_ALU <= i_ALU2(15 downto 0)&"0000000000000000";
	o_if <= '0';
	o_overflow <= '0';
when "100011" =>	--lw
	o_ALU <= s_add_sub;
	o_if <= '0';
	o_overflow <= '0';
when "001110" => 	--xori
	for i in 0 to 31 loop
	o_ALU(i) <= i_ALU1(i) xor i_ALU2(i);
	end loop;
	o_overflow <= '0';
when "001101" => 	--ori
	for i in 0 to 31 loop
	o_ALU(i) <= i_ALU1(i) or i_ALU2(i);
	end loop;
	o_if <= '0';
	o_overflow <= '0';
when "001010" =>	--slti
	if (s_add_sub(31) = '1') then
		o_ALU <= x"00000001";
	else
		o_ALU <= x"00000000";
	end if;
	o_overflow <= '0';
when "000100" =>	--beq
	o_zero <= s_zero; 

	o_overflow <= '0';
when "000101" => 	--bne
	o_zero <= s_zeroNot;

	o_overflow <= '0';
when "101011" =>	--sw
	o_ALU <= s_add_sub;
	o_overflow <= '0';
when others =>
	o_if <= '1';
	o_ALU <= x"00000000";
--	o_overflow <= '0';
end case;


end process;
end mixed;
