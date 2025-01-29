source scripts/color_func.tcl

# get start time
print_blue "Run started at:     [clock format [clock seconds] -format "%d-%b-%Y - %I:%M:%S - %p"]"
set current_datetime [clock format [clock seconds] -format "%Y-%m-%d_%H:%M:%S"]

# project working dir
set prj_dir             [pwd]
set prj_name            [file tail $prj_dir]

# FPGA and board part numbers:
# INFO: comment out unecessary ones.
# ----- Basys 3
set fpga_part_name      "xc7a35tcpg236-1"
set board_part_name     "digilentinc.com:basys3:part0:1.0"
# # ----- Nexys A7 100T
# set fpga_part_name      "xc7a100tcsg324-1"
# set board_part_name     "digilentinc.com:nexys-a7-100t:part0:1.0"
# # ----- VCU118
# set fpga_part_name      "xcvu9p-flga2104-2L-e"
# set board_part_name     "xilinx.com:vcu118:part0:2.4"


# ----- INFO: set name for top RTL and TB module here
set top_module_rtl      "<top_rtl_module>"
set top_module_tb       "<top_tb_module>"



# vars synthesis
set name_run_synth      "run_synthesis"
set name_chkp_synth     [lindex $argv 0]
set name_rpt_synth      "synthesis"

# vars implementation
# opt_design
set name_run_impl1      "run_impl1_opt_design"
set name_chkp_impl1     [lindex $argv 1]
set name_rpt_impl1      "impl1_opt_design"
# power_opt_design
set name_run_impl2      "run_impl2_power_opt_design"
set name_chkp_impl2     [lindex $argv 2]
set name_rpt_impl2      "impl2_power_opt_design"
# place_design
set name_run_impl3      "run_impl3_place_design"
set name_chkp_impl3     [lindex $argv 3]
set name_rpt_impl3      "impl3_place_design"
# phys_opt_design
set name_run_impl4      "run_impl4_phys_opt_design"
set name_chkp_impl4     [lindex $argv 4]
set name_rpt_impl4      "impl4_phys_opt_design"
# route_design
set name_run_impl5      "run_impl5_route_design"
set name_chkp_impl5     [lindex $argv 5]
set name_rpt_impl5      "impl5_route_design"
# post_route_design
set name_run_impl6      "run_impl6_post_route_design"
set name_rpt_impl6      "impl6_post_route_design"

# vars bitstream
set name_run_bit        "run_bitstream"
set name_bitstream      [lindex $argv 6]
set name_rpt_bit        "bitstream"

# ----- PATHS for RTL, TB, constraints, binaries, reports, DCPs, logs
set dir_rtl_vhdl        "${prj_dir}/rtl"
set dir_rtl_veri        "${prj_dir}/rtl"
set dir_ip_srcs         "${prj_dir}/ip"
set dir_constraint      "${prj_dir}/constraints"
set dir_bin             "bin"
set dir_rpt             "${dir_bin}/reports"
set dir_chkp            "${dir_bin}/checkpoints"
set dir_logs            "${dir_bin}/logs"
set dir_testbench       "${dir_bin}/testbench"



# ----- create in memory project
# set fpga
set_part ${fpga_part_name}
# set board - comment for basys3
set_property board_part ${board_part_name} [current_project]

# set max threads for implementation phases 1-8
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
# create testbench dir
if {![file isdirectory $dir_testbench]} {
    file mkdir -p $dir_testbench
    print_blue "\nDirectory created: $dir_testbench"
} else {
    print_blue "\nDirectory already exists: $dir_testbench"
}

# default message limit for all messages = 100
set_param messaging.defaultLimit 1000
set msg_limit [get_param messaging.defaultLimit]
print_blue "\nMessages default limit: $msg_limit"


# ----- INFO: main flow scripts
# synthesis
source scripts/vars.tcl
source scripts/rtl_analysis.tcl
source scripts/synthesis.tcl

# implementation
source scripts/impl_s1_opt_design.tcl
source scripts/impl_s2_power_opt_design.tcl
source scripts/impl_s3_place_design.tcl
source scripts/impl_s4_phys_opt_design.tcl
source scripts/impl_s5_route_design.tcl
# source scripts/impl_s6_post_route_design.tcl
source scripts/gen_bitstream.tcl



# copy current log generated to logs folder
file copy -force [file join $prj_dir vivado.log] [file join $dir_logs "vivado_${current_datetime}.log"]
print_blue "Log file copied to: [file join $dir_logs "vivado_${current_datetime}.log"]"
