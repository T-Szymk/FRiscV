# FRiscV

## Overview
RV32I Implementation to be run on FPGA.

### Strategy
Start by implementing data/control for add/sub, and/or/xor, slt, lw/sw, beq. Once this is complete, look at expanding to cover remaining instructions.

## Repo Structure
-**FRiscV**-
       |-**rtl**: RTL Design files  
       |-**tb**: RTL testbenches  
       |-**scripts**  
         |-**tcl**: TCL files to drive FPGA synth  
         |-**sim**: .do files used for simulation of RTL  
       |-**doc**: Images/helpful documentation  
       |-**fpga**: Artefacts used in FPGA flow  
