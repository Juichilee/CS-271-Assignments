; Exercise Week6.asm
; Author: Juichi Lee
; Date Nov/11/2019
; Description: Calculates Fibonacci numbers between 1 and nth term.

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE Irvine32.inc

.data
	intro1 BYTE "Welcome to Juichi Lee's Exercise 6 Fibonacci number calculator!",0
	prompt1 BYTE "What is your name?",0
	MAX = 80
	userName BYTE MAX+1 DUP (?); Input buffer for user's name
	greetings1 BYTE "Greetings ",0
	prompt2 BYTE "Please enter the umber of Fibonacci terms to be displayed.",0
	prompt3 BYTE "Give the number as an integer in the range [1 .. 46].",0
	prompt4 BYTE "How many Fibonacci terms do you want? ",0

	numTerms DWORD ? ; Number of terms the user wants
	spacing BYTE "  ",0

	numTermsPerLine DWORD ? ; Stores the current number of terms on a line

	n1 DWORD ? ; Placeholder for first number
	n2 DWORD ? ; Placeholder for second number
	n3 DWORD ? ; Placeholder for third number

	promptError BYTE "Out of range. Enter a number in [1 .. 46]",0
	bye1 BYTE "Results certified by a baby harp seal.",0
	bye2 BYTE "Goodbye. Nice knowin ya ",0

.code
main proc
	
	Introduction:
		mov EDX, offset intro1
		call WriteString
		call Crlf

	GetUserName:
		mov EDX, offset prompt1
		call WriteString
		call Crlf

		mov EDX, offset userName
		mov ECX, MAX
		call ReadString; Readstring stores the user's inputted string into the location of userName through EDX. It reads characters up until MAX.
		call Crlf

		mov EDX, offset greetings1
		call WriteString
		mov EDX, offset userName
		call WriteString
		call Crlf

	DisplayInputPrompts:
		mov EDX, offset prompt2
		call WriteString
		call Crlf
		mov EDX, offset prompt3
		call WriteString
		call Crlf
	
	GetNumberOfTerms:
	; Gets the user input.
		mov EDX, offset prompt4
		call WriteString
		call Crlf
		call ReadInt
		
	; Checking if input is within range.
		cmp EAX, 46
		JG ErrorMessage; If value is greater than max range, jump to error message.
		cmp EAX, 1
		JL ErrorMessage; If value is less than min range, jump to error message.
		mov numTerms, EAX; mov valid input number into numTerms for use later
		jmp Outofif

	ErrorMessage:
	; Warns the user that the entered value is not within range.
		call Crlf
		mov EDX, offset promptError
		call WriteString
		call Crlf
		jmp GetNumberOfTerms

	Outofif:
		mov n1, 0; initialize first number.
		mov n2, 1; initialize second number and accumulator.
		mov numTermsPerLine, 1; Initialize the current number of terms per line.
		mov ECX, 2; initalize loop control variable.
		
		mov EAX, 1;
		call WriteDec; Print the initial 1.
		mov EDX, offset spacing; Initialize EDX with spacing.
		call WriteString

		cmp numTerms, 1
		je Goodbye

	FibonacciSequence:
	; Moving numbers stored in data variables from initial or last loop into EBX and EAX and storing the sum result into EAX.
		mov EBX, n1
		mov EAX, n2
		mov n3, EAX
		add EAX, EBX

	; Print out the result number in EAX and add spacing
		call WriteDec
		call WriteString

	; Place results in registers back in corresponding data variables for next loop.
		mov n2, EAX
		mov EAX, n3
		mov n1, EAX
		
	; Increment numTermsPerLine.
		mov EAX, numTermsPerLine
		add EAX, 1
		mov numTermsPerLine, EAX
		
	; Checking if current term is 5th term. If not 5th term, go to Not5thTerm label.
		cmp numTermsPerLine, 5
		jne Not5thTerm
		
	; If the current term is the 5th term, add new line and reset numTermsPerLine to 0.
		call Crlf
		mov numTermsPerLine, 0

		Not5thTerm:
	; Increment loop counter and check if ECX is still less than or equal to numTerms.
		add ECX, 1
		cmp ECX, numTerms
		jle FibonacciSequence
		
	Goodbye:
		call Crlf
		mov EDX, offset bye1
		call WriteString
		call Crlf
		mov EDX, offset bye2
		call WriteString
		mov EDX, offset userName
		call WriteString
		call Crlf

	invoke ExitProcess,0
main endp
end main