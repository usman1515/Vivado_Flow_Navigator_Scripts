# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/synth_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * -flatten_hierarchy values
set val_flatten_hierarchy "rebuilt"
# set val_flatten_hierarchy "full"
# set val_flatten_hierarchy "none"

# * -directive values
# set val_directive "default"
# set val_directive "RuntimeOptimized"
set val_directive "AreaOptimized_high"
# set val_directive "AreaOptimized_medium"
# set val_directive "AlternateRoutability"
# set val_directive "AreaMapLargeShiftRegToBRAM"
# set val_directive "AreaMultThresholdDSP"
# set val_directive "FewerCarryChains"
# set val_directive "PerformanceOptimized"
# set val_directive "LogicCompaction"

# * -fsm_extraction values
set val_fsm_extraction "auto"
# set val_fsm_extraction "gray"
# set val_fsm_extraction "sequential"
# set val_fsm_extraction "one_hot"
# set val_fsm_extraction "johnson"
# set val_fsm_extraction "off"

# * -resource_sharing values
set val_resource_sharing "auto"
# set val_resource_sharing "on"
# set val_resource_sharing "off"

# * -cascade_dsp values
set val_cascade_dsp "auto"
# set val_cascade_dsp "tree"
# set val_cascade_dsp "force"

# * run synthesis
print_green "running synthesis"
synth_design \
    -name ${name_run_synth} \
    -top ${top_module_rtl} \
    -directive ${val_directive} \
    -flatten_hierarchy ${val_flatten_hierarchy} \
    -fsm_extraction ${val_fsm_extraction} \
    -resource_sharing ${val_resource_sharing} \
    -cascade_dsp ${val_cascade_dsp} \
    -no_srlextract \
    -retiming

# * write synthesis checkpoint
print_green "writing checkpoint: ${name_chkp_synth}"
write_checkpoint -force ${dir_chkp}/${name_chkp_synth}.dcp

# * write reports
print_green "writing reports: post synthesis"
report_clocks -file ${dir_rpt}/${name_rpt_clk}.rpt
report_timing_summary -file ${dir_rpt}/${name_rpt_timing}.rpt
report_utilization -file ${dir_rpt}/${name_rpt_util}.rpt

# * open synth design gui
# open_run synth_1 -name synth_1

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
print_red "Synthesis time taken: [format "%02d:%02d:%02d" $hours $minutes $seconds]"