-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: instruction_memory
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



entity instruction_memory is
    port (
        i_addr: in std_logic_vector(31 downto 0);
        o_rdata: out std_logic_vector(31 downto 0)
    );
end entity instruction_memory;

architecture Behavioral of instruction_memory is

    -- 256 x 32-bit memory
    type instr_mem_type is array (0 to 255) of std_logic_vector(31 downto 0);
    signal instr_mem : instr_mem_type;

    -- INFO: https://docs.amd.com/r/2025.1-English/ug912-vivado-properties/RAM_STYLE
    attribute ram_style : string;
    attribute ram_style of instr_mem : signal is "block";

    -- Init file
    attribute init_file : string;
    attribute init_file of instr_mem : signal is "init_instruction_memory.mem";

begin

    proc_instr_mem: process(all)
    begin
        -- read data from mem at every cycle
        o_rdata <= instr_mem(to_integer(unsigned(i_addr(8 downto 2))));
    end process proc_instr_mem;

end architecture Behavioral;

