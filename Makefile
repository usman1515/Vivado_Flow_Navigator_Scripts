# ======================================== VARS
prj_dir = $(realpath .)

# NOTE: chnage as needed
# random sim/synth/impl run name
config = run1


# synthesis and implementation dcp name
synth		= synthesis_$(config)
impl_1		= impl_s1_opt_design_$(config)
impl_2		= impl_s2_power_opt_design_$(config)
impl_3		= impl_s3_place_design_$(config)
impl_4		= impl_s4_phys_opt_design_$(config)
impl_5		= impl_s5_route_design_$(config)
bitstream	= bitstream_$(config)

# ======================================== PATHS

DIR_CHECKPOINT	= $(prj_dir)/bin/checkpoints/$(config)
DIR_REPORT 		= $(prj_dir)/bin/reports/$(config)
DIR_RESULTS_TB	= $(prj_dir)/bin/testbench

# testbench simulation
rtl			?= ./rtl/mux_2x1.vhd
tb			?= ./tb/tb_mux_2x1.sv

# first file path
# TB_MODULE	?= $(basename $(notdir $(word 1, $(rtl))))
# last file path
TB_MODULE	?= tb_$(basename $(notdir $(word $(words $(rtl)), $(rtl))))
WORKLIB		:= work # xil_defaultlib

# Vivado testbench simulation flags
FLAGS_XVHDL	:= --2008 -v 0 --work $(WORKLIB) --incr --relax
FLAGS_XVLOG := -sv -v 0 --work $(WORKLIB) --incr --relax
FLAGS_XELAB := --incr --debug typical --relax --mt 8 -L $(WORKLIB)
FLAGS_XSIM	:= -runall -ieeewarnings


# ======================================== TARGETS

# default target
default: help

# create vivado project
setup_prj:
	@ vivado -mode tcl -source scripts/setup_prj.tcl

# run synthesis and implementation
run_vivado:
	@ rm -rf .gen .srcs
	@ vivado -mode batch -nojournal -notrace -stack 2000 \
		-source ./scripts/main.tcl -tclargs \
		$(synth) \
		$(impl_1) $(impl_2) $(impl_3) $(impl_4) $(impl_5) $(bitstream)

# Combined target
tb_simulation:
	@ [[ -d ${DIR_RESULTS_TB} ]] || mkdir ${DIR_RESULTS_TB}
	@ rm -rf xsim.dir
	@ xvhdl $(FLAGS_XVHDL) $(rtl)
	@ xvlog $(FLAGS_XVLOG) $(tb)
	@ xelab $(TB_MODULE) -s ${TB_MODULE}_behav $(FLAGS_XELAB) \
	-log $(DIR_RESULTS_TB)/elaborate_${TB_MODULE}.log
	xsim ${TB_MODULE}_behav $(FLAGS_XSIM) \
	-log $(DIR_RESULTS_TB)/simulate_${TB_MODULE}.log -wdb $(DIR_RESULTS_TB)/waveform_db_${TB_MODULE}.wdb

# move generated checkpoints to folder: ./bin/checkpoints/<config>
move_checkpoints:
	@ echo "moving checkpoints to folder: $(DIR_CHECKPOINT)"
	@ [ -d $(DIR_CHECKPOINT) ] || mkdir -p $(DIR_CHECKPOINT)
	mv -v ./bin/checkpoints/*.dcp $(DIR_CHECKPOINT)/

# move generated reports to folder: ./bin/reports/<config>
move_reports:
	@echo "moving reports to folder: $(DIR_REPORT)"
	@[ -d $(DIR_REPORT) ] || mkdir -p $(DIR_REPORT)
	mv -v ./bin/reports/*.rpt $(DIR_REPORT)/


clean_checkpoints:
	@ rm -rf ./bin/checkpoints

clean_logs:
	@ rm -rf ./bin/logs

clean_reports:
	@ rm -rf ./bin/reports

clean_testbenches:
	@ rm -rf ./bin/testbench

# insert you project dir here
clean_projects:
	@ rm -rf <your_project_name>

clean_bin:
	rm -rf *.jou *.log *.str
	rm -rf xsim.dir *.vcd *.wdb *.zip *.xml *.pb
	rm -rf .gen .srcs
	rm -rf ./-p .Xil

clean_all:
	@ make clean_checkpoints clean_logs clean_reports clean_testbenches
	@ make clean_projects
	@ make clean_bin

help:
	@ echo " "
	@ echo ---------------------------- Targets in Makefile ---------------------------
	@ echo ----------------------------------------------------------------------------
	@ echo " setup_prj_nexysA7_100T:	setup the a vivado FPGA project using the Nexys A7 board"
	@ echo " run_vivado_nexys_a7_100t:	run the entire synthesis and implementation flow in batch mode for the Nexys A7 board."
	@ echo " "
	@ echo " move_checkpoints:	create a run config folder and move all checkpoints to it"
	@ echo " move_reports:		create a run config folder and move all reports to it"
	@ echo " "
	@ echo " clean_logs:		delete all logs"
	@ echo " clean_checkpoints:	delete all checkpoints"
	@ echo " clean_reports:		delete all reports"
	@ echo " clean_projects:	delete all vivado projects"
	@ echo " clean_all:		run all clean_* targets"
	@ echo ----------------------------------------------------------------------------


