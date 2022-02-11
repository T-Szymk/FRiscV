# FRiscV

## Overview
RV32I Implementation to be run on FPGA.

### Strategy
- Completed initial implemention of RV32I single cycle CPU (not fully verified).
- Now working on implementing 5-stage pipelined process with data/control hazard avoidance, basic branch prediction and exceptions.

## Repo Structure
**FRiscV**: *top*  
- **rtl**: *RTL Design files*  
- **tb**: *RTL testbenches*  
- **scripts**  
- scripts/**tcl**: *TCL files to drive FPGA synth*  
- scripts/**sim**: *.do files used for simulation of RTL*  
- **doc**: *Images/helpful documentation*  
- **fpga**: *Artefacts used in FPGA flow*  
