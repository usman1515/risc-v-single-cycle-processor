-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: register_file
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
-- NOTE: https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Initializing-Block-RAM-From-an-External-Data-File-VHDL
-- //////////////////////////////////////////////////////////////////////////////////


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.rtl_components.all;



entity register_file is
    port (
        clk: in std_logic;
        rst_n: in std_logic;
        i_addr1: in std_logic_vector(4 downto 0);
        i_addr2: in std_logic_vector(4 downto 0);
        i_addr3: in std_logic_vector(4 downto 0);
        i_we3: in std_logic;
        i_wdata3: in std_logic_vector(31 downto 0);
        o_rdata1: out std_logic_vector(31 downto 0);
        o_rdata2: out std_logic_vector(31 downto 0)
    );
end entity register_file;

architecture Behavioral of register_file is

    -- 128 x 32-bit memory
    type register_mem_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal register_mem : register_mem_type;

    -- INFO: https://docs.amd.com/r/2025.1-English/ug912-vivado-properties/RAM_STYLE
    attribute ram_style : string;
    attribute ram_style of register_mem : signal is "block";

    -- Init file
    attribute init_file : string;
    attribute init_file of register_mem : signal is "init_register_memory.mem";

begin

    proc_register_mem: process(clk)
    begin

        -- read data from mem at every cycle
        o_rdata1 <= register_mem(to_integer(unsigned(i_addr1)));
        o_rdata2 <= register_mem(to_integer(unsigned(i_addr2)));

        if rising_edge(clk) then
            -- write data into memory at posedge clk
            if rst_n = '0' then
                o_rdata1 <= (others => '0');
                o_rdata2 <= (others => '0');
            else
                if i_we3 = '1' then
                    register_mem(to_integer(unsigned(i_addr3))) <= i_wdata3;
                end if;
            end if;
        end if;
    end process proc_register_mem;

end architecture Behavioral;

