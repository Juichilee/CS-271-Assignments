; Exercise5.asm
; Author: Juichi Lee
; Date: Nov 4, 2019
; Description: Prompts the user for 2 numbers and performs addition, subtraction, multiplication, and division. 

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE Irvine32.inc
UPPERLIMIT = 10
LOWERLIMIT = 1

.data
	intro1 BYTE "Juichi Lee's Simple Arithmetic Program.",0
	prompt1 BYTE "Please enter 2 numbers. The sum, difference, product, quotient, and remainder will be calculated using those numbers. The numbers have to be between 1 and 10 and the first number has to be greater than the second.",0
	prompt2 BYTE "Number 1: ",0
	prompt3 BYTE "Number 2: ",0
	errorPrompt BYTE "The first number has to be greater than the second and both have to be between 1-10.",0
	uNumber1 DWORD ?
	uNumber2 DWORD ?
	
	;	Variables to store results (no variable to store quotient because st(0) stores it after FDIV)
	uSum DWORD ?
	uDiff DWORD ?
	uProd DWORD ?
	uRem DWORD ?

	;	a list to store uNumber1 and uNumber to pass as reference into a procedure
	list BYTE 2 DUP(?)

	sumResult BYTE "Your sum is: ",0
	diffResult BYTE "Your difference is: ",0
	prodResult BYTE "Your product is: ",0
	quoResult BYTE "Your integer quotient is: ",0
	remainResult BYTE " remainder: ",0

	bye1 BYTE "Thanks for Playing! Have a Seal Day!",0

.code

;	// Main Program //
main proc
	Introduce:
	call Introduction

	RetrieveData:
	call GetData ; Retrieves the input from the user and stores them into uNumber1 and uNumber2.

	VerifyingInput:
	call CheckInput ; Stores verifying result in EAX. if uNumber1 and uNumber2 are valid, EAX = 1. Else, EAX = 0

	cmp EAX, 1
	JNE RetrieveData  ; If the output from verifying input is not true, then prompt the user again.

	CalculateValues:  ; The section for calculating all values
		call Addition	 ; Addition
		
		push uNumber2
		push uNumber1
		call Subtraction	; Subtraction

		push OFFSET uNumber1
		push OFFSET uNumber2
		call Multiplication		 ; Multiplication

		mov EAX, uNumber1
		mov EBX, uNumber2
		call Division	 ; Division
		mov uRem, 0

	DisplayResultsandGoodbye:
	call DisplayResultsGoodbye ; Displays the results and delivers goodbye message
	invoke ExitProcess,0
main endp

; // ALL PROCEDURES USED //

; Procedure to print introduction. 
; Receives: global variable intro1. 
; Returns: nothing. 
; Preconditions: intro1 is initialized. 
; Registers Changed: EDX.
Introduction PROC	; Print introduction
		mov EDX, OFFSET intro1		
		call WriteString
		call Crlf
		call Crlf
		ret
Introduction ENDP


; Procedure to get the two integer numbers from user. 
; Receives: prompt1, prompt2, prompt3, are global variables. 
; Returns: uNumber1 and uNumber2 global variables with the user's desired numbers. 
; Preconditions: prompt1, prompt2, prompt3, are initialized. 
; Registers Changed: EDX, EAX.
GetData PROC	; Getting the data from the user
		mov EDX, OFFSET prompt1		; Print first prompt
		call WriteString
		call Crlf
		call Crlf
		mov EDX, OFFSET prompt2		; Print second prompt
		call WriteString
		call Crlf		
		call ReadInt	; Take input for first number
		mov uNumber1, EAX
		call Crlf
		mov EDX, OFFSET prompt3		; Print third prompt
		call WriteString
		call Crlf			
		call ReadInt	; Take input for second number
		mov uNumber2, EAX
		call Crlf
		ret
GetData ENDP


; Procedure to check the user's inputted numbers. If the numbers are valid, EAX = 1. Otherise, EAX = 0. 
; Receives: uNumber1, uNumber2, errorPrompt, are global variables. UPPERLIMIT and LOWERLIMIT are constants. 
; Returns: EAX. 
; Preconditions: uNumber1, uNumber2, errorPrompt are initialized. uNumber1 and uNumber2 store an integer.  
; Registers Changed: EAX, EDX.
CheckInput PROC		; Checking the user's input
		mov EAX, uNumber2
		cmp uNumber1, EAX
		jl ErrorMessage
		cmp uNumber1, UPPERLIMIT
		jg ErrorMessage
		cmp uNumber1, LOWERLIMIT
		jl ErrorMessage
		cmp uNumber2, UPPERLIMIT
		jg ErrorMessage
		cmp uNumber2, LOWERLIMIT
		jl Errormessage
		mov EAX, 1
		ret

		ErrorMessage:
		mov EDX, offset errorPrompt
		call WriteString
		call Crlf
		mov EAX, 0
		ret
