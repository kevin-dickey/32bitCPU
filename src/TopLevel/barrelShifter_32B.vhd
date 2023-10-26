--------------------------------------------------------------------------------------
-- Kevin Dickey
-- Student @ Iowa State University
--------------------------------------------------------------------------------------
-- barrelShifter_32B.vhd
--------------------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit wide
-- barrel shifter. The input to be shifted is 32 bits wide, the amount to 
-- shift by is 5 bits wide, and the output is 32 bits wide.
--------------------------------------------------------------------------------------
-- NOTE: The shifting sequences below (how it's handled) is working assuming
--       right shifting. Could just as easily do it by assuming left shifting.
--
--       For this though, left shifting is handled simply by flipping the
--       input sequence, shifting, then flipping back. This SHOULD theoretically
--       work. (I think.)
--
--		 ALSO: When shifting left, type can be arithmetic OR logical (doesn't matter).
--------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelShifter_32B is
    port(i_Data     : in std_logic_vector(31 downto 0); -- input data to shift
         i_shamt    : in std_logic_vector(4 downto 0);  -- amount to shift by
         i_shift_dir: in std_logic; -- shift direction: 1 means shift left (multiply), 0 means shift right (divide)
         i_shift_typ: in std_logic; -- shift type: 1 means arithmetic, 0 means logical. (logical is for unsigned, arithmetic is for signed)
         o_Output   : out std_logic_vector(31 downto 0));
end barrelShifter_32B;

architecture structural of barrelShifter_32B is

    component mux2t1_N is
        generic(N : integer := 32);
        port(i_S    : in std_logic;
             i_D0   : in std_logic_vector(N-1 downto 0);
             i_D1   : in std_logic_vector(N-1 downto 0);
             o_O    : out std_logic_vector(N-1 downto 0));
    end component;

    component mux2t1 is
        port(i_S	: in std_logic;
             i_D0   : in std_logic;
             i_D1   : in std_logic;
             o_O    : out std_logic);
    end component;

    signal s_shiftMSB : std_logic; -- value gets set based on i_shift_typ. holds what the MSB of shifted value should be
    signal s_data, s_left_in, s_left_out : std_logic_vector(31 downto 0);
    signal s_shift0_in, s_shift0_out : std_logic_vector(31 downto 0); -- for shamt bit #0
    signal s_shift1_in, s_shift1_out : std_logic_vector(31 downto 0); -- for shamt bit #1
    signal s_shift2_in, s_shift2_out : std_logic_vector(31 downto 0); -- for shamt bit #2
    signal s_shift3_in, s_shift3_out : std_logic_vector(31 downto 0); -- for shamt bit #3
    signal s_shift4_in, s_shift4_out : std_logic_vector(31 downto 0); -- for shamt bit #4

    -- there will be a mux for each shamt bit, overall will (incrementally) shift as necessary

    begin

        -- flipping input sequence so i don't have to actually handle shifting differently, just let mux choose flipped or not flipped
        -- input, shift as normal, then flip back if necessary. Using this flipped input means shifting by left. 
        s_left_in(0) <= i_Data(31);                                         
        s_left_in(1) <= i_Data(30);
        s_left_in(2) <= i_Data(29);
        s_left_in(3) <= i_Data(28);
        s_left_in(4) <= i_Data(27);
        s_left_in(5) <= i_Data(26);
        s_left_in(6) <= i_Data(25);
        s_left_in(7) <= i_Data(24);
        s_left_in(8) <= i_Data(23);
        s_left_in(9) <= i_Data(22);
        s_left_in(10) <= i_Data(21);
        s_left_in(11) <= i_Data(20);
        s_left_in(12) <= i_Data(19);
        s_left_in(13) <= i_Data(18);
        s_left_in(14) <= i_Data(17);
        s_left_in(15) <= i_Data(16);
        s_left_in(16) <= i_Data(15);
        s_left_in(17) <= i_Data(14);
        s_left_in(18) <= i_Data(13);
        s_left_in(19) <= i_Data(12);
        s_left_in(20) <= i_Data(11);
        s_left_in(21) <= i_Data(10);
        s_left_in(22) <= i_Data(9);
        s_left_in(23) <= i_Data(8);
        s_left_in(24) <= i_Data(7);
        s_left_in(25) <= i_Data(6);
        s_left_in(26) <= i_Data(5);
        s_left_in(27) <= i_Data(4);
        s_left_in(28) <= i_Data(3);
        s_left_in(29) <= i_Data(2);
        s_left_in(30) <= i_Data(1);
        s_left_in(31) <= i_Data(0);


---------------------------------------------------------------------

        -- determine left or right shift (0 = right, 1 = left)
        mux_shift_dir: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shift_dir,
                     i_D0   => i_data,      -- not flipped data, shifting right
                     i_D1   => s_left_in,   -- flipped data, shifting left
                     o_O    => s_data);     -- data to work with

        -- determine shift type & set desired MSB(0 = logical (unsigned), 1 = arithmetic (signed))
        mux_shift_typ: mux2t1
            port MAP(i_S    => i_shift_typ,
                     i_D0   => '0',
                     i_D1   => s_data(31),
                     o_O    => s_shiftMSB);


---------------------------------------------------------------------

        -- finish setting up signal for shamt[0]
        s_shift0_in(31) <= s_shiftMSB;
        s_shift0_in(30 downto 0) <= s_Data(31 downto 1); -- 31 downto 1 b/c (s_shift0_in) is expecting a shift by 1 bit already

        -- mux to determine if actually wants shifted by 1 bit (based on bit 0 of 5-bit shamt field)
        mux_shamt0: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shamt(0),
                     i_D0   => s_data,      -- potentially preserved in s_shift0_out in case not shifting by shamt[0], similar for other bits
                     i_D1   => s_shift0_in,
                     o_O    => s_shift0_out);


