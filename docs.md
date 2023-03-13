# High-level documentation

## Key Objectives
1. Express the problem as something the computer can understand
2. Execute the program with the least amount of instructions as possible
3. Deliver the intended output of the project

## Introduction

### Background of the Problem

Sudoku is a puzzle where one number can only be present in a row, column, or a region.
These three constraints can be solved through backtracking, yet the great challenge lies
in trimming the number of instructions executed so the program can run efficiently and aid
the programmer to document it in a short time. This file demonstrates the necessary framework
for the solution.

### Scope and Limitations

This project will only tackle two cases, one 4x4 sudoku and one 9x9 sudoku. The solver will accept
4 lines of input for the 4x4 sudoku with 4 characters each line, and 9 lines of input for the 9x9 sudoku
with 9 characters each line. The project should be submitted on or before May 1, 2022 with the pdf
documentation and video documentation included. 

### Definitions and Terms

- Sudoku := a number puzzle where numbers are placed according to the constraints per row, column, and region
- Row := a string consisting of ascii characters of numbers
- Column := a collection of each ith character from all rows, where i is the position of the character in the string
- Region := a square which consists of characters in close proximity to each other with respect to length and width
- Bitstring := a number represented as a string of 1s and 0s 
- Solution := a sudoku where each number is present once in each row, column, and region
- Cell := a character in the sudoku board

## Review of Related Literature

For sudoku, several solutions exist in literature which gives an optimal solution to the problem. One may refer to trial
and error solution with pruning, which is also known as backtracking. This allows the solver to skip many unnecessary branches
in the space of possible partial solution of sudoku boards. Another improvement to this would be randomizing the trials
rather than deterministically choosing the trials, which gives some degree of pruning than trying all possibilities. 

For other ways, one may also refer to sudoku as an exact cover problem. In this case, Algorithm X by Donald Knuth
can deal with this formulation. Another set of algorithms also can refer to heuristics, which alongside doing
trials, uses rules made by humans to guide it in arriving to an optimal solution faster.

## Methodology

For this project, extreme care is taken with simplicity and reduction of instructions. As such, the simpler the data 
structures involved, the less instructions executed. This is because MARS MIPS, which is the simulator for the 
assembly project is single-cycle and runs in Java, which is known to be slower in implementing the instructions
compared to a MIPS-compliant compiler and hardware which runs in pipelined implementation.

The main insights are the following from randomized backtracking:

The solution for the sudoku is as follows:
1. Try a cell in the sudoku board with a zero
2. Replace the zero with a number from 1 to n (n here can be 4 or 9)
3. If the new cell still follow the rules, go to step 1 
4. If the cell doesnt follow the rules, replace it with previous number (backtrack) and go to step 2
5. If all possible trials were done and there is still no solution, print no solution

For representing this in a computer here are the following approaches:
- For checking the rules, in practice it is done with sets, a data structure where uniqueness of elements are enforced
- Check is done on the cell replaced, and each cell must conform to three assigned sets: the row, column, and region
- In the computer we will do this using bitstrings as a set
- Representing the set is a 32-bit long bitstring, and each number n is paired to a number 2^(n-1) on the set
- Hence the pairs are (1,1) (2,2), (3,4), (4,8), (5,16), (6,32), (7,64), (8,128), (9,256)
- And a set of {1,6,7} would correspond to a 32-bit bitstring of 0x000000C1 in HEX
- And a set of {1,2,3} would correspond to a 32-bit bitstring of 0x00000007 in HEX
- For checking if a number exists on a set, performing an AND on the number pair and the set suffices
- Performing logical AND from the HEX 0x00000007 of set {1,2,3} and 0x00000001 of the element 1 gives the hex of the element
- These are certainly greater than zero which means the element is already present in the set, which implies the rules are violated
- To shorten these instructions, perform a logical OR to all three sets and its result must perform a logical AND to the element 
- Again, if the result of the logical operations is a HEX number greater than zero, the rules are violated 
- If the result is zero, then the rules are enforced, continue 
- For the display, note that in ascii, numbers start from 48 as 0, 49 as 1, and 57 as 9
- So during the algorithm the numbers in display must be replaced often 

### Data Segment Template

- First n entries refers to sets for the row constraint with offset of 0 bytes in memory
- Second n entries refers to sets for the column constraint with offset of 4n bytes in memory 
- Third n entries refers to sets for the region constraint with offset of 8n bytes in memory
- Total memory expenditure is 12n bytes which is O(n) memory used

## Mars.jar command for running the project

```Measure-Command { cat input.txt | java -jar 'Mars.jar' sm nc '202010670_4.asm' | Out-Default } ``
```Measure-Command { cat input2.txt | java -jar 'Mars.jar' sm nc '202010670_9.asm' | Out-Default } ``



 


