-- ////////////////////////////////////////////////////////////////////////////////
-- Company:
-- Engineer:
--
-- Design Name:
-- Module Name: rtl_components
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



package rtl_components is

    component alu is
        port (
            i_alu_control: in std_logic_vector(4 downto 0);
            i_alu_srcA: in std_logic_vector(31 downto 0);
            i_alu_srcB: in std_logic_vector(31 downto 0);
            o_alu_result: out std_logic_vector(31 downto 0);
            o_zero: out std_logic
        );
    end component alu;

    component alu_decoder is
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
    end component alu_decoder;

    component extend is
        port (
            i_instr: in std_logic_vector(31 downto 0);
            i_imm_src: in std_logic_vector(2 downto 0);
            o_imm_ext: out std_logic_vector(31 downto 0)
        );
    end component extend;

    component mux_2x1 is
        generic (
            DATA_WIDTH: integer := 32
        );
        port (
            i_data_a: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_data_b: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_sel: in std_logic;
            o_data: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component mux_2x1;

    component mux_4x1 is
        generic (
            DATA_WIDTH: integer := 32
        );
        port (
            i_data_a: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_data_b: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_data_c: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_data_d: in std_logic_vector(DATA_WIDTH-1 downto 0);
            i_sel: in std_logic;
            o_data: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component mux_4x1;

    component mux_load is
        port (
            i_result: in std_logic_vector(31 downto 0);
            i_load_src: in std_logic_vector(2 downto 0);
            o_wd3: out std_logic_vector(31 downto 0)
        );
    end component mux_load;

    component mux_store is
        port (
            i_rd2: in std_logic_vector(31 downto 0);
            i_store_src: in std_logic_vector(1 downto 0);
            o_wd: out std_logic_vector(31 downto 0)
        );
    end component mux_store;

    component program_counter is
        port (
            clk: in std_logic;
            rst_n: in std_logic;
            i_pc_next: in std_logic_vector(31 downto 0);
            o_pc: out std_logic_vector(31 downto 0)
        );
    end component program_counter;

    component program_counter_next is
        port (
            i_pc: in std_logic_vector(31 downto 0);
            o_pc_plus4: out std_logic_vector(31 downto 0)
        );
    end component program_counter_next;

    component program_counter_target is
        port (
            i_pc_src_a: in std_logic_vector(31 downto 0);
            i_imm_ext: in std_logic_vector(31 downto 0);
            o_pc_plus4: out std_logic_vector(31 downto 0)
        );
    end component program_counter_target;

    component data_memory is
        port (
            clk: in std_logic;
            rst_n: in std_logic;
            i_we: in std_logic;
            i_addr: in std_logic_vector(31 downto 0);
            i_wdata: in std_logic_vector(31 downto 0);
            o_rdata: out std_logic_vector(31 downto 0)
        );
    end component data_memory;

    component register_file is
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
    end component register_file;

    component instruction_memory is
        port (
            i_addr: in std_logic_vector(31 downto 0);
            o_rdata: out std_logic_vector(31 downto 0)
        );
    end component instruction_memory;

    component top_riscv_scp is
        port (
            clk: in std_logic;
            rst_n: in std_logic
        );
    end component top_riscv_scp;

end package rtl_components;
