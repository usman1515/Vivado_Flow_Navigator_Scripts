# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/write_bitstream

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * open previous checkpoint
print_green "reading checkpoint: ${name_chkp_impl5}"
open_checkpoint ${dir_chkp}/${name_chkp_impl5}.dcp

# compress bitstream generation
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# * generate bitstream
print_green "generating bitstream"
write_bitstream -force ${prj_dir}/${name_bitstream}.bit

# * write reports
print_green "writing reports: generate bitstream"
report_clocks -file ${dir_rpt}/${name_rpt_clk6}.rpt
report_timing_summary -file ${dir_rpt}/${name_rpt_timing6}.rpt
report_utilization -file ${dir_rpt}/${name_rpt_util6}.rpt

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
print_red "Generate Bitstream time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
