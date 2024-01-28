# run script
# vivado -mode batch -source ./scripts/main.tcl -notrace

# # Print the total number of arguments
# puts "Total number of arguments: $argc"
# # Print each cmd line argument
# foreach arg $argv {
#     puts "Argument: $arg"
# }

# * pwd
set prj_dir         [pwd]
set prj_name        [file tail $prj_dir]

puts "prj_dir:          $prj_dir"
puts "prj_name:         $prj_name"

# * vars global - basys 3
set fpga_model_no   "xc7a35tcpg236-1"
set board_model_no  "digilentinc.com:basys3:part0:1.0"
set top_module_rtl  "TEST_SORTER_TOP"

# * vars rtl analysis
set name_run_rtl        "rtl_1"
set name_chkp_ip        "post_ip_synth"
set name_chkp_rtl       "post_rtl_analysis"

# * vars synthesis
set name_run_synth      "synth_1"
set name_chkp_synth     "post_synth"
set name_rpt_clk        "post_synth_clocks"
set name_rpt_timing     "post_synth_timing"
set name_rpt_util       "post_synth_utilization"

# * vars implementation
# opt_design
set name_run_impl1      "impl_1"
set name_chkp_impl1     "post_impl1_opt_design"
set name_rpt_clk1       "post_impl1_clocks"
set name_rpt_timing1    "post_impl1_timing"
set name_rpt_util1      "post_impl1_utilization"
# power_opt_design
set name_run_impl2      "impl_2"
set name_chkp_impl2     "post_impl2_power_opt_design"
set name_rpt_clk2       "post_impl2_clocks"
set name_rpt_timing2    "post_impl2_timing"
set name_rpt_util2      "post_impl2_utilization"
# place_design
set name_run_impl3      "impl_3"
set name_chkp_impl3     "post_impl3_place_design"
set name_rpt_clk3       "post_impl3_clocks"
set name_rpt_timing3    "post_impl3_timing"
set name_rpt_util3      "post_impl3_utilization"
# phys_opt_design
set name_run_impl4      "impl_4"
set name_chkp_impl4     "post_impl4_phys_opt_design"
set name_rpt_clk4       "post_impl4_clocks"
set name_rpt_timing4    "post_impl4_timing"
set name_rpt_util4      "post_impl4_utilization"
# route_design
set name_run_impl5      "impl_5"
set name_chkp_impl5     "post_impl5_route_design"
set name_rpt_clk5       "post_impl5_clocks"
set name_rpt_timing5    "post_impl5_timing"
set name_rpt_util5      "post_impl5_utilization"

# * vars bitstream
set name_bitstream      "bitstream_${prj_name}"
set name_run_bit        "bit_1"
set name_rpt_clk6       "post_bit_clocks"
set name_rpt_timing6    "post_bit_timing"
set name_rpt_util6      "post_bit_utilization"

# * paths global
set vhdl_rtl_dir    "${prj_dir}/${prj_name}.srcs/sources_1/new"
set vhdl_ip_srcs    "${prj_dir}/${prj_name}.srcs/sources_1/ip"
set dir_constraint  "${prj_dir}/${prj_name}.srcs/constrs_1/new"
set dir_rpt         "reports"
set dir_chkp        "checkpoints"


# * create in memory project
# set fpga
set_part ${fpga_model_no}
# set board - comment for basys3
# set_property board_part ${board_model_no} [current_project]
# set max threads for implementation phases 1-8
set_param general.maxThreads 4


# create reports dir
if {![file isdirectory $dir_rpt]} {
    file mkdir -p $dir_rpt
    puts "\nDirectory created: $dir_rpt"
} else {
    puts "\nDirectory already exists: $dir_rpt"
}
# create checkpoints dir
if {![file isdirectory $dir_chkp]} {
    file mkdir -p $dir_chkp
    puts "\nDirectory created: $dir_chkp"
} else {
    puts "\nDirectory already exists: $dir_chkp"
}


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

# ===================================== Step 4: Generate Bitstream
source scripts/gen_bitstream.tcl
