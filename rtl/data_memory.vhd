-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: data_memory
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



entity data_memory is
    port (
        clk: in std_logic;
        rst_n: in std_logic;
        i_we: in std_logic;
        i_addr: in std_logic_vector(31 downto 0);
        i_wdata: in std_logic_vector(31 downto 0);
        o_rdata: out std_logic_vector(31 downto 0)
    );
end entity data_memory;

architecture Behavioral of data_memory is

    -- 128 x 32-bit memory
    type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
    signal ram : ram_type;

    -- INFO: https://docs.amd.com/r/2025.1-English/ug912-vivado-properties/RAM_STYLE
    attribute ram_style : string;
    attribute ram_style of ram : signal is "block";

    -- Init file
    attribute init_file : string;
    attribute init_file of ram : signal is "init_data_memory.mem";

    signal addr : integer range 0 to 127;

begin

    -- Use lower 7 bits for addressing
    addr <= to_integer(unsigned(i_addr(6 downto 0)));

    proc_data_mem: process(clk)
    begin
        if rising_edge(clk) then
            -- write data into memory at posedge clk
            if rst_n = '0' then
                o_rdata <= (others => '0');
            else
                if i_we = '1' then
                    ram(addr) <= i_wdata;
                end if;
            end if;
        end if;
        -- read data from mem at every cycle
        o_rdata <= ram(addr);
    end process proc_data_mem;

end architecture Behavioral;

