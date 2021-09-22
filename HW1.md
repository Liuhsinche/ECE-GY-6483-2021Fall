# Prepare
Use [HDLBits](https://hdlbits.01xz.net/wiki/Step_one) to learn basic language grammar and exercise your Verilog programming skills before do this homework.
# Introduction
FIFO uses a dual port memory and there will be two pointers to point read and write addresses. Here is a generalized block diagram of FIFO. \
![image](pic/HW1/1.png)\
Generally fifos are implemented using rotating pointers. We can call write and read pointers of a FIFO as head and tail of data area. Initially read and write pointers of the FIFO will point to the same location. Here is an example to explain how FIFO uses the memory. This is a fifo of length 8, WP and RP are the locations where write pointer and read pointer points. Shaded area in the diagram is filled with data.

![image](pic/HW1/2.png)\
When ever FIFO counter becomes zero or BUF_LENGTH, empty or full flags will be set. fifo_counter is incremented if write takes place and buffer is not full and will be decremented id read takesplace and buffer is not empty. If both read and write takes place, counter will remain the same. rd_ptr and wr_ptr are read and write pointers. Since we selected the bits in these registers same as address width of buffer, when buffer overflows, values will overflow and become 0.
# Question
Please first answer the following question before you get down to writing the code.
There is a 8-bit FIFO whose input clock is 100MHz while output clock is 95MHz, suppose that each time the FIFO will receive a package with 4K bits and the interval for each package is long enough, please give the minimum FIFO depth.

# Declaration of the top-level
In this homework, you do not have to test the code on board. You also don't need to write a testbench because it's given. Just write the fifo module and generate the right waveform with the given testbench. Please use the entity declaration as below：
```Verilog
module fifo(
	input clk,rst_n,
	input wr_en,rd_en,            //write enable signal and read enable signal
	input [7:0] buf_in,           // data input to be pushed to buffer
	output reg [7:0] buf_out,     // port to output the data using pop
	output empty, full,           // buffer empty and full indication 
	output reg [3:0] fifo_cnt  // number of data pushed in to buffer  
);
```
![image](pic/HW1/3.png)
As shown above, at 30ns, buf_in is 1, the fifo get the data and the fifo_cnt becomes 1. At 50ns, the read signal is enabled then you can get 1 at the output port. At 190ns, there are totally 9 data wrote into the fifo and 1 data read from the fifo, so there are 8 data in the fifo and the full signal becomes 1. When the fifo is full, you cannot push any extra data to it. At 200ns, the write signal is set to 0 and the read signal is set to 1, 1 data is read from the fifo and then the full signal comes back to 0. Since the testbench is given to you, you should try to generate the same waveform as the above one. The testbench is given in [<src/fifo_tb.v>](<src/fifo_tb.v>)

# Submit and Deadline
+ You should submit:
	1. Code for the fifo
	2. The secreenshot of the simulation
	3. The answer for the question

+ The answer and the secreenshot should be packaged into a pdf file. All of these files should be compressed in zip format and renamed as this: 
	
		ECE_GY_6483.HW1.[Name].[ID].zip
	

+ For example, the zip file name is: 
	
		ECE_GY_6483.HW1.XinzheLiu.N12209886.zip
	

+ File Organization Schema in Package:

		ECE_GY_6483.HW1.[Name].[ID].zip
		├─ fifo.v
		└─ fifo.pdf

+ Submit method
	1. Send an email to TA (xinzhe.liu@nyu.edu) with the compressed package as an attachment.
	2. The title of email **MUST** start with "[ECE-GY 6483]". For example: "[ECE-GY 6483] Submission of the first homework."
	
+ Deadline
	1. Deadline at 6 pm on September 22, 2021.
	2. Late submission within 48 hours will only get 80% of the score for this homework. For example, if your score for this homework is 80, then only 64 will be entered into the total score.
	3. All points will be lost if you are late for more than 48 hours.
	4. Because of the inconsistent Verilog skill level of the students, the deadline can be graced to September 26. Students who wish to get the extension should send an email to TA’s mailbox before 6:00 pm on September 23. To prove your efforts to improve Verilog skills, a screenshot should be included in the email. The screenshot contains the information that you have completed the first two topics of [HDLBits](https://hdlbits.01xz.net/wiki/Step_one). 