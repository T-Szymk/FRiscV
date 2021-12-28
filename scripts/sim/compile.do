
vcom -2008 -check_synthesis -pedanticerrors -f ./scripts/sim/parallel_files_vhd.list

vlog -sv +define+SIM=1 -f ./scripts/sim/parallel_files_sv.list

vsim -voptargs="+acc" friscv_pipelined_tb -do ./scripts/sim/friscv_top_pipelined.do