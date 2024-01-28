# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/route_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * -directive values
# set val_directive "Explore"
set val_directive "AggressiveExplore"
# set val_directive "NoTimingRelaxation"
# set val_directive "MoreGlobalIterations"
# set val_directive "HigherDelayCost"
# set val_directive "AdvancedSkewModeling"
# set val_directive "AlternateCLBRouting"
# set val_directive "RuntimeOptimized"
# set val_directive "Quick"
# set val_directive "Default"

# * set checkpoint paths
set chkp3_path ${dir_chkp}/${name_chkp_impl3}.dcp
set chkp4_path ${dir_chkp}/${name_chkp_impl4}.dcp
print_blue "chkp3_path: $chkp3_path"
print_blue "chkp4_path: $chkp4_path"

# Check if name_chkp_impl4 exists
if {[file exists $chkp4_path]} {
    print_green "checkpoint FOUND:   ${name_chkp_impl4}"
    print_green "reading checkpoint: ${name_chkp_impl4}"
    open_checkpoint $chkp4_path
} else {
    # Check if name_chkp_impl3 exists
    if {[file exists $chkp3_path]} {
        print_red   "checkpoint NOT FOUND:  ${name_chkp_impl4}"
        print_green "checkpoint FOUND:      ${name_chkp_impl3}"
        print_green "reading checkpoint:    ${name_chkp_impl3}"
        open_checkpoint $chkp3_path
    } else {
        print_red "ERROR: No checkpoint found"
    }
}

# * run route_design
print_green "running implementation phase: route_design"
route_design \
    -directive ${val_directive} \
    -tns_cleanup

# route_design -directive AggressiveExplore -tns_cleanup
# * write checkpoint
print_green "writing checkpoint: ${name_chkp_impl5}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl5}.dcp

# * write reports
print_green "writing reports: post implementation route_design"
report_clocks -file ${dir_rpt}/${name_rpt_clk5}.rpt
report_timing_summary -file ${dir_rpt}/${name_rpt_timing5}.rpt
report_utilization -file ${dir_rpt}/${name_rpt_util5}.rpt

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
print_red "Implementation (route_design) time taken: [format "%02d:%02d:%02d" $hours $minutes $seconds]"