---------------------------------------------------------------------

        -- now setup signals for shamt[1]
        s_shift1_in(31) <= s_shiftMSB;  -- pad accordingly
        s_shift1_in(30) <= s_shiftMSB;  -- pad accordingly
        s_shift1_in(29 downto 0) <= s_shift0_out(31 downto 2);

        -- mux to determine if actually wants shifted by 2 bits (based on bit 1 of 5-bit shamt field)
        mux_shamt1: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shamt(1),
                     i_D0   => s_shift0_out,
                     i_D1   => s_shift1_in,
                     o_O    => s_shift1_out);


 ---------------------------------------------------------------------  

        -- now setup signals for shamt[2]
        s_shift2_in(31) <= s_shiftMSB;
        s_shift2_in(30) <= s_shiftMSB;
        s_shift2_in(29) <= s_shiftMSB;
        s_shift2_in(28) <= s_shiftMSB;
        s_shift2_in(27 downto 0) <= s_shift1_out(31 downto 4);

        -- mux to determine if actually wants shifted by 4 bits (based on bit 2 of 5-bit shamt field)
        mux_shamt2: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shamt(2),
                     i_D0   => s_shift1_out,
                     i_D1   => s_shift2_in,
                     o_O    => s_shift2_out);


---------------------------------------------------------------------

        -- now setup signals for shamt[3]
        s_shift3_in(31) <= s_shiftMSB;
        s_shift3_in(30) <= s_shiftMSB;
        s_shift3_in(29) <= s_shiftMSB;
        s_shift3_in(28) <= s_shiftMSB;
        s_shift3_in(27) <= s_shiftMSB;
        s_shift3_in(26) <= s_shiftMSB;
        s_shift3_in(25) <= s_shiftMSB;
        s_shift3_in(24) <= s_shiftMSB;
        s_shift3_in(23 downto 0) <= s_shift2_out(31 downto 8);

        -- mux to determine if actually wants shifted by 8 bits (based on bit 3 of 5-bit shamt field)
        mux_shamt3: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shamt(3),
                     i_D0   => s_shift2_out,
                     i_D1   => s_shift3_in,
                     o_O    => s_shift3_out);


