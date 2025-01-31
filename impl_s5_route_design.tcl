# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/route_design

source ./scripts/color_func.tcl

# get start time
set start_time [clock seconds]


# directive values
set val_directive "AggressiveExplore"
# set val_directive "NoTimingRelaxation"
# set val_directive "MoreGlobalIterations"
# set val_directive "HigherDelayCost"
# set val_directive "AdvancedSkewModeling"
# set val_directive "AlternateCLBRouting"
# set val_directive "RuntimeOptimized"
# set val_directive "Quick"
# set val_directive "Explore"
# set val_directive "Default"

# set checkpoint paths
set chkp3_path ${dir_chkp}/${name_chkp_impl3}.dcp
set chkp4_path ${dir_chkp}/${name_chkp_impl4}.dcp
print_blue "chkp3_path: $chkp3_path"
print_blue "chkp4_path: $chkp4_path"

# check if name_chkp_impl4 exists
if {[file exists $chkp4_path]} {
    print_green "checkpoint FOUND:   ${name_chkp_impl4}"
    print_yellow "reading checkpoint: ${name_chkp_impl4}"
    open_checkpoint $chkp4_path
} else {
    # check if name_chkp_impl3 exists
    if {[file exists $chkp3_path]} {
        print_red   "checkpoint NOT FOUND:  ${name_chkp_impl4}"
        print_green "checkpoint FOUND:      ${name_chkp_impl3}"
        print_yellow "reading checkpoint:    ${name_chkp_impl3}"
        open_checkpoint $chkp3_path
    } else {
        print_red "ERROR: No checkpoint found"
    }
}

# run route_design
print_yellow "running implementation phase: route_design"
# route_design -directive ${val_directive} -tns_cleanup
route_design -directive Default -tns_cleanup -timing_summary -verbose
# route_design -directive AggressiveExplore -tns_cleanup

# write checkpoint
print_yellow "writing checkpoint: ${name_chkp_impl5}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl5}.dcp

# write reports
print_yellow "writing reports: post implementation route_design"
# timing reports
print_blue "writing report_timing_summary"
report_timing_summary -check_timing_verbose -delay_type min_max -max_paths 10 -report_unconstrained -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_impl5}_timing_summary.rpt
print_blue "writing report_bus_skew"
report_bus_skew -sort_by_slack -delay_type min_max -max_paths 10 -input_pins -file ${dir_rpt}/${name_rpt_impl5}_bus_skew.rpt
print_blue "writing report_timing"
report_timing -delay_type min_max -sort_by group -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_impl5}_timing.rpt
print_blue "writing check_timing"
check_timing -verbose -file ${dir_rpt}/${name_rpt_impl5}_check_timing.rpt
print_blue "writing report_config_timing"
report_config_timing -all -file ${dir_rpt}/${name_rpt_impl5}_config_timing.rpt
print_blue "writing create_slack_histogram"
create_slack_histogram -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl5}_create_slack_histogram.rpt
print_blue "writing report_clock_interaction"
report_clock_interaction -delay_type min_max -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl5}_clock_interaction.rpt
print_blue "writing report_cdc"
report_cdc -file ${dir_rpt}/${name_rpt_impl5}_cdc.rpt
print_blue "writing report_exceptions"
report_exceptions -coverage -file ${dir_rpt}/${name_rpt_impl5}_exceptions.rpt
print_blue "writing report_clock_networks"
report_clock_networks -file ${dir_rpt}/${name_rpt_impl5}_clock_networks.rpt
print_blue "writing report_pulse_width"
report_pulse_width -significant_digits 3 -file ${dir_rpt}/${name_rpt_impl5}_pulse_width.rpt
print_blue "writing report_clock_utilization"
report_clock_utilization -file ${dir_rpt}/${name_rpt_impl5}_clock_utilization.rpt
# methodology reports
print_blue "writing report_methodology"
report_methodology -file ${dir_rpt}/${name_rpt_impl5}_methodology.rpt
# drc reports
print_blue "writing report_drc"
report_drc -ruledecks {default opt_checks placer_checks router_checks bitstream_checks incr_eco_checks eco_checks abs_checks} -file ${dir_rpt}/${name_rpt_impl5}_drc.rpt
# power reports
print_blue "writing report_power"
report_power -file ${dir_rpt}/${name_rpt_impl5}_power.rpt
# routing reports
print_blue "writing report_route_status"
report_route_status -show_all -file ${dir_rpt}/${name_rpt_impl5}_route_status.rpt
# utilization reports
print_blue "writing report_ip_status"
report_ip_status -file ${dir_rpt}/${name_rpt_impl5}_ip_status.rpt
print_blue "writing report_ram_utilization"
report_ram_utilization -file ${dir_rpt}/${name_rpt_impl5}_ram_utilization.rpt
print_blue "writing report_utilization"
report_utilization -file ${dir_rpt}/${name_rpt_impl5}_utilization.rpt
print_blue "writing report_utilization -hierarchical"
report_utilization -hierarchical -file ${dir_rpt}/${name_rpt_impl5}_utilization_hierarchical.rpt
# pblock utilization reports
get_pblocks -verbose
set pblock_list [get_pblocks]
# loop through each pblk and append it to report
foreach pblock $pblock_list {
    # Print the current pblock (or perform other operations)
    print_blue "writing report pblock: $pblock"
    report_utilization -pblocks [get_pblocks $pblock] -append -file ${dir_rpt}/${name_rpt_impl5}_utilization_pblocks.rpt
}



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
print_green "Implementation (route_design) time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
