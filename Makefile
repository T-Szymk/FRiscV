.EXPORT_ALL_VARIABLES:

PROJECT_NAME ?= FRiscV_SC
PART ?= xc7a100tcsg324-1

.PHONY: all
all:
	mkdir -p ./build && cd build && \
	vivado -mode batch -nojournal -source "../scripts/tcl/friscv_xilinx.tcl" \
	-log $(PROJECT_NAME)_vivado.log

.PHONY: clean
clean:
	rm -rf ./build/$(PROJECT_NAME)*