CheckInput ENDP


; Procedure to calculate the sum of 2 integers. 
; Receives: uNumber1 and uNumber2 are global variables. 
; Returns: uSum is a global variable. 
; Preconditions: uNumber1 is >= uNumber2 and both numbers are between 1 and 10. 
; Registers Changed: none.
Addition PROC	; Uses the FPU and parameters are accessed as global variables.
	FINIT
	FLD uNumber1
	FLD uNumber2
	FADD
	FSTP uSum
	ret
Addition ENDP


; Procedure to calculate the difference of 2 integers. 
; Receives: uNumber1 and uNumber2 are pushed onto the stack. 
; Returns: uDiff is a global variable. 
; Preconditions: uNumber2 and uNumber1 are pushed onto the stack in that order. uNumber1 is >= uNumber2 and both numbers are between 1 and 10. 
; Registers Changed: EAX, EBX.
Subtraction PROC	 ; Uses the CPU and parameters that are passed in using the system stack.
	push EBP
	mov EBP, ESP
	mov EAX, [EBP + 8]
	mov EBX, [EBP + 12]
	sub EAX, EBX
	mov uDiff, EAX
	pop EBP
	ret 8
Subtraction ENDP


; Procedure to calculate the product of 2 integers. 
; Receives: offset uNumber1 and offset uNumber2 pushed on the stack. 
; Returns: uProd is a global variable. 
; Preconditions: offset uNumber1 and offset uNumber2 are pushed onto the stack. uNumber1 is >= uNumber2 and both numbers are between 1 and 10. 
; Registers Changed: EAX, EBX.
Multiplication PROC		; Uses the CPU and parameters that are passed in by reference using the system stack.
	push EBP
	mov EBP, ESP
	mov EBX, [EBP + 8]
	mov EAX, [EBX]
	mov EBX, [EBP + 12]
	mov EBX, [EBX]
	mul EBX
	mov uProd, EAX
	pop EBP
	ret 4
Multiplication ENDP


; Procedure to calculate the quotient of 2 integers. 
; Receives: uNumber1 and uNumber2 are global variables. 
; Returns:  Quotient in ST(0). 
; Preconditions: uNumber1 and uNumber2 are initialized. uNumber1 is >= uNumber2 and both numbers are between 1 and 10. 
; Registers Changed: EAX, EBX.
Division PROC	 ; Uses the FPU and parameters passed in by registers.
	mov uNumber1, EAX
	mov uNumber2, EBX
	FINIT
	FLD uNumber1
	FLD uNumber2
	FDIV
	ret
Division ENDP


; Procedure to display the results and goodbye. 
; Receives: uSum, uDiff, uProd, are global variables that store the result. sumResult, diffResult, prodResult, bye1, are global variables that store the prompts. ST(0) stores quotient result. 
; Returns: Nothing. 
; Preconditions: All of the received variables are initialized. 
; Registers Changed: EAX, EDX.
DisplayResultsGoodbye PROC
	DisplayResults:	
		mov EDX, OFFSET sumResult
		call WRiteString
		mov EAX, uSum		; Print sum
		call WriteDec
		call Crlf
		call Crlf

		mov EDX, OFFSET diffResult
		call WRiteString
		mov EAX, uDiff		; Print difference
		call WriteDec
		call Crlf
		call Crlf

		mov EDX, OFFSET prodResult
		call WRiteString
		mov EAX, uProd		; Print product
		call WriteDec
		call Crlf
		call Crlf

		mov EDX, OFFSET quoResult
		call WRiteString
		call WriteFloat
		mov EDX, OFFSET remainResult
		call WRiteString
		mov EAX, uREm		; Print Remainder
		call WriteDec
		call Crlf
		call Crlf

	SayGoodbye:
		mov EDX, OFFSET bye1
		call WriteString
		call Crlf
		ret
DisplayResultsGoodbye ENDP

end main