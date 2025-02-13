# Scripts

## Introduction

This folder contains a collection of Vivado tcl scripts, to streamline and automate the various phases of the project flow.

## Tcl (Interactive) Mode

- The following scripts can only be run in Vivado GUI Tcl Console inside design checkpoint.

| Script                | Description                                  |
| :-------------------- | :------------------------------------------- |
| color_all_pblocks.tcl | randomly colorize all pblocks in device view |

## Batch (Non-Interactive) Mode

- Run all the batch mode scripts from `main.tcl` by commenting out the phases you dont want to run.

| Script                       | Description                                            |
| :--------------------------- | :----------------------------------------------------- |
| main.tcl                     | main script. run all batch mode scripts from this one. |
| color_func.tcl               | print string statements in a particular color.         |
| vars.tcl                     | print all the global variables being used.             |
| rtl_analysis.tcl             | run RTL analysis phase.                                |
| synthesis.tcl                | run Synthesis phase.                                   |
| impl_s1_opt_design.tcl       | run implementation phase 1 `opt_design`.               |
| impl_s2_power_opt_design.tcl | run implementation phase 2 `power_opt_design`.         |
| impl_s3_place_design.tcl     | run implementation phase 3 `place_design`.             |
| impl_s4_phys_opt_design.tcl  | run implementation phase 4 `phys_opt_design`.          |
| impl_s5_route_design.tcl     | run implementation phase 5 `route_design`.             |
| gen_bitstream.tcl            | run program and debug phase.                           |

