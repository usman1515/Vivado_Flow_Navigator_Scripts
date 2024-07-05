# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/opt_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * open previous checkpoint
print_green "reading checkpoint: ${name_chkp_synth}"
open_checkpoint ${dir_chkp}/${name_chkp_synth}.dcp

# * run opt_design
print_green "running implementation phase: opt_design"
# ----- default implementation
opt_design -directive Default

# * write checkpoint
print_green "writing checkpoint: ${name_chkp_impl1}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl1}.dcp

# * write reports
print_green "writing reports: post implementation opt_design"
# report_clocks -file ${dir_rpt}/${name_rpt_clk1}.rpt
# report_timing_summary -file ${dir_rpt}/${name_rpt_timing1}.rpt
report_utilization -file ${dir_rpt}/${name_rpt_util1}.rpt

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
print_red "Implementation (opt_design) time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
