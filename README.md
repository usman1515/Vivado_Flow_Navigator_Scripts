# Vivado Project Template

## Introduction

This repository contains a Makefile and a collection of scripts designed to streamline and automate
the workflow for Vivado projects. It provides templates and utility scripts for both batch mode and
normal mode operations, making it easier to configure, manage, and run Vivado projects for FPGA
design and development.

The scripts help with tasks such as:
- Automating project creation and configuration.
- Managing project flows in Vivado, including synthesis, implementation, and bitstream generation.

## Project directory outline

This is how you should setup your Vivado project inorder for the scripts and Makefile to work.

```bash
prj_root_dir/
├── bin/                # dump folder (created automatically)
│   ├── checkpoints/    # design checkpoints stored here
│   ├── logs/           # logs stored here
│   ├── reports/        # reports stored here
│   └── testbench/      # testbench outputs stored here
├── scripts/            # dir tcl scripts
├── constraints/        # vivado constraint files
├── ip/                 # vivado IP blocks .xci files
├── rtl/                # Verilog/VHDL modules
├── tb/                 # testbenches
└── Makefile
```

## Setting up your project
- Look at all the lines where the todo comment `# ----- INFO:` is mentioned in the tcl scripts `setup_project.tcl` and update the following.
  1. set project name and directory
  2. set required FPGA part and board
  3. set RTL and TB language
  4. set name for RTL top module
  5. **OPTIONAL** specify XCI files if youre using any Xilinx IP blocks or UniMacros
  6. add VHDL rtl source files to the project
  7. add Verilog TB source files to the project
  8. add top level IO constraints

- Look at all the lines where the todo comment `# ----- INFO:` is mentioned in the tcl scripts `synthesis.tcl` and update the following.
  1. **OPTIONAL** add all the Xilinx IP blocks if youre using any. Each block must its own read, import, create, upgrade, synthesis.
  2. set top level IO constraint file

## Creating Vivado project
- Run target: `make setup_prj`

- A vivado project by the name of `prj_name` will be created.

## Running Vivado project

- The flow of synthesis and implemented can be controlled using the `main.tcl` script. Simply comment out the phase which you dont want to run.

- **NOTE** that implementation requires a synthesis DCP.
  - Implementation stages 1,3,5 need to be run at all costs.
  - Implementation stages 2,4 are optional.

### Testbench Simulation
- To simulate a testbench using the Makefile run the following:
```bash
make tb_simulation rtl=<rel_file_path> tb=<rel_file_path>
```
- RTL file and module must have the same name.
- Testbench file and module must have naming convention `tb_<rtl_module_name>`.

- The tcl script `tb_sim.tcl` is available which can cross compile RTL and TB module having VHDL, Verilog or Systemverilog code.


### Synthesis
- Run target `make run_vivado` to invoke `main.tcl` and make sure the following code is uncommented.
  ```
  source scripts/vars.tcl
  source scripts/synthesis.tcl
  ```

### Implementation
- Run target `make run_vivado` to invoke `main.tcl` and make sure the following code is uncommented.
  ```
  source scripts/impl_s1_opt_design.tcl
  source scripts/impl_s2_power_opt_design.tcl
  source scripts/impl_s3_place_design.tcl
  source scripts/impl_s4_phys_opt_design.tcl
  source scripts/impl_s5_route_design.tcl
  ```

### Bitstream generation
- Run target `make run_vivado` to invoke `main.tcl` and make sure the following code is uncommented. Route design DCP must be available.
  ```
  source scripts/gen_bitstream.tcl
  ```
