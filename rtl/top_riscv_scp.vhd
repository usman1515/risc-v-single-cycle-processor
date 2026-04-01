-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: top_riscv_scp
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


entity top_riscv_scp is
    port (
        clk: in std_logic;
        rst_n: in std_logic
    );
end entity top_riscv_scp;

architecture Behavioral of top_riscv_scp is

    signal pc_src: std_logic := '0';
    signal pc_target: std_logic_vector(31 downto 0) := (others => '0');
    signal pc_next: std_logic_vector(31 downto 0) := (others => '0');
    signal mux_plus4: std_logic_vector(31 downto 0) := (others => '0');
    signal pc: std_logic_vector(31 downto 0) := (others => '0');

    signal instr: std_logic_vector(31 downto 0) := (others => '0');
    signal reg_write: std_logic := '0';
    signal read_data: std_logic_vector(31 downto 0) := (others => '0');
    signal rd1: std_logic_vector(31 downto 0) := (others => '0');
    signal rd2: std_logic_vector(31 downto 0) := (others => '0');

    signal alu_control: std_logic_vector(4 downto 0) := (others => '0');
    signal zero: std_logic := '0';
    signal alu_result: std_logic_vector(31 downto 0) := (others => '0');
    signal imm_src: std_logic_vector(2 downto 0) := (others => '0');
    signal imm_ext: std_logic_vector(31 downto 0) := (others => '0');

    signal we: std_logic := '0';
    signal result_src: std_logic_vector(1 downto 0) := (others => '0');
    signal mem_write: std_logic := '0';
    signal alu_src: std_logic := '0';
    signal alu_op: std_logic_vector(1 downto 0) := (others => '0');

    signal src_b: std_logic_vector(31 downto 0) := (others => '0');
    signal wd3: std_logic_vector(31 downto 0) := (others => '0');
    signal jump: std_logic := '0';
    signal pc_target_src: std_logic := '0';
    signal pc_src_a: std_logic_vector(31 downto 0) := (others => '0');

    signal pc_alu_src: std_logic := '0';
    signal src_a: std_logic_vector(31 downto 0) := (others => '0');
    signal store_src: std_logic_vector(1 downto 0) := (others => '0');
    signal wd: std_logic_vector(31 downto 0) := (others => '0');
    signal load_src: std_logic_vector(2 downto 0) := (others => '0');
    signal result: std_logic_vector(31 downto 0) := (others => '0');

begin

    PC_MUX : mux_2x1
        generic map (
            DATA_WIDTH => 32
        );
        port map (
            i_data_a => pc_target,
            i_data_b => mux_plus4,
            i_sel    => pc_src,
            o_data   => pc_next
        );

    PC : program_counter
        port map (
            clk => clk,
            rst_n => rst_n,
            i_pc_next => pc_next,
            o_pc => pc
        );

    INSTR_MEM : instruction_memory
        port map (
            i_addr => pc,
            o_rdata => instr
        );

    REG_FILE : register_file
        port map (
            clk => clk,
            rst_n => rst_n
            i_addr1 => instr(19 downto 15),
            i_addr2 => instr(24 downto 20),
            i_addr3 => instr(11 downto 7),
            i_we3 => reg_write,
            i_wdata3 => wd3,
            o_rdata1 => rd1,
            o_rdata2 => rd2
        );

    EXTEND : extend
        port map (
            i_instr => instr,
            i_imm_src => imm_src,
            o_imm_ext => imm_ext
        );

    MUX_REG_TO_ALU : mux_2x1
        generic map (
            DATA_WIDTH => 32
        );
        port map (
            i_data_a => pc_target,
            i_data_b => mux_plus4,
            i_sel    => pc_src,
            o_data   => pc_next
        );

    ALU : alu
        port map (
            i_alu_control => alu_control,
            i_alu_srcA => src_a,
            i_alu_srcB => src_b,
            o_alu_result => alu_result,
            o_zero => zero
        );

    MUX_STORE : mux_store
        port map (
            i_rd2 => rd2,
            i_store_src => store_src,
            o_wd => wd
        );

    MUX_LOAD : mux_load
        port map (
            i_result => result,
            i_load_src => load_src,
            o_wd3 => wd3
        );

    DATA_MEM : data_memory
        port map (
            clk => clk,
            rst_n => rst_n,
            i_we => mem_write,
            i_addr => alu_result,
            i_wdata => wd,
            o_rdata => read_data
        );

    MUX_DM_TO_REG : mux_4x1
        generic map (
            DATA_WIDTH => 32
        );
        port map (
            i_data_a => alu_result,
            i_data_b => read_data,
            i_data_c => mux_plus4,
            i_data_d => open,
            i_sel => result_src,
            o_data => result
        );

    PC_TARGET : program_counter_target
        port map (
            i_pc_src_a => pc_src_a,
            i_imm_ext => imm_ext,
            o_pc_plus4 => pc_target
        );

    ALU_DECODER : alu_decoder
        port map (
            i_opcode => instr(6 downto 0),
            i_funct7 => instr(31 downto 25),
            i_funct3 => instr(14 downto 12),
            i_zero => zero,
            o_pc_src => pc_src,
            o_pc_target_src => pc_target_src,
            o_result_src => result_src,
            o_mem_write => mem_write,
            o_alu_src => alu_src,
            o_imm_src => imm_src,
            o_reg_write => reg_write,
            o_jump => jump,
            o_pc_alu_src => pc_alu_src,
            o_alu_control => alu_control,
            o_store_src => store_src,
            o_load_src => load_src
        );

    REG_TO_PC_TARGET : mux_2x1
        generic map (
            DATA_WIDTH => 32
        );
        port map (
            i_data_a => rd1,
            i_data_b => pc,
            i_sel    => pc_target_src,
            o_data   => pc_src_a
        );

    MUX_PC_TO_ALU : mux_2x1
        generic map (
            DATA_WIDTH => 32
        );
        port map (
            i_data_a => pc,
            i_data_b => rd1,
            i_sel    => pc_alu_src,
            o_data   => src_a
        );

end architecture Behavioral;

