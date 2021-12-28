.EXPORT_ALL_VARIABLES:

PROJECT_NAME ?= FRiscV_SC
PART ?= xc7a100tcsg324-1

PIPELINE_RTL = $(PWD)/rtl/pipelined
PIPELINE_VHDL = $(PIPELINE_RTL)/friscv_pkg.vhd \
                $(PIPELINE_RTL)/mux_2_way.vhd \
                $(PIPELINE_RTL)/pc_stage.vhd \
                $(PIPELINE_RTL)/friscv_top.vhd
PIPELINE_SV   = $(PIPELINE_RTL)/friscv_sv_pkg.sv \
                $(PIPELINE_RTL)/sram_4k.sv \
                $(PIPELINE_RTL)/friscv_fpga_wrapper.sv

.PHONY: single_cycle
single_cycle:
	mkdir -p ./build && cd build && \
	vivado -mode batch -nojournal -source "../scripts/tcl/friscv_xilinx_SC.tcl" \
	-log $(PROJECT_NAME)_vivado.log

.PHONY: sim_pipeline
sim_pipeline:
	vcom -2008 -check_synthesis -pedanticerrors $(PIPELINE_VHDL)
	vlog -sv $(PIPELINE_SV) +define+SIM=1
	vsim -voptargs="+acc" friscv_fpga_wrapper -do ./scripts/sim/friscv_top_pipelined.do

.PHONY: pipeline
pipeline:
	mkdir -p ./build && cd build && \
	vivado -mode batch -nojournal -source "../scripts/tcl/friscv_xilinx_SC.tcl" \
	-log $(PROJECT_NAME)_vivado.log

.PHONY: clean
clean:
	rm -rf ./build/$(PROJECT_NAME)*