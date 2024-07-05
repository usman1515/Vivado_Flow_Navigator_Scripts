source scripts/color_func.tcl

# get start time
print_blue "Run started at:     [clock format [clock seconds] -format "%d-%b-%Y - %I:%M:%S - %p"]"
set current_datetime [clock format [clock seconds] -format "%Y-%m-%d_%H:%M:%S"]

# * pwd
set prj_dir             [pwd]
set prj_name            [file tail $prj_dir]

# * vars global - fpga and board part num
# --- basys 3
set fpga_part_name      "xc7a35tcpg236-1"
set board_part_name     "digilentinc.com:basys3:part0:1.0"
set top_module_rtl      "TEST_SORTER_TOP"
# --- vcu118
# set fpga_part_name      "xcvu9p-flga2104-2L-e"
# set board_part_name     "xilinx.com:vcu118:part0:2.4"
# set top_module_rtl      "TEST_SORTER_TOP"


# * vars rtl analysis
set name_run_rtl        "rtl_1"
set name_chkp_ip        "post_ip_synth"
set name_chkp_rtl       "post_rtl_analysis"

# * vars synthesis
set name_run_synth      "synth_1"
set name_chkp_synth     [lindex $argv 0]
set name_rpt_clk        "post_synth_clocks"
set name_rpt_timing     "post_synth_timing"
set name_rpt_util       [lindex $argv 7]

# * vars implementation
# opt_design
set name_run_impl1      "impl_1"
set name_chkp_impl1     [lindex $argv 1]
set name_rpt_clk1       "post_impl1_clocks"
set name_rpt_timing1    "post_impl1_timing"
set name_rpt_util1      [lindex $argv 8]
# power_opt_design
set name_run_impl2      "impl_2"
set name_chkp_impl2     [lindex $argv 2]
set name_rpt_clk2       "post_impl2_clocks"
set name_rpt_timing2    "post_impl2_timing"
set name_rpt_util2      [lindex $argv 9]
# place_design
set name_run_impl3      "impl_3"
set name_chkp_impl3     [lindex $argv 3]
set name_rpt_clk3       "post_impl3_clocks"
set name_rpt_timing3    "post_impl3_timing"
set name_rpt_util3      [lindex $argv 10]
# phys_opt_design
set name_run_impl4      "impl_4"
set name_chkp_impl4     [lindex $argv 4]
set name_rpt_clk4       "post_impl4_clocks"
set name_rpt_timing4    "post_impl4_timing"
set name_rpt_util4      [lindex $argv 11]
# route_design
set name_run_impl5      "impl_5"
set name_chkp_impl5     [lindex $argv 5]
set name_rpt_clk5       "post_impl5_clocks"
set name_rpt_timing5    "post_impl5_timing"
set name_rpt_util5      [lindex $argv 12]

# * vars bitstream
set name_bitstream      "[lindex $argv 6]"
set name_run_bit        "bit_1"
set name_rpt_clk6       "post_bit_clocks"
set name_rpt_timing6    "post_bit_timing"
set name_rpt_util6      [lindex $argv 13]

# * paths global
set vhdl_rtl_dir        "${prj_dir}/${prj_name}.srcs/sources_1/imports"
set vhdl_tb_dir         "${prj_dir}/${prj_name}.srcs/sim_1/imports"
set ip_blk_srcs         "${prj_dir}/${prj_name}.srcs/sources_1/ip"
set dir_constraint      "${prj_dir}/${prj_name}.srcs/constrs_1/new"
set dir_bin             "bin"
set dir_rpt             "${dir_bin}/reports"
set dir_chkp            "${dir_bin}/checkpoints"
set dir_logs            "${dir_bin}/logs"

# * create in memory project
# set fpga
set_part ${fpga_part_name}
# set board - comment for basys3
set_property board_part ${board_part_name} [current_project]

# * set max threads for implementation phases 1-8
set_param general.maxThreads 8


# create output dir
if {![file isdirectory $dir_rpt]} {
    file mkdir -p $dir_rpt
    print_blue "\nDirectory created: $dir_rpt"
} else {
    print_blue "\nDirectory already exists: $dir_rpt"
}
# create checkpoints dir
if {![file isdirectory $dir_chkp]} {
    file mkdir -p $dir_chkp
    print_blue "\nDirectory created: $dir_chkp"
} else {
    print_blue "\nDirectory already exists: $dir_chkp"
}
# create logs dir
if {![file isdirectory $dir_logs]} {
    file mkdir -p $dir_logs
    print_blue "\nDirectory created: $dir_logs"
} else {
    print_blue "\nDirectory already exists: $dir_logs"
}

# default message limit for all messages = 100
set_param messaging.defaultLimit 1000
set msg_limit [get_param messaging.defaultLimit]
print_blue "\nMessages default limit: $msg_limit"


# ===================================== Print all vars and paths
source scripts/vars.tcl
# source scripts/convert_filetype_vhdl2008.tcl

# ===================================== Step 1: RTL analysis
source scripts/rtl_analysis.tcl

# ===================================== Step 2: Synthesis
source scripts/synthesis.tcl

# ===================================== Step 3: Implementation
# ===================================== Step 3.1: opt_design
source scripts/impl_s1_opt_design.tcl

# ===================================== Step 3.2: power_opt_design (optional)
source scripts/impl_s2_power_opt_design.tcl

# ===================================== Step 3.3: place_design
source scripts/impl_s3_place_design.tcl

# ===================================== Step 3.4: phys_opt_design (optional)
source scripts/impl_s4_phys_opt_design.tcl

# ===================================== Step 3.5: route_design
source scripts/impl_s5_route_design.tcl

# # ===================================== Step 4: Generate Bitstream
source scripts/gen_bitstream.tcl



# copy current log generated to logs folder
file copy -force [file join $prj_dir vivado.log] [file join $dir_logs "vivado_${current_datetime}.log"]
print_blue "Log file copied to: [file join $dir_logs "vivado_${current_datetime}.log"]"