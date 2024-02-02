source ./scripts/color_func.tcl


# * get start time
set start_time [clock seconds]

# * read VHDL RTL files
print_green "reading VHDL RTL files"
read_vhdl -vhdl2008 [glob ${vhdl_rtl_dir}/*.vhd]

# * read IP sources
print_green "reading IP sources"
read_ip -quiet ${vhdl_ip_srcs}/xlnx_clk_gen/xlnx_clk_gen.xci

# * set VHDL file type to VHDL 2008
print_green "setting VHDL file type to VHDL 2008"
set vhdl_files [glob ${vhdl_rtl_dir}/*.vhd]
# set the file type property for each VHDL file
foreach vhdl_file $vhdl_files {
    set_property file_type {VHDL 2008} [get_files $vhdl_file]
}

# * read constraint files
print_green "reading constraint file/s"
foreach xdc_file [glob -directory $dir_constraint -tails *.xdc] {
    read_xdc [file join $dir_constraint $xdc_file]
}

# * set top module RTL
print_green "setting top module RTL and updating compilation order"
set_property top ${top_module_rtl} [current_fileset]
# update compilation order of RTL files
update_compile_order -fileset sources_1

# * optional step: upgrade and synthesize .xci IPs
print_green "Optional Step: upgrading and synthesizing .xci IPs"
upgrade_ip [get_ips] -quiet
# synth_ip [get_ips] -force
synth_ip [get_ips]

# ? The checkpoint './vcu118_sort_net_gen_v2.gen/sources_1/ip/xlnx_clk_gen/xlnx_clk_gen.dcp' has been generated
# * write xci ip synthesis checkpoint
print_green "writing checkpoint: .xci IP synthesis "
# write_checkpoint -force ${dir_chkp}/${name_chkp_ip}.dcp

# * print IP status for .xci files
print_green "print IP status for .xci files"
report_ip_status

# * run rtl analysis - covered in synthesis.tcl
print_green "running RTL analysis (elaboration)"
# synth_design -rtl -rtl_skip_mlo -name ${name_run_rtl}
# synth_design -top ${top_module_rtl} -part ${fpga_part_name} -rtl

synth_design -rtl_skip_mlo -name ${name_run_rtl}
# synth_design -top ${top_module_rtl} -part ${fpga_part_name}

# * write rtl analysis checkpoint
# ! dont need a checkpoint for this stage
# ! remove -rtl flag above if chkp is necessary
print_green "writing checkpoint: RTL analysis "
write_checkpoint -force ${dir_chkp}/${name_chkp_rtl}.dcp

# * open elaborated design in GUI
# start_gui
# after 20000     # wait N/1000 sec
# stop_gui

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
print_red "RTL Analysis time taken: [format "%02d:%02d:%02d" $hours $minutes $seconds]"