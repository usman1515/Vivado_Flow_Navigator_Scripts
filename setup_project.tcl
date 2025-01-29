#!/bin/tclsh

# Link: https://docs.amd.com/r/2021.2-English/ug895-vivado-system-level-design-entry/Creating-a-Project-Using-a-Tcl-Script
# Typical usage: vivado -mode tcl -source ./scripts/setup_prj_vcu118.tcl

source ./scripts/color_func.tcl -notrace


# ----- INFO: set project name and directory
set prj_name    "<fpga_project_name>"
set prj_dir     "./${prj_name}"


# ----- INFO: set FPGA part and board
# ----- Basys 3
set part        "xc7a35tcpg236-1"
set board_part  "digilentinc.com:basys3:part0:1.0"
# # ----- Nexys A7 100T
# set part        "xc7a100tcsg324-1"
# set board_part  "digilentinc.com:nexys-a7-100t:part0:1.0"
# # ----- VCU118
# set part        "xcvu9p-flga2104-2L-e"
# set board_part  "xilinx.com:vcu118:part0:2.4"


# ----- INFO: set RTL and TB language
set rtl_lang    "VHDL"
set tb_lang     "Verilog"
set default_lib "xil_defaultlib"


# ----- INFO: set RTL top module
# set RTL top
set top_module_rtl  "TOP_RTL"
# for TB top. for simulation purposes only
# set top_module_tb   "TOP_TB"



# create a new project
print_yellow "creating new project: ${prj_name}"
create_project -force $prj_name $prj_dir -part $part

# set the project parameters
print_yellow "setting project parameters"
set_property board_part $board_part [current_project]
set_property default_lib $default_lib [current_project]
set_property target_language $rtl_lang [current_project]
set_property simulator_language $tb_lang [current_project]


# ----- INFO: OPTIONAL -specify XCI files if youre using any Xilinx IP blocks or UniMacros
print_yellow "adding IP blocks"
add_files -norecurse ./ip/<ip_block>.xci

# ----- INFO: add VHDL rtl source files to the project
print_yellow "adding RTL source files"
add_files -force -fileset sources_1 {
    ./rtl/rtl_file_1.vhd \
    ./rtl/rtl_file_2.vhd \
    ./rtl/rtl_file_N.vhd
}

# convert all VHDL files to VHDL 2008 standard
print_yellow "converting all VHDL files to VHDL 2008 standard"
foreach file [get_files -filter {FILE_TYPE == VHDL}] {
    set_property file_type {VHDL 2008} $file
}

# set RTL top module - for design and implementation purposes
print_yellow "setting RTL top module"
set_property top ${top_module_rtl} [current_fileset]
# set TB top module - for testbench simulation purposes
# set_property top ${top_module_tb} [current_fileset]


# ----- INFO: add Verilog TB source files to the project
print_yellow "adding TB source files"
add_files -force -fileset sim_1 {
    ./tb/tb_file_1.v \
    ./tb/tb_file_2.v \
    ./tb/tb_file_N.v
}

# ----- INFO: add top level IO constraints
print_yellow "adding constraint files for IO"
add_files -fileset constrs_1 ./constraints/<fpga_board_IO_xdc_file>.xdc

# update to set top and file compile order
print_yellow "update compilation order"
print_blue "update_compile_order: sources"
update_compile_order -fileset sources_1
print_blue "update_compile_order: sims"
update_compile_order -fileset sim_1

# report compilation order
print_yellow "report compilation order"
print_blue "report compilation order: sources"
report_compile_order -fileset sources_1
print_blue "report compilation order: sims"
report_compile_order -fileset sim_1

# close the project
close_project
exit

