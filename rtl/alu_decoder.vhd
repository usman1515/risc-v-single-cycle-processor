-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: alu_decoder
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



entity alu_decoder is
    port (
        -- i_aluop: in std_logic_vector(1 downto 0);
        i_opcode: in std_logic_vector(6 downto 0);
        i_funct7: in std_logic_vector(6 downto 0);
        i_funct3: in std_logic_vector(2 downto 0);
        i_zero: in std_logic;
        o_pc_src: out std_logic;
        o_pc_target_src: out std_logic;
        o_result_src: out std_logic_vector(1 downto 0);
        o_mem_write: out std_logic;
        o_alu_src: out std_logic;
        o_imm_src: out std_logic_vector(2 downto 0);
        o_reg_write: out std_logic;
        -- o_alu_op: out std_logic_vector(1 downto 0);
        o_jump: out std_logic;
        o_pc_alu_src: out std_logic;
        o_alu_control: out std_logic_vector(4 downto 0);
        o_store_src: out std_logic_vector(1 downto 0);
        o_load_src: out std_logic_vector(2 downto 0)
    );
end entity alu_decoder;

architecture Behavioral of alu_decoder is

    signal branch : std_logic := '0';

begin

    o_pc_src <= (branch and i_zero) or o_jump;

    proc_alu_decoder: process(all)
    begin
        case i_opcode is
            -- R type
            when "0110011" =>
                o_reg_write <= '1';
                o_imm_src <= "000";   -- dont care
                o_alu_src <= '0';
                o_mem_write <= '0';
                o_result_src <= "00";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                if i_funct3 = "000" and i_funct7 = "0000000" then       -- ADD
                    o_alu_control <= "00000";
                elsif i_funct3 = "000" and i_funct7 = "0100000" then    -- SUB
                    o_alu_control <= "00001";
                elsif i_funct3 = "100" and i_funct7 = "0000000" then    -- XOR
                    o_alu_control <= "00100";
                elsif i_funct3 = "110" and i_funct7 = "0000000" then    -- OR
                    o_alu_control <= "00011";
                elsif i_funct3 = "111" and i_funct7 = "0000000" then    -- AND
                    o_alu_control <= "00010";
                elsif i_funct3 = "001" and i_funct7 = "0000000" then    -- SLL
                    o_alu_control <= "00101";
                elsif i_funct3 = "101" and i_funct7 = "0000000" then    -- SRL
                    o_alu_control <= "00110";
                elsif i_funct3 = "101" and i_funct7 = "0100000" then    -- SRA
                    o_alu_control <= "00111";
                elsif i_funct3 = "010" and i_funct7 = "0000000" then    -- SLT
                    o_alu_control <= "01001";
                elsif i_funct3 = "011" and i_funct7 = "0000000" then    -- SLTU
                    o_alu_control <= "01000";
                else
                    o_alu_control <= (others => '-');
                end if;

            -- I type addi
            when "0010011" =>
                o_reg_write <= '1';
                o_imm_src <= "000";   -- dont care
                o_alu_src <= '1';
                o_mem_write <= '0';
                o_result_src <= "00";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                if i_funct3 = "000" then             -- ADDI
                    o_alu_control <= "00000";
                elsif i_funct3 = "100" then          -- XORI
                    o_alu_control <= "00100";
                elsif i_funct3 = "110" then          -- ORI
                    o_alu_control <= "00011";
                elsif i_funct3 = "111" then          -- ANDI
                    o_alu_control <= "00010";
                elsif i_funct3 = "001" and i_funct7 = "0000000" then  -- SLLI
                    o_alu_control <= "01010";
                elsif i_funct3 = "101" and i_funct7 = "0000000" then  -- SRLI
                    o_alu_control <= "01011";
                elsif i_funct3 = "101" and i_funct7 = "0100000" then  -- SRAI
                    o_alu_control <= "01100";
                elsif i_funct3 = "010" then          -- SLTI
                    o_alu_control <= "01001";
                elsif i_funct3 = "011" then          -- SLTIU
                    o_alu_control <= "01000";
                else
                    o_alu_control <= (others => '-');
                end if;

            -- load instruction
            when "0000011" =>
                o_alu_control <= "00000";   -- load
                o_reg_write <= '1';
                o_imm_src <= "000";
                o_alu_src <= '1';
                o_mem_write <= '0';
                o_result_src <= "01";
                branch <= '0';
                -- o_alu_op <= "00";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                -- o_load_src <= "010";
                if i_funct3 = "000" then
                    o_load_src <= "000";
                elsif i_funct3 = "001" then
                    o_load_src <= "001";
                elsif i_funct3 = "010" then
                    o_load_src <= "010";
                elsif i_funct3 = "011" then
                    o_load_src <= "011";
                elsif i_funct3 = "100" then
                    o_load_src <= "100";
                end if;

            -- store instruction
            when "0100011" =>
                o_alu_control <= "00000";   -- store
                o_reg_write <= '0';
                o_imm_src <= "001";
                o_alu_src <= '1';
                o_mem_write <= '1';
                o_result_src <= "00";
                branch <= '0';
                -- o_alu_op <= "00";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                -- o_store_src <= "00";
                o_load_src <= "010";
                if i_funct3 = "000" then
                    o_store_src <= "00";   -- SB
                elsif i_funct3 = "001" then
                    o_store_src <= "01";   -- SHW
                elsif i_funct3 = "010" then
                    o_store_src <= "10";   -- SW
                end if;

            -- B type
            when "1100011" =>
                o_reg_write <= '0';
                o_imm_src <= "010";
                o_alu_src <= '0';
                o_mem_write <= '0';
                o_result_src <= "00";
                branch <= '1';
                -- o_alu_op <= "10";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                if i_funct3 = "000" then             -- BEQ
                    o_alu_control <= "00001";
                elsif i_funct3 = "001" then          -- BNE
                    o_alu_control <= "01101";
                elsif i_funct3 = "100" then          -- BLT
                    o_alu_control <= "01110";
                elsif i_funct3 = "101" then          -- BGE
                    o_alu_control <= "01111";
                elsif i_funct3 = "110" then          -- BLTU
                    o_alu_control <= "01110";
                elsif i_funct3 = "111" then          -- BGEU
                    o_alu_control <= "01111";
                else
                    o_alu_control <= (others => '-');
                end if;

            -- U type LUI
            when "0110111" =>
                o_reg_write <= '1';
                o_imm_src <= "100";
                o_alu_src <= '1';
                o_mem_write <= '0';
                o_result_src <= "00";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                o_alu_control <= "10000";

            -- U type AUIPC
            when "0010111" =>
                o_reg_write <= '1';
                o_imm_src <= "100";
                o_alu_src <= '1';
                o_mem_write <= '0';
                o_result_src <= "00";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '1';
                o_store_src <= "00";
                o_load_src <= "010";
                o_alu_control <= "00000";

            -- JUMP
            when "1101111" =>
                o_reg_write <= '1';
                o_imm_src <= "011";
                o_alu_src <= '0';
                o_mem_write <= '0';
                o_result_src <= "10";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '1';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                o_alu_control <= "00000";

            -- JALR
            when "1100111" =>
                o_reg_write <= '1';
                o_imm_src <= "000";
                o_alu_src <= '0';
                o_mem_write <= '0';
                o_result_src <= "10";
                branch <= '0';
                -- o_alu_op <= "10";
                o_jump <= '1';
                o_pc_target_src <= '1';
                o_pc_alu_src <= '0';
                o_store_src <= "00";
                o_load_src <= "010";
                o_alu_control <= "00000";

            when others =>
                o_reg_write <= '0';
                o_imm_src <= (others => '0');
                o_alu_src <= '0';
                o_mem_write <= '0';
                o_result_src <= (others => '-');
                branch <= '0';
                -- o_alu_op <= "00";
                o_jump <= '0';
                o_pc_target_src <= '0';
                o_pc_alu_src <= '0';
                o_store_src <= (others => '0');
                o_load_src <= "010";
                o_alu_control <= (others => '-');
        end case;
    end process proc_alu_decoder;

end architecture Behavioral;

