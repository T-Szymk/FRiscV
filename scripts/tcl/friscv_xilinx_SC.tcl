

#
# STEP#1: define the output directory area.
#
if [info exists env(PROJECT_NAME)] {
  set PROJECT_NAME $::env(PROJECT_NAME)
} else {
  set PROJECT_NAME "FRiscV_SC"
  puts "setting project name to ${PROJECT_NAME}"
}

if [info exists env(PART)] {
  set PART $::env(PART)
} else {
  set PART "xc7a100tcsg324-1"
  puts "setting part to ${PROJECT_NAME}"
}

set TOP ../rtl/friscv_fpga_wrapper.sv

source ../scripts/tcl/friscv_xilinx_files.tcl

create_project ${PROJECT_NAME} ./${PROJECT_NAME} -part ${PART} -force
#
# STEP#2: setup design sources and constraints
#
add_files -force ${FRISCV_SC_RTL_FILES}
add_files -force -fileset sim_1 ${FRISCV_SC_TB_FILES}
# add memory initialisation files
add_files -force [glob ../fpga/*.mem] 
# add constraints
add_files -fileset constrs_1 ${FRISCV_SC_CONSTRAINTS}

# Update compile order for the fileset 'sources_1'
set_property top ${TOP} [current_fileset]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# add ips
add_files ../fpga/ip/clk_wiz_0/clk_wiz_0.xci

generate_target all [get_files  ../fpga/ip/clk_wiz_0/clk_wiz_0.xci]

#
# STEP#3: run synthesis and the default utilization report.
#

launch_runs synth_1
wait_on_run synth_1
#
# STEP#4: run logic optimization, placement, physical logic optimization, route and
# bitstream generation. Generates design checkpoints, utilization and timing
# reports, plus custom reports.

launch_runs impl_1 -to_step write_bitstream
#wait_on_run impl_1
puts "Implementation done!"