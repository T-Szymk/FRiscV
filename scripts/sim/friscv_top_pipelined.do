# do file for pipelined friscv implementation

add log -r sim:/friscv_top/*

# add top level signals
add wave -divider -height 25 TOP_LEVEL
add wave -position insertpoint -group TOP_LEVEL \
sim:/friscv_top/clk \
sim:/friscv_top/rst_n \
sim:/friscv_top/i_mem_d_in \
sim:/friscv_top/d_mem_rd_in \
sim:/friscv_top/i_mem_addr_out \
sim:/friscv_top/d_mem_addr_out \
sim:/friscv_top/d_mem_wd_out \
sim:/friscv_top/d_mem_we_out \
sim:/friscv_top/pc_sel_s \
sim:/friscv_top/branch_val_s \
sim:/friscv_top/pc_val_s

# add pipelined inter-stage signals
add wave -divider -height 25 "PIPELINED SIGNALS"
add wave -position insertpoint -group "PIPED SIGNALS" \
sim:/friscv_top/pc_val_s

# add program counter stage signals
add wave -divider -height 25 PC_STAGE
add wave -position insertpoint -group PC_STAGE \
sim:/friscv_top/i_pc_stage/clk \
sim:/friscv_top/i_pc_stage/rst_n \
sim:/friscv_top/i_pc_stage/pc_sel_in \
sim:/friscv_top/i_pc_stage/branch_in \
sim:/friscv_top/i_pc_stage/pc_out \
sim:/friscv_top/i_pc_stage/pc_r \
sim:/friscv_top/i_pc_stage/pc_out_r \
sim:/friscv_top/i_pc_stage/pc_incr_s \
sim:/friscv_top/i_pc_stage/pc_s

force -freeze sim:/friscv_top/clk 1 0, 0 {5 ns} -r {10 ns}
force -freeze sim:/friscv_top/rst_n 0 0

set StdArithNoWarnings 1 
run 0 ns 
set StdArithNoWarnings 0

wave zoom full
config wave -signalnamewidth 1