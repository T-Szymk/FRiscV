
set FRISCV_SC_RTL_FILES " \
../rtl/alu.sv \
../rtl/friscv_fpga_wrapper.sv \
../rtl/friscv_pkg.sv \
../rtl/friscv_top.sv \
../rtl/instr_decode.sv \
../rtl/main_controller.sv \
../rtl/mux_2_way.sv \
../rtl/mux_4_way.sv \
../rtl/pc.sv \
../rtl/reg_file.sv \
../rtl/sram_4k.sv \
../rtl/write_data_ext.sv \
"

set FRISCV_SC_TB_FILES  " \
 ../tb/alu_tb.sv \
 ../tb/reg_file_tb.sv \
 ../tb/sram_4k_tb.sv \
"

set FRISCV_SC_CONSTRAINTS "\
../fpga/FRiscV_constraints_ArtyA7.xdc \
"