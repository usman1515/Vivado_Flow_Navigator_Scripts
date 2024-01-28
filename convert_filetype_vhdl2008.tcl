#!/usr/bin/tclsh

# get pwd
set prj_dir [pwd]

# get last folder name
set prj_name [file tail $prj_dir]
# puts "Project folder name: $prj_name"

# RTL path
set path_vhdl_rtl "./$prj_name.srcs/sources_1/new"

# get list of all VHDL files in the dir
set vhdl_files [glob -directory $path_vhdl_rtl -tails *.vhd]

# loop through each VHDL RTL files and set the file type property
foreach vhdl_file $vhdl_files {
    set file_path [file join $path_vhdl_rtl $vhdl_file]
    set_property file_type {VHDL 2008} [get_files $file_path]
}

# update RTL compilation order
update_compile_order -fileset sources_1
