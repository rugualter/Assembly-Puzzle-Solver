; program
; Calculate element inversions in a 4x4 puzzle
; 16 represents empty space

sizing			EQU 	16
errorcode		EQU 	FFFFh
SP_BEGIN      	EQU     FDFFh


; Variables
				ORIG 	8000h
puzzle			STR		5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3
tmp				WORD    0

; Program
				ORIG 	0000h
				MOV 	R7, SP_BEGIN
				MOV 	SP, R7
				CALL 	VALIDATION
				CMP 	R1, errorcode
				JMP.Z 	END
				CALL 	INVERSIONS
				
END: 			JMP 	END 				; end of program

INVERSIONS:		PUSH 	R4					; Preserve the records
				PUSH 	R5
				PUSH 	R6
				PUSH 	R7
				MOV	 	R7, sizing
				MOV 	M[tmp], R7			; Set the tmp variable to size - number of elements left
				MOV 	R4, 8000h			; Sets the starting address of the puzzle
				MOV 	R2, 0				; Set the inversion counter to 0
				MOV 	R6, 0				; Set the index to 0
				
LOOP1:			CMP 	R6, sizing			; Check if it's the end of the puzzle
				BR.Z 	OUT
				MOV 	R7, 0
				
LOOP2:			MOV 	R5, M[R4]			; Read current memory address with puzzle element
				INC 	R7
				CMP 	R7, M[tmp]			; Check if it's the end of the puzzle
				BR.Z 	LOOPEXIT2
				ADD 	R7, R4				; Catch the next puzzle element
				SUB 	R5, M[R7]			; Compares the current value with the value after it
				JMP.P 	INCREASE			; If greater then increment the inversion counter
				JMP.Z 	ERROR				; Error if element has same value
				SUB 	R7, R4				; Index reset of next value
				JMP 	LOOP2
				
INCREASE:		SUB 	R7, R4				; Index reset of next value
				INC 	R2					; Increase the inversion counter
				JMP 	LOOP2
				
LOOPEXIT2:		INC 	R4					; Increments the memory address for the next puzzle element
				INC 	R6					; Increases the index
				DEC 	M[tmp]				; Aggravates the number of missing elements
				JMP 	LOOP1				; Loop to next puzzle element
			
ERROR:			MOV 	R2, errorcode

OUT:			POP 	R7
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
				
LOOP3:			CMP 	R5, R7				; Check if the entire puzzle has been verified
				BR.Z 	OUT2
				
LOOP4:			ADD 	R6, R4				; Get the puzzle element
				CMP 	R5, M[R6]			; Compare with the element
				BR.Z 	INCREASE2			; If there is a match, increment the counter
				JMP 	NEXT
				
INCREASE2:	INC 	R2

NEXT:			SUB 	R6, R4
				INC 	R6					; move index forward
				CMP 	R6, sizing			; Check if it's the end of the puzzle
				JMP.NZ 	LOOP4				; Loop with the next element
				CMP 	R2, 1				; Checks if the element is only one
				BR.NZ 	ERROR2				; Checks if the element is only one
				INC 	R5					; next element
				MOV 	R2, 0				; Counter reset
				MOV 	R6, 0				; Reset index
				JMP 	LOOP3				; Loop with the next element
				
ERROR2:			MOV 	R1, errorcode

OUT2:			POP 	R7
				POP 	R6
				POP 	R5
				POP 	R4
				POP 	R3
				POP 	R2
				RET