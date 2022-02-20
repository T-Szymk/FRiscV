# Single cycle design files

set FRISCV_SC_RTL_FILES " \
  ../rtl/single_cycle/alu.sv \
  ../rtl/single_cycle/friscv_fpga_wrapper.sv \
  ../rtl/single_cycle/friscv_pkg.sv \
  ../rtl/single_cycle/friscv_top.sv \
  ../rtl/single_cycle/instr_decode.sv \
  ../rtl/single_cycle/main_controller.sv \
  ../rtl/single_cycle/mux_2_way.sv \
  ../rtl/single_cycle/mux_4_way.sv \
  ../rtl/single_cycle/pc.sv \
  ../rtl/single_cycle/reg_file.sv \
  ../rtl/single_cycle/sram_4k.sv \
  ../rtl/single_cycle/write_data_ext.sv \
"

set FRISCV_SC_TB_FILES  " \
  ../tb/alu_tb.sv \
  ../tb/reg_file_tb.sv \
  ../tb/sram_4k_tb.sv \
"

set FRISCV_SC_CONSTRAINTS "\
  ../fpga/FRiscV_constraints_ArtyA7.xdc \
"

# Pipelined design files
# system verilog files
set FRISCV_PIPE_SV_RTL_FILES " \
  ../rtl/common/friscv_sv_pkg.sv \
  ../rtl/pipelined/sram_4k.sv \
  ../rtl/pipelined/friscv_fpga_wrapper.sv \
"
# VHDL files
set FRISCV_PIPE_VHDL_RTL_FILES " \
  ../rtl/pipelined/friscv_pkg.vhd \
  ../rtl/pipelined/mux_2_way.vhd \
  ../rtl/pipelined/pc_stage.vhd \
  ../rtl/pipelined/friscv_top.vhd \
"

set FRISCV_PIPE_TB_FILES  " \
  ../tb/friscv_pipelined_tb.sv \
"