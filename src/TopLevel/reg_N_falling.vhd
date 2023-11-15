-------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
-------------------------------------------------------------------------
-- reg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural VHDL implementation of
-- an N-bit register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_N_falling is
	generic(N : integer := 32);		-- set to 32-bit by default
	port(i_In		: in std_logic_vector(N-1 downto 0);		-- N-bit input
		 i_Clk		: in std_logic;								-- Clock signal, synchronous for all DFFs in N-bit register
	 	 i_WrEn		: in std_logic;								-- Write enable (0 if reading), synchronous for all DFFs in N-bit register
		 i_Reset	: in std_logic;								-- Reset signal, synchronous for all DFFs in N-bit register
		 o_Out		: out std_logic_vector(N-1 downto 0));		-- N-bit output
end reg_N_falling;

architecture structure of reg_N_falling is

	component dffg_falling is
		port(i_CLK        : in std_logic;     -- Clock input
       		 i_RST        : in std_logic;     -- Reset input
       		 i_WE         : in std_logic;     -- Write enable input
       		 i_D          : in std_logic;     -- Data value input
       		 o_Q          : out std_logic);   -- Data value output
	end component;

	signal s_Out : std_logic_vector(N-1 downto 0);

begin

	-- Instantiate N DFF_falling instances.
	G_NBit_Reg: for i in 0 to N-1 generate
    	DFFI: dffg_falling port map(
              i_CLK     => i_Clk,      -- All DFFs get the same clock signal
              i_RST     => i_Reset,    -- All DFFs get the same reset signal
              i_WE     	=> i_WrEn,     -- All DFFs get the same write enable signal
              i_D		=> i_In(i),	   -- Each DFF gets its own 1-bit input
			  o_Q    	=> s_Out(i));  -- Each DFF gets its own 1-bit output
	end generate G_NBit_Reg;

	o_Out <= s_Out;

end structure;
