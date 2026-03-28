-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: PCMux
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

    type t_opcode is (
        ADD, SUB,
        AND, OR, XOR,
        SLL, SRL, SRA, SLTU, SLT, SLLI, SRLI, SRAI,
        BNE, BLT, BLTU, BGE, BGEU
    );
    signal opcode : t_opcode;

begin

    proc1: process(all)
    begin
        case i_alu_control is
            when "00000" => o_alu_result <= std_logic_vector(unsigned(i_alu_srcA) + unsigned(i_alu_srcB));  -- ADD
            when "00001" => o_alu_result <= std_logic_vector(unsigned(i_alu_srcA) - unsigned(i_alu_srcB));  -- SUB
            when "00010" => o_alu_result <= i_alu_srcA and i_alu_srcB;      -- AND
            when "00011" => o_alu_result <= i_alu_srcA or i_alu_srcB;       -- OR
            when "00100" => o_alu_result <= i_alu_srcA xor i_alu_srcB;      -- XOR
            when "00101" => o_alu_result <= std_logic_vector(shift_left(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(3 downto 0)))));   -- SLL
            when "00110" => o_alu_result <= std_logic_vector(shift_right(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(3 downto 0)))));  -- SRL
            when "00111" => o_alu_result <= std_logic_vector(shift_left(signed(i_alu_srcA), to_integer(unsigned(i_alu_srcB(3 downto 0)))));   -- SRA
            when "01000" => o_alu_result <= x"0001" when unsigned(i_alu_srcB) > unsigned(i_alu_srcA) else x"0000";  -- SLTU
            when "01001" => o_alu_result <= x"0001" when signed(i_alu_srcB) > signed(i_alu_srcA) else x"0000";  -- SLT
            when "01010" => o_alu_result <= std_logic_vector(shift_left(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0)))));   -- SLLI
            when "01011" => o_alu_result <= std_logic_vector(shift_right(unsigned(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0)))));  -- SRLI
            when "01100" => o_alu_result <= std_logic_vector(shift_left(signed(i_alu_srcA), to_integer(unsigned(i_alu_srcB(4 downto 0)))));   -- SRAI
            when "01101" => o_alu_result <= x"0001" when unsigned(i_alu_srcA) - unsigned(i_alu_srcB) == 0 else x"0000";  -- BNE

            when "10000" => o_alu_result <= i_alu_srcB;
            when others => o_alu_result <= (others => '0');
        end case;
    end process proc1;

    o_zero <= '1' when unsigned(o_alu_result) == 0 else '0';

        5'b01101:ALUResult=((SrcA-SrcB)==0)?1'b1:1'b0;//bne
        5'b01110:ALUResult=($signed(SrcA)<$signed(SrcB))?32'b0:32'b1;//blt,bltu
        5'b01111:ALUResult=($signed(SrcA)>=$signed(SrcB))?32'b0:32'b1;//bge,bgeu
        5'b10000:ALUResult=SrcB;


end architecture Behavioral;



entity alu is
    port (
        i_alu_control: in std_logic_vector(4 downto 0);
        i_alu_srcA: in std_logic_vector(31 downto 0);
        i_alu_srcB: in std_logic_vector(31 downto 0);
        o_zero: out std_logic;
        o_alu_result: out std_logic_vector(31 downto 0)
    );
end entity;

architecture Behavioral of alu is

    signal alu_result : std_logic_vector(31 downto 0) := (others => '0');

begin

    proc1: process(all)
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
                    shift_left(unsigned(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SRL
            when "00110" =>
                alu_result <= std_logic_vector(
                    shift_right(unsigned(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SRA
            when "00111" =>
                alu_result <= std_logic_vector(
                    shift_right(signed(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- SLTU
            when "01000" =>
                alu_result <= x"00000001" when unsigned(i_alu_srcA) < unsigned(i_alu_srcB) else x"00000000";
            -- SLT
            when "01001" =>
                alu_result <= x"00000001" when signed(i_alu_srcA) < signed(i_alu_srcB) else x"00000000";
            -- SLLI
            when "01010" =>
                alu_result <= std_logic_vector(
                    shift_left(unsigned(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(5 downto 0))))
                );
            -- SRLI
            when "01011" =>
                alu_result <= std_logic_vector(
                    shift_right(unsigned(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(5 downto 0))))
                );
            -- SRAI
            when "01100" =>
                alu_result <= std_logic_vector(
                    shift_right(signed(i_alu_srcA),
                    to_integer(unsigned(i_alu_srcB(4 downto 0))))
                );
            -- BNE
            when "01101" =>
                alu_result <= x"00000001" when unsigned(i_alu_srcA) - unsigned(i_alu_srcB) = 0 else x"00000000";
            -- BLT / BLTU
            when "01110" =>
                alu_result <= x"00000000" when signed(i_alu_srcA) < signed(i_alu_srcB) else x"00000001";
            -- BGE / BGEU
            when "01111" =>
                alu_result <= x"00000000" when signed(i_alu_srcA) >= signed(i_alu_srcB) else x"00000001";
            -- PASS B
            when "10000" =>
                alu_result <= i_alu_srcB;
            when others =>
                alu_result <= (others => '0');
        end case;

        -- zero flag
        o_zero <= '1' when unsigned(alu_result) = (others => '0') else '0';
    end process;

    o_alu_result <= alu_result;

end architecture;

