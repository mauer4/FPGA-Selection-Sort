# FPGA-Selection-Sort
Verilog code to implement the selection sort algorithm in Verilog, on a DE1-SOC FPGA

The verilog in this repo instantiates a 10K memory block in the DE1-SOC fpga, writes a 256 entry array into it, and then starts 
the selection sort algorithm.

The algorithms is implemented using a complex state maching with the following states

WAIT_sort - waiting to be called to start the algorithm
READ_SIZE - first entry in the array must me equal to the size of the array to be sorted
INC_i - increment the i index 
INC_j - increment the j index - traverses the array from i to search for the minimum value from i-index to end of array 
SWAP1 - one of the two cycles needed to swap the minimum value and the i-index
SWAP2 - the second cycle for swap, ready to look at the next entry (next i-index)

The Algorithm is written in verilog and instantiated inside a top_level module that instantiates the memory inside the DE1, as well

The algorithm and the top level module are both testbenched extensively.

