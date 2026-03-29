-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: mux_4x1
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



entity mux_4x1 is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (
        i_data_a: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_data_b: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_data_c: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_data_d: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_sel: in std_logic_vector(1 downto 0);
        o_data: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity mux_4x1;

architecture Behavioral of mux_4x1 is

begin

    proc_mux_4x1: process(all)
    begin
        case i_sel is
            when "00" => o_data <= i_data_a;
            when "01" => o_data <= i_data_b;
            when "10" => o_data <= i_data_c;
            when "11" => o_data <= i_data_d;
            when others => o_data <= (others => '0');
        end case;

    end process proc_mux_4x1;

end architecture Behavioral;

