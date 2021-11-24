##############################################
# Project settings

# Create a project
open_project fir_prj

# The source file and test bench
add_files			fir.c
add_files -tb	    fir_test.c
# Specify the top-level function for synthesis
set_top				fir

###########################
# Solution settings

# Create solution1
open_solution base

# Specify a Xilinx device and clock period
# - Do not specify a clock uncertainty (margin)
# - Let the  margin to default to 12.5% of clock period
set_part  {xc7k160tfbg484-1}
create_clock -period "300MHz"
#set_clock_uncertainty 1.25

# Simulate the C code 
# csim_design

csynth_design
cosim_design -rtl verilog

# Do not perform any other steps
# - The basic project will be opened in the GUI 
exit