---------------------------------------------------------------------
 
        -- now setup signals for shamt[4]
        s_shift4_in(31) <= s_shiftMSB;
        s_shift4_in(30) <= s_shiftMSB;
        s_shift4_in(29) <= s_shiftMSB;
        s_shift4_in(28) <= s_shiftMSB;
        s_shift4_in(27) <= s_shiftMSB;
        s_shift4_in(26) <= s_shiftMSB;
        s_shift4_in(25) <= s_shiftMSB;
        s_shift4_in(24) <= s_shiftMSB;
        s_shift4_in(23) <= s_shiftMSB;
        s_shift4_in(22) <= s_shiftMSB;
        s_shift4_in(21) <= s_shiftMSB;
        s_shift4_in(20) <= s_shiftMSB;
        s_shift4_in(19) <= s_shiftMSB;
        s_shift4_in(18) <= s_shiftMSB;
        s_shift4_in(17) <= s_shiftMSB;
        s_shift4_in(16) <= s_shiftMSB;
        s_shift4_in(15 downto 0) <= s_shift3_out(31 downto 16);

        -- mux to determine if actually wants shifted by 8 bits (based on bit 4 of 5-bit shamt field (0-4))
        mux_shamt4: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shamt(4),
                     i_D0   => s_shift3_out,
                     i_D1   => s_shift4_in,
                     o_O    => s_shift4_out);


---------------------------------------------------------------------

        -- flip the output back to normal (flipping input sequence back to have properly left shifted)
        s_left_out(0) <= s_shift4_out(31);                                         
        s_left_out(1) <= s_shift4_out(30);
        s_left_out(2) <= s_shift4_out(29);
        s_left_out(3) <= s_shift4_out(28);
        s_left_out(4) <= s_shift4_out(27);
        s_left_out(5) <= s_shift4_out(26);
        s_left_out(6) <= s_shift4_out(25);
        s_left_out(7) <= s_shift4_out(24);
        s_left_out(8) <= s_shift4_out(23);
        s_left_out(9) <= s_shift4_out(22);
        s_left_out(10) <= s_shift4_out(21);
        s_left_out(11) <= s_shift4_out(20);
        s_left_out(12) <= s_shift4_out(19);
        s_left_out(13) <= s_shift4_out(18);
        s_left_out(14) <= s_shift4_out(17);
        s_left_out(15) <= s_shift4_out(16);
        s_left_out(16) <= s_shift4_out(15);
        s_left_out(17) <= s_shift4_out(14);
        s_left_out(18) <= s_shift4_out(13);
        s_left_out(19) <= s_shift4_out(12);
        s_left_out(20) <= s_shift4_out(11);
        s_left_out(21) <= s_shift4_out(10);
        s_left_out(22) <= s_shift4_out(9);
        s_left_out(23) <= s_shift4_out(8);
        s_left_out(24) <= s_shift4_out(7);
        s_left_out(25) <= s_shift4_out(6);
        s_left_out(26) <= s_shift4_out(5);
        s_left_out(27) <= s_shift4_out(4);
        s_left_out(28) <= s_shift4_out(3);
        s_left_out(29) <= s_shift4_out(2);
        s_left_out(30) <= s_shift4_out(1);
        s_left_out(31) <= s_shift4_out(0);


---------------------------------------------------------------------

        mux_shift_dir_again: mux2t1_N
            generic MAP(N => 32)
            port MAP(i_S    => i_shift_dir,
                     i_D0   => s_shift4_out, -- yippee i shifted right
                     i_D1   => s_left_out,   -- yippee i shifted left
                     o_O    => o_Output);     

    end structural;
