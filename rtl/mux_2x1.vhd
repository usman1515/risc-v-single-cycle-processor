-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: mux_2x1
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



entity mux_2x1 is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (
        i_data_a: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_data_b: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i_sel: in std_logic;
        o_data: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity mux_2x1;

architecture Behavioral of mux_2x1 is

begin

    o_data <= i_data_a when i_sel = '1' else i_data_b;

end architecture Behavioral;

