# Assembly-Puzzle-Solver
P3 Assembly Puzzle Solvers

Get the P3 assemler at https://github.com/goncalomb/p3js

Developed a P3 Assembly program that uses a given puzzle (4x4) calculate the distance of Manhattan from empty space to the lower right corner.
The program takes as input a 16-position integer vector, which represents a given puzzle, presented in memory in a row, from position 8000h. The program exit, ie the requested distance from Manhattan, is presented in the record R1. If there is an error situation, the value FFFFh is returned in R1.

Developed a P3 Assembly program that receives as input a given puzzle, in the same format as the previous paragraph, and return in record R2 the total number of inversions of each of the 16 positions of the puzzle board given up to to the final position. If there is an error situation, the value FFFFh is returned in R2.

Developed a P3 Assembly program that receives a puzzle in the format described 4x4 and determines if it is solvable, in which case displays the value 1 in register R3. If the puzzle is not solvable, the value returned in end of program in R3 is 0. If any error occurred, the return value in R3 it is FFFFh.

Developed a P3 Assembly program which checks if a given NxN puzzle is solvable. Dimension N will be indicated in the 8000h position.
