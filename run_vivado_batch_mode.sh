#!/bin/bash

# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------
# -- Author: Usman Siddique
# --
# --
# -- To run the project in batch mode use this script:
# -- vivado -mode batch -source ./scripts/main.tcl -stack 2000 -notrace
# --      mode:     batch
# --      source:   relative path of the tcl script you want to run
# --      notace:   dont display verbose logs
# --      stack:    increase the memory allocated for the stack in synthesis. Default 1024.
# ----------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------
clear

config="your_run_name"


post_synth="synth_$config"
impl_1="impl_1_opt_$config"
impl_2="impl_2_power_opt_$config"
impl_3="impl_3_place_$config"
impl_4="impl_4_phys_opt_$config"
impl_5="impl_5_route_$config"
bitstream="bitstream_$config"

post_synth_utilization="synth_util_$config"
post_impl1_utilization="impl1_opt_util_$config"
post_impl2_utilization="impl2_power_opt_util_$config"
post_impl3_utilization="impl3_place_util_$config"
post_impl4_utilization="impl4_phys_opt_util_$config"
post_impl5_utilization="impl5_route_util_$config"
bitstream_utilization="bitstream_util_$config"


vivado -mode batch -source ./scripts/main.tcl -notrace -tclargs \
    $post_synth \
    $impl_1 \
    $impl_2 \
    $impl_3 \
    $impl_4 \
    $impl_5 \
    $bitstream \
    $post_synth_utilization \
    $post_impl1_utilization \
    $post_impl2_utilization \
    $post_impl3_utilization \
    $post_impl4_utilization \
    $post_impl5_utilization \
    $bitstream_utilization
