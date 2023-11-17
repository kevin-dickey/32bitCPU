library IEEE;
use IEEE.std_logic_1164.all;


entity control is

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
	o_Halt			   : out std_logic;
        jumpReg			   : out std_logic;
	jumpLinky		   : out std_logic;
	flushy			   : out std_logic;
	
--	LoR 	     		   : out std_logic; --logical or arithmatic 
	SoZextend 	     		   : out std_logic;--sign or zero extend
	o_ctl 	     		   : out std_logic);

end control;

architecture behavioral of control is
begin

process(opcodeinstruction,functinstruction)

begin
	SoZextend <= '0';
	o_Halt <= '0';
        jumpReg <= '0';
	jumpLinky <= '0';
	flushy <= '0';
	case(opcodeinstruction) is
    	when "000000" => --R format
				SoZextend <= '0';
			case(functinstruction) is
			when "100000" => --add
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';

			when "100110" => --xor
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';

			when "100001" => --addu
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';

			when "100100" => --and
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';

			when "001000" => --jr
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '1';
				jumpReg <= '1';
				flushy <= '1';

			when "100111" => --nor
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';

			when "100101" => --or
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';

			when "101010" => --slt
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '1';

			when "000000" => --sll
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '1';
				SoZextend <= '0';

			when "000010" => --srl
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';
				SoZextend <= '0';

			when "000011" => --sra
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';
				SoZextend <= '1';

			when "100010" => --sub
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '1';

			when "100011" => --subu
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '1';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '1';

		    	when others => --any other opcode
				RegDst <= '1';
				ALUSrc <= '0';
				MemtoReg <= '0';
				RegWrite <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				branch <= '0';
				jump <= '0';
				o_ctl <= '0';
				SoZextend <= '0';

			end case;
	-- begin I format

    	when "001000" => --addi
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			o_ctl <= '0';
			SoZextend <= '0';

    	when "001001" => --addiu
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			o_ctl <= '0';
			SoZextend <= '0';

    	when "001100" => --andi
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			SoZextend <= '1';

    	when "001111" => --lui
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			SoZextend <= '1';

    	when "100011" => --lw
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '1';
			RegWrite <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			o_ctl <= '0';
			SoZextend <= '0';
			flushy <= '1';

    	when "001110" => --xori
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			SoZextend <= '1';

    	when "001101" => --ori
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			SoZextend <= '1';

    	when "001010" => --slti
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			SoZextend <= '0';
			o_ctl <= '1';

    	when "101011" => --sw
			RegDst <= '0';
			ALUSrc <= '1';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '1';
			branch <= '0';
			jump <= '0';
			SoZextend <= '0';
			o_ctl <= '0';
			flushy <= '1';

    	when "000100" => --beq
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '1';
			jump <= '0';
			o_ctl <= '1';
			flushy <= '1';

    	when "000101" => --bne
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '1';
			jump <= '0';
			o_ctl <= '1';
			flushy <= '1';

    	when "000010" => --j
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '1';
			flushy <= '1';

    	when "000011" => --jal
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '1';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '1';
			jumpLinky <= '1';
			flushy <= '1';

    	when "010100" => --s_Halt
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			o_Halt <= '1';

    	when others => --any other opcode
			RegDst <= '0';
			ALUSrc <= '0';
			MemtoReg <= '0';
			RegWrite <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			branch <= '0';
			jump <= '0';
			o_ctl <= '0';
			SoZextend <= '0';


	end case;
end process;
end behavioral;
 








