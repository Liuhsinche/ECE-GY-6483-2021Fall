open_project HLS

set_top SkyNet

add_files ./src/SkyNet.cpp
add_files -tb ./src/transform.cpp
add_files -tb ./src/utils.cpp
add_files -tb ./src/main.cpp
add_files -tb ./blob
add_files -tb ./weight

open_solution "Baseline"

set_part {xczu7ev-ffvc1156-2-e} -tool vivado
create_clock -period 3.33 -name default

config_sdx -target sds
config_interface -m_axi_addr64
config_rtl -reset_level low
config_rtl -prefix a0_

csim_design -O
# csynth_design
# export_design -format ip_catalog