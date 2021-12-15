##############################################
# Project settings

# Create a project
open_project matrixmul_prj

# The source file and test bench
add_files			matrixmul.cpp
add_files -tb	    matrixmul_test.cpp
# Specify the top-level function for synthesis
set_top				matrixmul

###########################
# Solution settings

# Create solution1
open_solution baseline

# Specify a Xilinx device and clock period
# - Do not specify a clock uncertainty (margin)
# - Let the  margin to default to 12.5% of clock period
set_part  {xc7k160tfbg484-1}
create_clock -period "300MHz"
#set_clock_uncertainty 1.25

# Simulate the C code 
# csim_design

# csynth_design
# cosim_design -rtl verilog

# exit

