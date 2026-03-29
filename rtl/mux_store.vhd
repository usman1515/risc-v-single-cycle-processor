-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: mux_store
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



entity mux_store is
    port (
        i_rd2: in std_logic_vector(31 downto 0);
        i_store_src: in std_logic_vector(1 downto 0);
        o_wd: out std_logic_vector(31 downto 0)
    );
end entity mux_store;

architecture Behavioral of mux_store is

begin

    proc_mux_store: process(all)
    begin
        case i_load_src is
            when "00" => o_wd <= (31 downto 8 => '0') & i_rd2(7 downto 0);
            when "01" => o_wd <= (31 downto 16 => '0') & i_rd2(15 downto 0);
            when "10" => o_wd <= i_rd2;
        end case;
    end process proc_mux_store;

end architecture Behavioral;

