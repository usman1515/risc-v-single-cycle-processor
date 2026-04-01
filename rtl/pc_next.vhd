-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: program_counter_next
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- //////////////////////////////////////////////////////////////////////////////////


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rtl_components.all;



entity program_counter_next is
    port (
        i_pc: in std_logic_vector(31 downto 0);
        o_pc_plus4: out std_logic_vector(31 downto 0)
    );
end entity program_counter_next;

architecture Behavioral of program_counter_next is

begin

    o_pc_plus4 <= std_logic_vector(unsigned(i_pc) + x"0000_0004");

end architecture Behavioral;

