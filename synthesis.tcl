# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/synth_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]


# read all VHDL RTL files
print_yellow "reading VHDL rtl files"
set vhdl_files [glob -directory $dir_rtl_vhdl -types f -join *.vhd]
read_vhdl -library xil_defaultlib -vhdl2008 -verbose $vhdl_files

# read all Verilog RTL files
print_yellow "reading Verilog RTL files"
set veri_files [glob -directory $dir_rtl_veri -types f -join *.sv]
read_verilog -library xil_defaultlib -verbose $veri_files

# ----- INFO: add all the Xilinx IP blocks XCI here
# read IP sources
print_yellow "reading IP sources for:   $board_part_name"
read_ip -verbose $dir_ip_srcs/<ip_block>.xci
print_blue "importing IP sources for:   $board_part_name"
import_ip -verbose $dir_ip_srcs/<ip_block>.xci -name <ip_block_INST_name>
print_blue "creating IP run for:        $board_part_name"
generate_target all [get_ips -filter {NAME =~ <ip_block>}]
print_blue "upgarding IP sources for:   $board_part_name"
upgrade_ip [get_ips -filter {NAME =~ <ip_block>}] -verbose
print_blue "synthesize the IP to generate the DCP"
synth_ip [get_files -filter {IP_FILE == $dir_ip_srcs/<ip_block>.xci}]

# ----- INFO: add IO constraint file here
# read constraint files
print_yellow "reading IO constraint source file/s"
read_xdc ${dir_constraint}/<io_constraint_file>.xdc

# set constraint files for synthesis and implementation
set_property used_in_synthesis true [get_files $dir_constraint/<io_constraint_file> .xdc]
set_property used_in_implementation true [get_files $dir_constraint/<io_constraint_file>.xdc]

# set top module RTL
print_yellow "set top module RTL"
set_property top ${top_module_rtl} [current_fileset]

# update and report compilation order
print_yellow "update_compile_order sources_1"
update_compile_order -fileset sources_1
print_yellow "report_compile_order sources_1"
report_compile_order -fileset sources_1
print_yellow "report_compile_order constrs_1"
report_compile_order -fileset constrs_1

# OPTIONAL step: upgrade and synthesize all .xci IPs
print_yellow "upgrading .xci IPs"
upgrade_ip [get_ips] -verbose
print_yellow "synthesizing .xci IPs"
# synth_ip [get_ips] -force
synth_ip [get_ips]

# print IP status for .xci files
print_yellow "print IP status for .xci files"
report_ip_status

# run synthesis
print_yellow "running synthesis"
synth_design \
    -name ${name_run_synth} -top ${top_module_rtl} -part ${fpga_part_name} \
    -flatten_hierarchy rebuilt \
    -gated_clock_conversion off \
    -bufg 12 \
    -fsm_extraction gray \
    -resource_sharing auto \
    -control_set_opt_threshold auto \
    -shreg_min_size 10 \
    -max_bram -1 \
    -max_dsp -1 \
    -max_bram_cascade_height -1 \
    -max_uram_cascade_height -1 \
    -no_srlextract \
    -cascade_dsp auto \
    -retiming \
    -directive AreaOptimized_High \
    -incremental_mode aggressive
# -max_uram -1 \
# -mode out_of_context \

# * write synthesis checkpoint
print_yellow "writing checkpoint: ${name_chkp_synth}"
write_checkpoint -force ${dir_chkp}/${name_chkp_synth}.dcp

# * write reports
print_yellow "writing reports: post synthesis"

# timing reports
print_blue "writing report_timing_summary"
report_timing_summary -check_timing_verbose -delay_type min_max -max_paths 10 -report_unconstrained -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_synth}_report_timing_summary.rpt
print_blue "writing report_timing"
report_timing -delay_type min_max -sort_by group -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_synth}_report_timing.rpt
print_blue "writing check_timing"
check_timing -verbose -file ${dir_rpt}/${name_rpt_synth}_check_timing.rpt
print_blue "writing report_config_timing"
report_config_timing -all -file ${dir_rpt}/${name_rpt_synth}_report_config_timing.rpt
print_blue "writing create_slack_histogram"
create_slack_histogram -significant_digits 3 -file ${dir_rpt}/${name_rpt_synth}_create_slack_histogram.rpt
print_blue "writing report_clock_interaction"
report_clock_interaction -delay_type min_max -significant_digits 3 -file ${dir_rpt}/${name_rpt_synth}_report_clock_interaction.rpt
print_blue "writing report_cdc"
report_cdc -file ${dir_rpt}/${name_rpt_synth}_report_cdc.rpt
print_blue "writing report_exceptions"
report_exceptions -coverage -file ${dir_rpt}/${name_rpt_synth}_report_exceptions.rpt
print_blue "writing report_clock_networks"
report_clock_networks -file ${dir_rpt}/${name_rpt_synth}_report_clock_networks.rpt
print_blue "writing report_pulse_width"
report_pulse_width -significant_digits 3 -file ${dir_rpt}/${name_rpt_synth}_report_pulse_width.rpt

print_blue "writing report_methodology"
report_methodology -file ${dir_rpt}/${name_rpt_synth}_report_methodology.rpt
print_blue "writing report_clock_utilization"
report_clock_utilization -file ${dir_rpt}/${name_rpt_synth}_clock_utilization.rpt

print_blue "writing report_incremental_reuse -hierarchical"
report_incremental_reuse -hierarchical -file ${dir_rpt}/${name_rpt_synth}_report_incremental_reuse_hierarchical.rpt
print_blue "writing report_ip_status"
report_ip_status -file ${dir_rpt}/${name_rpt_synth}_report_ip_status.rpt
print_blue "writing report_power"
report_power -file ${dir_rpt}/${name_rpt_synth}_report_power.rpt
print_blue "writing report_ram_utilization"
report_ram_utilization -file ${dir_rpt}/${name_rpt_synth}_report_ram_utilization.rpt

print_blue "writing report_utilization"
report_utilization -file ${dir_rpt}/${name_rpt_synth}_report_utilization.rpt
print_blue "writing report_utilization -hierarchical"
report_utilization -hierarchical -file ${dir_rpt}/${name_rpt_synth}_report_utilization_hierarchical.rpt



# * get elapsed time
# get end time
set end_time [clock seconds]
# calculate elapsed time in seconds
set elapsed_time [expr {$end_time - $start_time}]
# convert seconds to dd:hh:mm:ss format
set days [expr {$elapsed_time / (24 * 3600)}]
set rem_sec [expr {$elapsed_time % (24 * 3600)}]
set hours [expr {$rem_sec / 3600}]
set rem_sec [expr {$rem_sec % 3600}]
set minutes [expr {$rem_sec / 60}]
set seconds [expr {$rem_sec % 60}]
# print total time taken
print_blue "Simulation started at:  [clock format $start_time -format "%d-%b-%Y - %I:%M:%S - %p"]"
print_blue "Simulation ended at:    [clock format $end_time -format "%d-%b-%Y - %I:%M:%S - %p"]"
print_green "Synthesis time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"