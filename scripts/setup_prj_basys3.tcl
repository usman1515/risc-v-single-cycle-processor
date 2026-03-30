#!/bin/tclsh

# Link: https://docs.amd.com/r/2021.2-English/ug895-vivado-system-level-design-entry/Creating-a-Project-Using-a-Tcl-Script
# Typical usage: vivado -mode tcl -source ./scripts/setup_prj_nexys_a7_100t.tcl

source ./scripts/color_func.tcl -notrace

# # set project name and FPGA (Basys 3)
set prj_name "basys3_riscv_single_cycle_processor"
set part "xc7a35tcpg236-1"
set board_part "digilentinc.com:basys3:part0:1.2"

# set language
set rtl_lang "VHDL"
set tb_lang "Verilog"
set default_lib "xil_defaultlib"

# for synthesis and implementation purposes
set top_module_rtl "top_riscv_scp"
# for testbench simulation purposes only
set top_module_tb "tb_top_riscv_scp"

# create a new project
set prj_dir "./${prj_name}"
print_yellow "creating new project: ${prj_name}"
create_project -force $prj_name $prj_dir -part $part

# set the project parameters
print_yellow "setting project parameters"
set_property board_part $board_part [current_project]
set_property default_lib $default_lib [current_project]
set_property target_language $rtl_lang [current_project]
set_property simulator_language $tb_lang [current_project]

# add Verilog RTL source files to the project
print_yellow "adding RTL source files"
add_files -force -fileset sources_1 {
    ./rtl/rtl_components.vhd \
    ./rtl/alu.vhd \
    ./rtl/alu_decoder.vhd \
    ./rtl/data_memory.vhd \
    ./rtl/extend.vhd \
    ./rtl/instruction_memory.vhd \
    ./rtl/mux_2x1.vhd \
    ./rtl/mux_4x1.vhd \
    ./rtl/mux_load.vhd \
    ./rtl/mux_store.vhd \
    ./rtl/pc.vhd \
    ./rtl/pc_next.vhd \
    ./rtl/pc_target.vhd \
    ./rtl/register_file.vhd \
    ./rtl/top_riscv_scp.vhd
}

# convert all VHDL files to VHDL 2008 standard
print_yellow "converting all VHDL files to VHDL 2008 standard"
foreach file [get_files -filter {FILE_TYPE == VHDL}] {
    set_property file_type {VHDL 2008} $file
}

# add TB source files to the project
print_yellow "adding TB source files"
add_files -force -fileset sim_1 {
    ./rtl/tb_alu.sv \
    ./rtl/tb_alu_decoder.sv \
    ./rtl/tb_data_memory.sv \
    ./rtl/tb_extend.sv \
    ./rtl/tb_instruction_memory.sv \
    ./rtl/tb_mux_2x1.sv \
    ./rtl/tb_mux_4x1.sv \
    ./rtl/tb_mux_load.sv \
    ./rtl/tb_mux_store.sv \
    ./rtl/tb_pc.sv \
    ./rtl/tb_pc_next.sv \
    ./rtl/tb_pc_target.sv \
    ./rtl/tb_register_file.sv \
    ./rtl/tb_top_riscv_scp.sv
}

# set RTL top module - for design and implementation purposes
print_yellow "setting RTL top module"
set_property top ${top_module_rtl} [current_fileset]
# set TB top module - for testbench simulation purposes
print_yellow "setting TB top module"
set_property top ${top_module_tb} [current_fileset]

# add constraint files to the project
print_yellow "adding constraint files for IO, timing, etc"
# top level IO constraints
add_files -fileset constrs_1 ./constraints/io_basys3.xdc

# update to set top and file compile order
print_yellow "update compilation order"
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
update_compile_order -fileset constrs_1

# report compilation order
print_yellow "report compilation order"
report_compile_order -fileset sources_1
report_compile_order -fileset sim_1
report_compile_order -fileset constrs_1

# close the project
close_project

