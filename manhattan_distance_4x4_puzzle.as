; Program
; Calculate the distance Manhattan from the white space to the final position in a 4x4 puzzle
; 16 represents blank space

dimension 		EQU 	4
empty			EQU 	16
sizing			EQU 	16
errorcode		EQU 	FFFFh
SP_BEGIN      	EQU 	FDFFh

; Variables
				ORIG 	8000h
puzzle			STR		5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3

; Program
				ORIG 	0000h
				MOV 	R7, SP_BEGIN
				MOV 	SP, R7
				CALL 	VALIDATION
				CMP 	R1, errorcode
				JMP.Z 	END
				CALL 	MANHATTAN
END: 			JMP 	END 				;End of program

MANHATTAN:		PUSH 	R4					; Preserve the records
				PUSH 	R5
				PUSH 	R6
				PUSH 	R7
				MOV 	R4, puzzle			; sets the starting address of the puzzle
				MOV 	R6, 0				; sets the index to 0
				
EMPTYSEARCH:	MOV 	R5, M[R4]			; Read current memory address with puzzle element
				CMP 	R5, empty			; Check if it is the empty square
				BR.Z 	CALCULATE			; If yes, will calculate the distance to Manhattan
				INC 	R4					; Increments the memory address for the next puzzle element
				INC 	R6					; Increases the index
				CMP 	R6, sizing
				BR.NN 	ERROR1				; Check if there is overflow in the puzzle
				JMP 	EMPTYSEARCH		; Loop to next puzzle element
				
CALCULATE:		MOV 	R7, dimension		; Define the size of the puzzle
				DIV 	R6, R7				; Divides index by dimension. (dimension - quotient - 1) + (dimension - remainder - 1) is the Manhattan distance to the last position of the puzzle.
				BR.O 	ERROR1				; Check division by 0
				MOV 	R1, dimension
				DEC 	R1
				SUB 	R1, R6				; Dimension - 1 - quotient
				MOV 	R6, dimension
				DEC 	R6
				SUB 	R6, R7				; Dimension - 1 - rest
				ADD 	R1, R6				; distance manhattan
				JMP 	OUT1
				
ERROR1:			MOV 	R1, errorcode

OUT1:			POP 	R7
				POP 	R6
				POP 	R5
				POP 	R4
				RET
			
VALIDATION:   	PUSH 	R2					; Preserve the records
				PUSH 	R3
				PUSH 	R4
				PUSH 	R5
				PUSH 	R6
				PUSH 	R7
				MOV 	R2, 0				; Counter for element
				MOV 	R5, 1				; Element
				MOV 	R4, puzzle			; puzzle address
				MOV 	R6, 0				; Index
				MOV 	R7, sizing			; puzzle size
				INC 	R7
				
LOOP1:			CMP 	R5, R7				; Check if the whole puzzle is checked.
				BR.Z 	OUT2
				
LOOP2:			ADD 	R6, R4				; Collect puzzle element
				CMP 	R5, M[R6]			; Compare with element
				BR.Z 	FOUND			; If there is a match, the counter will increment
				JMP 	NEXT
				
FOUND:			INC 	R2

NEXT:			SUB 	R6, R4
				INC 	R6					; Move index forward
				CMP 	R6, sizing			; Check if it is the END of the puzzle
				JMP.NZ 	LOOP2				; loop with the next element
				CMP 	R2, 1				; Checks if an element is found exactly once
				BR.NZ 	ERROR2				; if not go to the error
				INC 	R5					; next element
				MOV 	R2, 0				; Counter Reset
				MOV 	R6, 0				; Index Reset
				JMP 	LOOP1				; loop with next element
				
ERROR2:			MOV 	R1, errorcode

OUT2:			POP 	R7
				POP 	R6
				POP 	R5
				POP 	R4
				POP 	R3
				POP 	R2
				RET