-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: extend
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



entity extend is
    port (
        i_instr: in std_logic_vector(31 downto 0);
        i_imm_src: in std_logic_vector(2 downto 0);
        o_imm_ext: out std_logic_vector(31 downto 0)
    );
end entity extend;

architecture Behavioral of extend is

begin

    proc_extend: process(all)
    begin
        case i_imm_src is
            when "000" =>
                o_imm_ext <= (31 downto 12 => i_instr(31)) & i_instr(31 downto 20); -- I type 12 bit immediate
            when "001" =>
                o_imm_ext <= (31 downto 12 => i_instr(31)) & i_instr(31 downto 25) & i_instr(11 downto 7); -- S type 12 bit immediate
            when "010" =>
                o_imm_ext <= (31 downto 12 => i_instr(31)) & i_instr(7) & i_instr(30 downto 25) & i_instr(11 downto 8) & '0'; -- B type 13 bit signed immediate
            when "011" =>
                o_imm_ext <= (31 downto 20 => i_instr(31)) & i_instr(19 downto 12) & i_instr(20) & i_instr(30 downto 21) & '0'; -- J type 21 bit signed immediate
            when "100" =>
                o_imm_ext <= i_instr(31 downto 12) & x"000"; -- U type 20 bit signed immediate
            when others =>
                o_imm_ext <= (others => '0');
        end case;
    end process proc_extend;

end architecture Behavioral;

