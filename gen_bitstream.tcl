# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/write_bitstream

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * open previous checkpoint
print_yellow "reading checkpoint: ${name_chkp_impl5}"
open_checkpoint ${dir_chkp}/${name_chkp_impl5}.dcp

# compress bitstream generation
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# * generate bitstream
print_yellow "generating bitstream"
write_bitstream -force -verbose ${prj_dir}/${name_bitstream}.bit

# * write reports
print_yellow "writing reports: generate bitstream"
print_blue "writing report_timing_summary"
report_timing_summary -check_timing_verbose -delay_type min_max -max_paths 10 -report_unconstrained -input_pins -routable_nets -file ${dir_rpt}/${name_rpt_bit}_timing_summary.rpt
print_blue "writing report_methodology"
report_methodology -file ${dir_rpt}/${name_rpt_bit}_methodology.rpt
print_blue "writing report_drc"
report_drc -ruledecks {default opt_checks placer_checks router_checks bitstream_checks incr_eco_checks eco_checks abs_checks} -file ${dir_rpt}/${name_rpt_bit}_drc.rpt
print_blue "writing report_power"
report_power -file ${dir_rpt}/${name_rpt_bit}_power.rpt



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
print_green "Generate Bitstream time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
