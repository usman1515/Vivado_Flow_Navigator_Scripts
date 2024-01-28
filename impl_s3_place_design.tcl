# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/place_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * -directive values
# set val_directive "Explore"
# set val_directive "EarlyBlockPlacement"
# set val_directive "WLDrivenBlockPlacement"
# set val_directive "ExtraNetDelay_high"
# set val_directive "ExtraNetDelay_low"
# set val_directive "AltSpreadLogic_high"
# set val_directive "AltSpreadLogic_medium"
# set val_directive "AltSpreadLogic_low"
set val_directive "ExtraPostPlacementOpt"
# set val_directive "ExtraTimingOpt"
# set val_directive "SSI_SpreadLogic_high"
# set val_directive "SSI_SpreadLogic_low"
# set val_directive "SSI_SpreadSLLs"
# set val_directive "SSI_BalanceSLLs"
# set val_directive "SSI_BalanceSLRs"
# set val_directive "SSI_HighUtilSLRs"
# set val_directive "RuntimeOptimized"
# set val_directive "Quick"
# set val_directive "RQS"
# set val_directive "Auto"
# set val_directive "Default"


# * set checkpoint paths
set chkp1_path ${dir_chkp}/${name_chkp_impl1}.dcp
set chkp2_path ${dir_chkp}/${name_chkp_impl2}.dcp
print_blue "chkp1_path: $chkp1_path"
print_blue "chkp2_path: $chkp2_path"

# Check if name_chkp_impl2 exists
if {[file exists $chkp2_path]} {
    print_green "checkpoint FOUND:   ${name_chkp_impl2}"
    print_green "reading checkpoint: ${name_chkp_impl2}"
    open_checkpoint $chkp2_path
} else {
    # Check if name_chkp_impl1 exists
    if {[file exists $chkp1_path]} {
        print_red   "checkpoint NOT FOUND:  ${name_chkp_impl2}"
        print_green "checkpoint FOUND:      ${name_chkp_impl1}"
        print_green "reading checkpoint:    ${name_chkp_impl1}"
        open_checkpoint $chkp1_path
    } else {
        print_red "ERROR: No checkpoint found"
    }
}

# * run place_design
print_green "running implementation phase: place_design"
place_design -directive ${val_directive}

# * write checkpoint
print_green "writing checkpoint: ${name_chkp_impl3}"
write_checkpoint -force ${dir_chkp}/${name_chkp_impl3}.dcp

# * write reports
print_green "writing reports: post implementation place_design"
report_clocks -file ${dir_rpt}/${name_rpt_clk3}.rpt
report_timing_summary -file ${dir_rpt}/${name_rpt_timing3}.rpt
report_utilization -file ${dir_rpt}/${name_rpt_util3}.rpt

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
print_red "Implementation (place_design) time taken: [format "%02d:%02d:%02d" $hours $minutes $seconds]"
