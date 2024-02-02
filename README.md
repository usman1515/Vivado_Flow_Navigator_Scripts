# Vivado Flow Navigator Scripts

## Introduction
This repository contains a collection of Vivado scripts, designed to enhance and streamline and automate the various phases of the project flow. The scripts can be run in either `tcl` mode or `batch` mode.

## Usage
-   Clone the repo in your Vivado project folder and rename it as `scripts`.
    ```bash
    git clone git@github.com:usman1515/vivado_flow_navigator_scripts.git scripts
    ```
-   When running scripts in batch mode.
    -   All the reports will be saved in folder `<vivado_project>/reports`.
    -   All checkpoints will be saved in folder `<vivado_project>/checkpoints`.
    -   All logs will be saved in folder `<vivado_project>/logs`.

### Tcl (Interactive) Mode

In TCL mode, users interact with Vivado through the tcl scripting language within the Vivado console or command-line interface.
-   The following scripts can be run directly in Vivado Tcl Console.
```bash
# move to vivado project folder
cd <vivado_project>
# run from the vivado tcl console
source ./scripts/convert_filetype_vhdl2008.tcl
```

| Script                        | Description                         |
| :---------------------------- | :---------------------------------- |
| convert_filetype_vhdl2008.tcl | convert all VHDL files to VHDL 2008 |

<!-- ||| -->

### Batch (Non-Interactive) Mode

Batch mode involves executing a sequence of Vivado commands or a tcl script without user interaction, typically from the operating system's command line.
-   Run all the batch mode scripts from `main.tcl` by commenting out the phases you dont want to run.
-   The synthesis and implementation phases generate checkpoint
```bash
# move to vivado project folder
cd <vivado_project>
# run vivado in batch mode from the terminal
vivado -mode batch -source ./scripts/main.tcl -notrace
```

| Script                       | Description                                            |
| :--------------------------- | :----------------------------------------------------- |
| main.tcl                     | main script. run all batch mode scripts from this one. |
| color_func.tcl               | print string statements in a particular color.         |
| vars.tcl                     | print all the global variables being used.             |
| rtl_analysis.tcl             | run RTL analysis phase.                                |
| synthesis.tcl                | run Synthesis phase.                                   |
| impl_s1_opt_design.tcl       | run Implementation phase 1 `opt_design`.               |
| impl_s2_power_opt_design.tcl | run Implementation phase 2 `power_opt_design`.         |
| impl_s3_place_design.tcl     | run Implementation phase 3 `place_design`.             |
| impl_s4_phys_opt_design.tcl  | run Implementation phase 4 `phys_opt_design`.          |
| impl_s5_route_design.tcl     | run Implementation phase 5 `route_design`.             |
| gen_bitstream.tcl            | run Program and Debug phase.                           |

<!-- ||| -->