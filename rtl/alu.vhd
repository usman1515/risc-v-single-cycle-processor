-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: alu
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



entity alu is
    port (
        i_alu_control: in std_logic_vector(4 downto 0);
        i_alu_srcA: in std_logic_vector(31 downto 0);
        i_alu_srcB: in std_logic_vector(31 downto 0);
        o_alu_result: out std_logic_vector(31 downto 0);
        o_zero: out std_logic
    );
end entity alu;

architecture Behavioral of alu is

    -- type t_opcode is (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLTU, SLT, SLLI, SRLI, SRAI, BNE, BLT, BLTU, BGE, BGEU);
    -- signal opcode : t_opcode;
    signal alu_result : std_logic_vector(31 downto 0) := (others => '0');

begin

    proc_alu: process(all)
    begin
        case i_alu_control is
            -- ADD
            when "00000" =>
                alu_result <= std_logic_vector(unsigned(i_alu_srcA) + unsigned(i_alu_srcB));
            -- SUB
            when "00001" =>
                alu_result <= std_logic_vector(unsigned(i_alu_srcA) - unsigned(i_alu_srcB));
            -- AND
            when "00010" =>
                alu_result <= i_alu_srcA and i_alu_srcB;
            -- OR
            when "00011" =>
                alu_result <= i_alu_srcA or i_alu_srcB;
            -- XOR
            when "00100" =>
                alu_result <= i_alu_srcA xor i_alu_srcB;
            -- SLL
            when "00101" =>
                alu_result <= std_logic_vector(
                    shift_left(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SRL
            when "00110" =>
                alu_result <= std_logic_vector(
                    shift_right(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SRA
            when "00111" =>
                alu_result <= std_logic_vector(
                    shift_right(signed(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SLTU
            when "01000" =>
                alu_result <= x"0000_0001" when unsigned(i_alu_srcA) < unsigned(i_alu_srcB) else (others => '0');
            -- SLT
            when "01001" =>
                alu_result <= x"0000_0001" when signed(i_alu_srcA) < signed(i_alu_srcB) else (others => '0');
            -- SLLI
            when "01010" =>
                alu_result <= std_logic_vector(
                    shift_left(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(5 downto 0))))
                );
            -- SRLI
            when "01011" =>
                alu_result <= std_logic_vector(
                    shift_right(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(5 downto 0))))
                );
            -- SRAI
            when "01100" =>
                alu_result <= std_logic_vector(
                    shift_right(signed(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- BNE
            when "01101" =>
                alu_result <= x"0000_0001" when unsigned(i_alu_srcA) - unsigned(i_alu_srcB) = 0 else (others => '0');
            -- BLT / BLTU
            when "01110" =>
                alu_result <= (others => '0') when signed(i_alu_srcA) < signed(i_alu_srcB) else x"0000_0001";
            -- BGE / BGEU
            when "01111" =>
                alu_result <= (others => '0') when signed(i_alu_srcA) >= signed(i_alu_srcB) else x"0000_0001";
            -- PASS B
            when "10000" =>
                alu_result <= i_alu_srcB;
            when others =>
                alu_result <= (others => '0');
        end case;

        -- zero flag
        o_zero <= '1' when alu_result = x"0000_0000" else '0';
    end process proc_alu;

    o_alu_result <= alu_result;

end architecture Behavioral;

