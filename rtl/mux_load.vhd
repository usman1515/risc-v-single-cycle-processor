-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: mux_load
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



entity mux_load is
    port (
        i_result: in std_logic_vector(31 downto 0);
        i_load_src: in std_logic_vector(2 downto 0);
        o_wd3: out std_logic_vector(31 downto 0)
    );
end entity mux_load;

architecture Behavioral of mux_load is

begin

    proc_mux_load: process(all)
    begin
        case i_load_src is
            when "000" =>
                o_wd3 <= (31 downto 8 => i_result(7)) & i_result(7 downto 0);
            when "001" =>
                o_wd3 <= (31 downto 16 => i_result(15)) & i_result(15 downto 0);
            when "010" =>
                o_wd3 <= i_result;
            when "011" =>
                o_wd3 <= (31 downto 8 => '0') & i_result(7 downto 0);
            when "100" =>
                o_wd3 <= (31 downto 16 => '0') & i_result(15 downto 0);
            when others =>
                o_wd3 <= (others => '-');
        end case;
    end process proc_mux_load;

end architecture Behavioral;

