-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: program_counter_target
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



entity program_counter_target is
    port (
        i_pc_src_a: in std_logic_vector(31 downto 0);
        i_imm_ext: in std_logic_vector(31 downto 0);
        o_pc_plus4: out std_logic_vector(31 downto 0)
    );
end entity program_counter_target;

architecture Behavioral of program_counter_target is

begin

    o_pc_plus4 <= std_logic_vector(unsigned(i_imm_ext) + unsigned(i_pc_src_a));

end architecture Behavioral;

