#!/bin/tclsh

# vars
set rtl_top_file    "./rtl/rtl_top.sv"
set tb_top_file     "./tb/tb_top.sv"
set tb_top_module   "tb_top"
set worklib         "work"
# set worklib         "xil_defaultlib"


# read all VHDL source file/s
exec xvhdl --2008 -v 0 --work $worklib --incr --relax ./rtl/<file_A>.vhd
# read all Verilog source file/s
exec xvlog -v 0 --work $worklib --incr --relax ./rtl/<file_B>.v
# read all System verilog source file/s
exec xvlog -sv -v 0 --work $worklib --incr --relax $rtl_top_file

# read all SV testbench file/s
exec xvlog -sv -v 0 --work $worklib --incr --relax $tb_top_file

# elaborate the design
exec xelab $tb_top_module -s ${tb_top_module}_behav --incr --debug typical --relax --mt 8 -L $worklib \
    -log ./bin/testbench/elaborate_${tb_top_module}.log

# run the simulation
exec xsim ${tb_top_module}_behav -runall -ieeewarnings \
    -log ./bin/testbench/simulate_${tb_top_module}.log \
    -wdb ./bin/testbench/waveform_db_${tb_top_module}.wdb

