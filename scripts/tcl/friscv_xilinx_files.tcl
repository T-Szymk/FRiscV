
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