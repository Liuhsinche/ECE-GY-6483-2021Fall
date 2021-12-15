cmake_minimum_required(VERSION 3.10.2)
project(test_PW)

set(CMAKE_CXX_STANDARD 14)

include_directories(/tools/Xilinx/Vivado/2019.1/include)
add_executable(matrixmul matrixmul.cpp matrixmul_test.cpp)