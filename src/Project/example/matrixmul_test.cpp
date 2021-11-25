/*******************************************************************************
Vendor: Liuxzh 
Associated Filename: matrixmul_test.cpp
Purpose: Vivado HLS example 
Device: All 
Revision History: Aug 17, 2020 - initial release                                             
*******************************************************************************/
#include <ctime>
#include <fstream>
#include <iostream>
#include <random>

#include "matrixmul.h"

using namespace std;

int main(int argc, char **argv)
{
   std::random_device rd;
   std::default_random_engine rng(2);
   std::uniform_int_distribution<int> dist(mat_a_min, mat_a_max);

   mat_a_t in_mat_a[MAT_A_ROWS][MAT_A_COLS];
   mat_b_t in_mat_b[MAT_B_ROWS][MAT_B_COLS];
   result_t hw_result[MAT_A_ROWS][MAT_B_COLS];
   result_t sw_result[MAT_A_ROWS][MAT_B_COLS];
   int err_cnt = 0;

   for (int i = 0; i < MAT_A_ROWS; i++)
   {
      for (int j = 0; j < MAT_A_COLS; j++)
      {
         in_mat_a[i][j] = dist(rng);
      }
   }

   for (int i = 0; i < MAT_B_ROWS; i++)
   {
      for (int j = 0; j < MAT_B_COLS; j++)
      {
         in_mat_b[i][j] = dist(rng);
      }
   }

   // Generate the expected result
   // Iterate over the rows of the A matrix
   for (int i = 0; i < MAT_A_ROWS; i++)
   {
      for (int j = 0; j < MAT_B_COLS; j++)
      {
         // Iterate over the columns of the B matrix
         sw_result[i][j] = 0;
         // Do the inner product of a row of A and col of B
         for (int k = 0; k < MAT_B_ROWS; k++)
         {
            sw_result[i][j] += in_mat_a[i][k] * in_mat_b[k][j];
         }
      }
   }

   // Run the matrix multiply block
   for (int i = 0; i < 5; i++)
   {
      matrixmul(in_mat_a, in_mat_b, hw_result);
   }

   // Check result matrix
   for (int i = 0; i < MAT_A_ROWS; i++)
   {
      for (int j = 0; j < MAT_B_COLS; j++)
      {
         // Check HW result against SW
         if (hw_result[i][j] != sw_result[i][j])
         {
            err_cnt++;
            std::cout << "(" << i << ", " << j << ")" << sw_result[i][j] << ", " << hw_result[i][j] << std::endl;
         }
      }
   }

   if (err_cnt)
      cout << "ERROR: " << err_cnt << " mismatches detected!" << endl;
   else
      cout << "Test passes." << endl;

   return err_cnt;
}
