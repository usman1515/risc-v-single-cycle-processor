-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: program_counter
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



entity program_counter is
    port (
        clk: in std_logic;
        rst_n: in std_logic;
        i_pc_next: in std_logic_vector(31 downto 0);
        o_pc: out std_logic_vector(31 downto 0)
    );
end entity program_counter;

architecture Behavioral of program_counter is

begin

    proc_program_counter: process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                 o_pc <= (others => '0');
            else
                o_pc <= i_pc_next;
            end if;
        end if;
    end process proc_program_counter;

end architecture Behavioral;

