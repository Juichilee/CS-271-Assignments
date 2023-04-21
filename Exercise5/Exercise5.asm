; Exercise5.asm

; Author: Juichi Lee
; Date: Nov 4, 2019
; Description: Prompts the user for 2 numbers and performs addition, subtraction, multiplication, and division. 


.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE Irvine32.inc

.data
	intro1 BYTE "Juichi Lee's Simple Arithmetic Program.",0
	prompt1 BYTE "Please enter 2 numbers. The sum, difference, product, quotient, and remainder will be calculated using those numbers",0
	prompt2 BYTE "Number 1: ",0
	prompt3 BYTE "Number 2: ",0
	uNumber1 DWORD ?
	uNumber2 DWORD ?
	
	;	Variables to store results
	uSum DWORD ?
	uDiff DWORD ?
	uProd DWORD ?
	uQuot DWORD ?
	uRem DWORD ?

	sumResult BYTE "Your sum is: ",0
	diffResult BYTE "Your difference is: ",0
	prodResult BYTE "Your product is: ",0
	quoResult BYTE "Your integer quotient is: ",0
	remainResult BYTE " remainder: ",0

	bye1 BYTE "Thanks for Playing! Have a Seal Day!",0

.code

main proc

	Introduction:
		mov EDX, OFFSET intro1		; Print introduction
		call WriteString
		call Crlf
		call Crlf

	GetData:
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


	CalculateValues:
		mov EAX, uNumber1		; Addition 
		add EAX, uNumber2		
		; Step1: Fetch Instruction in IR: 0x2050
		; Step2: Increment IP to point to next instruction: 0x2054
		; Step3: Decode Instruction in IR: (add eax, uNumber2)
		; Step4: No memory access
		; Step5: Execute ADD Microprogram
		mov uSum, EAX

		mov EAX, uNumber1		; Subtraction
		sub EAX, uNumber2
		; Step1: Fetch Instruction in IR: 0x2058
		; Step2: Increment IP to point to next instruction: 0x205C
		; Step3: Decode Instruction in IR: (sub eax, uNumber2)
		; Step4: No memory access
		; Step5: Execute SUB Microprogram
		mov uDiff, EAX

		mov EAX, uNumber1		; Multiplication
		mul uNumber2
		mov uProd, EAX

		mov EAX, uNumber1		; Division
		div uNumber2
		mov uQuot, EAX
		mov uRem, EDX		; Store Remainder
		

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
		mov EAX, uQuot		; Print Quotient
		call WriteDec
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

	invoke ExitProcess,0

main endp
end main