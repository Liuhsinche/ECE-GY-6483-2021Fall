open_project HLS

set_top SkyNet

add_files ./src/SkyNet.cpp -cflags "-std=c++11"
add_files -tb ./src/transform.cpp -cflags "-std=c++11"
add_files -tb ./src/utils.cpp -cflags "-std=c++11"
add_files -tb ./src/main.cpp -cflags "-std=c++11"
add_files -tb ./blob
add_files -tb ./weight

open_solution "Baseline"

set_part {xczu7ev-ffvc1156-2-e} -tool vivado
create_clock -period 10 -name default

config_sdx -target sds
config_interface -m_axi_addr64
config_rtl -reset_level low
config_rtl -prefix a0_

csim_design -O
csynth_design
# export_design -format ip_catalog