# tcl guide: https://docs.xilinx.com/r/2021.1-English/ug835-vivado-tcl-commands/synth_design

source ./scripts/color_func.tcl

# * get start time
set start_time [clock seconds]

# * run synthesis
print_green "running synthesis"
synth_design \
    -name ${name_run_synth} \
    -top ${top_module_rtl} \
    -flatten_hierarchy rebuilt \
    -gated_clock_conversion off \
    -bufg 12 \
    -fsm_extraction auto \
    -resource_sharing auto \
    -control_set_opt_threshold auto \
    -shreg_min_size 3 \
    -max_bram -1 \
    -max_uram -1 \
    -max_dsp -1 \
    -max_bram_cascade_height -1 \
    -max_uram_cascade_height -1 \
    -no_srlextract \
    -cascade_dsp auto \
    -incremental_mode aggressive \
    -mode out_of_context \
    -directive default
    # -directive AreaOptimized_high

# * write synthesis checkpoint
print_green "writing checkpoint: ${name_chkp_synth}"
write_checkpoint -force ${dir_chkp}/${name_chkp_synth}.dcp

# * write reports
print_green "writing reports: post synthesis"
# report_clocks -file ${dir_rpt}/${name_rpt_clk}.rpt
# report_timing_summary -file ${dir_rpt}/${name_rpt_timing}.rpt
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
print_red "Synthesis time taken: [format \"%02d:%02d:%02d:%02d\" $days $hours $minutes $seconds]"
