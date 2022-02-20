.EXPORT_ALL_VARIABLES:

PROJECT_NAME ?= FRiscV_SC
PART ?= xc7a100tcsg324-1

PIPELINE_VHDL_FILES = ./scripts/sim/parallel_files_vhd.list
PIPELINE_SV_FILES   = ./scripts/sim/parallel_files_sv.list

.PHONY: single_cycle
single_cycle:
	mkdir -p ./build && cd build && \
	vivado -mode batch -nojournal -source "../scripts/tcl/friscv_xilinx_SC.tcl" \
	-log $(PROJECT_NAME)_vivado.log

.PHONY: build_sim_pipeline
build_sim_pipeline:
	vcom -2008 -check_synthesis -pedanticerrors -f $(PIPELINE_VHDL_FILES)
	vlog -sv +define+SIM=1 -f $(PIPELINE_SV_FILES)

.PHONY: sim_pipeline
sim_pipeline: build_sim_pipeline
	vsim -voptargs="+acc" friscv_pipelined_tb

.PHONY: pipeline
pipeline:
	mkdir -p ./build && cd build && \
	vivado -mode batch -nojournal -source "../scripts/tcl/friscv_xilinx_SC.tcl" \
	-log $(PROJECT_NAME)_vivado.log

.PHONY: clean
clean:
	rm -rf ./build/$(PROJECT_NAME)*