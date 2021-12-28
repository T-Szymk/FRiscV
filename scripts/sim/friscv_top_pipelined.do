# do file for pipelined friscv implementation

add log -r sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/*

# FPGA wrapper signals
add wave -divider -height 25 FPGA_WRAPPER
add wave -position insertpoint -group FPGA_WRAPPER \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/clk \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/rst_n \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/clk_s \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/mem_write_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/read_addr_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/instr_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/alu_result_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/data_mem_s \
-binary sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/w_data_s

# Instruction memeory signals
add wave -position insertpoint -group I_MEM_SIGNALS \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/RAM_WIDTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/RAM_DEPTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/INIT_FILE \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/RAM_ADDR_WIDTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/ARCH_BYTES \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/ADDR_SHIFT_AMOUNT \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/clk \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/addr_a_byte_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/addr_b_byte_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/din_a_in \
-binary sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/we_a_in \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/dout_b_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/sram_mem \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/addr_a_word_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_imem/addr_b_word_s

# Data memory signals
add wave -position insertpoint -group D_MEM_SIGNALS  \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/RAM_WIDTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/RAM_DEPTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/INIT_FILE \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/RAM_ADDR_WIDTH \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/ARCH_BYTES \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/ADDR_SHIFT_AMOUNT \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/clk \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/addr_a_byte_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/addr_b_byte_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/din_a_in \
-binary sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/we_a_in \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/dout_b_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/sram_mem \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/addr_a_word_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_dmem/addr_b_word_s

# core top level signals
add wave -divider -height 25 CORE_TOP
add wave -position insertpoint -group TOP_LEVEL \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/clk \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/rst_n \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_mem_d_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/d_mem_rd_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_mem_addr_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/d_mem_addr_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/d_mem_wd_out \
-binary sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/d_mem_we_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/pc_sel_s \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/branch_val_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/pc_val_s

# add pipelined inter-stage signals
add wave -divider -height 25 "PIPELINED SIGNALS"
add wave -position insertpoint -group "PIPED SIGNALS" \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/pc_val_s

# add program counter stage signals
add wave -divider -height 25 PC_STAGE
add wave -position insertpoint -group PC_STAGE \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/clk \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/rst_n \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_sel_in \
-hex sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/branch_in \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_out \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_r \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_out_r \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_incr_s \
sim:/friscv_pipelined_tb/i_friscv_fpga_wrapper/i_friscv_top/i_pc_stage/pc_s

set StdArithNoWarnings 1 
run 0 ns 
set StdArithNoWarnings 0
run 50 ns 

wave zoom full
config wave -signalnamewidth 1