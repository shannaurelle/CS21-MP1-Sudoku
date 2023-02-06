# Sodoku Solver on MIPS
A MIPS implementation of a sudoku solver

## Background
This project is my final output for my course on machine language and assembly programming course. The project involves solving 4x4 sudoku boards first, then solve 9x9 sudoku board afterwards using MIPS assembly programming language. The repository contains separate solutions for 4x4 and 9x9 sudoku boards. 

## Methodology
This project overall implements backtracking with a small space optimization: usage of bit flags as primitive sets in assembly programming language. One may consult internet references however I prefer framing the problem in the data structures and algorithms mindset allows one to experiment in implementations.

## Discussion 
I believe that despite the seemingly separate solutions for the sudoku boards one may be able to create one program for both cases and to generalize it to nxn boards. There's a solution named Dancing Links method inspired from Donald Knuth and I highly suggest you watch his lectures on the topic.   

## Recommendations
This project only serves as a guide and template for programming sudoku solvers in MIPS assembly. With this, you may be able to program a sudoku solver in other assembly programming languages like x86 or ARM. You may also take the top notch and even implement a different algorithm like Dancing Links which handles cases of nxn boards very well. 
