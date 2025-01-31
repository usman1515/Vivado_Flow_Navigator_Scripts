# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/opt_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]


# open previous checkpoint
print_yellow "reading checkpoint: ${name_chkp_synth}"
open_checkpoint ${dir_chkp}/${name_chkp_synth}.dcp

# ----- INFO: read pblock constarints. add pblock XDC files here
print_yellow "read pblock constraint file/s"
read_xdc ${dir_constraint}/pblk_<constraint_file>.xdc
read_xdc ${dir_constraint}/io_<constraint_file>.xdc

# * run opt_design
print_yellow "running implementation phase: opt_design"
# opt_design -directive Default -verbose -debug_log
opt_design -directive ExploreWithRemap -verbose -debug_log
# opt_design -aggressive_remap -verbose -debug_log

# * write checkpoint
print_yellow "writing checkpoint: ${name_chkp_impl1}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl1}.dcp

# * write reports
print_yellow "writing reports: post implementation opt_design"
# timing reports
print_blue "writing report_timing_summary"
report_timing_summary -check_timing_verbose -delay_type min_max -max_paths 10 -report_unconstrained -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_impl1}_timing_summary.rpt
print_blue "writing report_timing"
report_timing -delay_type min_max -sort_by group -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_impl1}_timing.rpt
print_blue "writing check_timing"
check_timing -verbose -file ${dir_rpt}/${name_rpt_impl1}_check_timing.rpt
print_blue "writing report_config_timing"
report_config_timing -all -file ${dir_rpt}/${name_rpt_impl1}_config_timing.rpt
print_blue "writing create_slack_histogram"
create_slack_histogram -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl1}_create_slack_histogram.rpt
print_blue "writing report_clock_interaction"
report_clock_interaction -delay_type min_max -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl1}_clock_interaction.rpt
print_blue "writing report_cdc"
report_cdc -file ${dir_rpt}/${name_rpt_impl1}_cdc.rpt
print_blue "writing report_exceptions"
report_exceptions -coverage -file ${dir_rpt}/${name_rpt_impl1}_exceptions.rpt
print_blue "writing report_clock_networks"
report_clock_networks -file ${dir_rpt}/${name_rpt_impl1}_clock_networks.rpt
print_blue "writing report_pulse_width"
report_pulse_width -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl1}_pulse_width.rpt
print_blue "writing report_clock_utilization"
report_clock_utilization -file ${dir_rpt}/${name_rpt_impl1}_clock_utilization.rpt
# methodology reports
print_blue "writing report_methodology"
report_methodology -file ${dir_rpt}/${name_rpt_impl1}_methodology.rpt
# utilization reports
print_blue "writing report_ip_status"
report_ip_status -file ${dir_rpt}/${name_rpt_impl1}_ip_status.rpt
print_blue "writing report_ram_utilization"
report_ram_utilization -file ${dir_rpt}/${name_rpt_impl1}_ram_utilization.rpt
print_blue "writing report_utilization"
report_utilization -file ${dir_rpt}/${name_rpt_impl1}_utilization.rpt
print_blue "writing report_utilization -hierarchical"
report_utilization -hierarchical -file ${dir_rpt}/${name_rpt_impl1}_utilization_hierarchical.rpt
# routing reports
print_blue "writing report_route_status"
report_route_status -show_all -file ${dir_rpt}/${name_rpt_impl1}_route_status.rpt



# get elapsed time
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
print_green "Implementation (opt_design) time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
