; program
; Check if a 4x4 puzzle has a solution
; 16 represents empty space

dimension 		EQU 	4
empty			EQU 	16
sizing			EQU 	16
errorcode		EQU 	FFFFh
SP_BEGIN      	EQU     FDFFh


; Variaveis
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
				CALL 	MANHATTAN			; Call the subroutine to calculate the distance from Manhattan
				CMP 	R1, errorcode		; error checking
				BR.Z 	WRITEERROR
				CALL 	INVERSIONS			; Calls the CALCULATE as INVERSIONS subroutine
				CMP 	R2, errorcode		; error checking
				BR.Z 	WRITEERROR
				MOV 	R3, R1				
				ADD 	R3, R2				; Add the INVERSIONS distance from Manhattan
				AND 	R3, 1				; Check the last bit, if 1 then the number is odd
				XOR 	R3, 1				; Invert the last bit to put 1 for even number and 0 for odd number
				JMP 	END
				
WRITEERROR: 	MOV 	R3, errorcode

END: 			JMP 	END 				; END of program

MANHATTAN:		PUSH 	R4					; Preserve the records
				PUSH 	R5
				PUSH 	R6
				PUSH 	R7
				MOV 	R4, 8000h			; Defines the starting address of the puzzle
				MOV 	R6, 0				; Set the index to 0
				
SEARCHEMPTY:	MOV 	R5, M[R4]			; Read current memory address with puzzle element
				CMP 	R5, empty			; Check if the square is empty
				BR.Z 	CALCULATE			; If yes, it will CALCULATE the Manhattan distance
				INC 	R4					; INCREASE the memory address for the NEXT puzzle element
				INC 	R6					; INCREASE index
				CMP 	R6, sizing
				BR.NN 	ERROR1				; Check if there is overflow in the puzzle
				JMP 	SEARCHEMPTY			; Loop to NEXT puzzle element
				
CALCULATE:		MOV 	R7, dimension		; Define the simmension of the puzzle
				DIV 	R6, R7				; Split the index with the dimension. (dimension - quotient - 1) + (dimension - remainder - 1) is the distance from Manhattan to the last position of the puzzle.
				BR.O 	ERROR1				; Check division by 0
				MOV 	R1, dimension
				DEC 	R1
				SUB 	R1, R6				; dimension - 1 - quotient
				MOV 	R6, dimension
				DEC 	R6
				SUB 	R6, R7				; dimension - 1 - rest
				ADD 	R1, R6				; distance manhattan
				JMP 	OUT1
				
ERROR1:			MOV 	R1, errorcode

OUT1:			POP 	R7
				POP 	R6
				POP 	R5
				POP 	R4
				RET

INVERSIONS:		PUSH 	R4					; Preserve the records
				PUSH 	R5
				PUSH 	R6
				PUSH 	R7
				MOV 	R7, sizing
				MOV 	M[tmp], R7			; Defines the tmp variable for sizing - number of elements left
				MOV 	R4, 8000h			; Sets the starting address of the puzzle
				MOV 	R2, 0				; Set the inversion counter to 0
				MOV 	R6, 0				; Set the index to 0
				
LOOP1:			CMP 	R6, sizing			; Check if it is the END of the puzzle
				BR.Z 	OUT2
				MOV 	R7, 0
				
LOOP2:			MOV 	R5, M[R4]			; Read current memory address with puzzle element
				INC 	R7
				CMP 	R7, M[tmp]			; Check if it is the END of the puzzle
				BR.Z 	LOOPEXIT2
				ADD 	R7, R4				; Catch the NEXT puzzle element
				SUB 	R5, M[R7]			; Compares the current value with the value after it
				JMP.P 	INCREASE			; If greater then INCREASE the inversion counter
				JMP.Z 	ERROR2				; ERROR if element has the same value
				SUB 	R7, R4				; Reset index of NEXT value
				JMP 	LOOP2
				
INCREASE:		SUB 	R7, R4				; Reset index of NEXT value
				INC 	R2					; INCREASE the INVERSIONS counter
				JMP 	LOOP2
				
LOOPEXIT2:		INC 	R4					; INCREASE the memory address for the NEXT puzzle element
				INC 	R6					; INCREASE index
				DEC 	M[tmp]				; Aggravates the number of missing elements
				JMP 	LOOP1				; Loop to NEXT puzzle element
				
ERROR2:			MOV 	R2, errorcode

OUT2:			POP 	R7
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
				MOV 	R7, sizing			; sizing of puzzle
				INC 	R7
				
LOOP3:			CMP 	R5, R7				; Check if the entire puzzle has been verified
				BR.Z 	OUT3
				
LOOP4:			ADD 	R6, R4				; Get the puzzle element
				CMP 	R5, M[R6]			; Compare with the element
				BR.Z 	INCREASE2			; If there is a match INCREASE the counter
				JMP 	NEXT
				
INCREASE2:	INC 	R2

NEXT:		SUB 	R6, R4
				INC 	R6					; move index forward
				CMP 	R6, sizing			; Check if it is the END of the puzzle
				JMP.NZ 	LOOP4				; Loop with NEXT element
				CMP 	R2, 1				; Checks if the element is only one
				BR.NZ 	ERRO3				 ; If not, go to ERROR
				INC 	R5					; NEXT element
				MOV 	R2, 0				; Reset counter
				MOV 	R6, 0				; Reset index
				JMP 	LOOP3				; Loop eith NEXT element
				
ERRO3:			MOV 	R1, errorcode

OUT3:			POP 	R7
				POP 	R6
				POP 	R5
				POP 	R4
				POP 	R3
				POP 	R2
				RET