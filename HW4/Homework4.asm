;Homework4.asm
; Author: Juichi Lee
; Date: Nov 24, 2019
; Description: Prompts the user for a range between 10 - 200, creates an array, stores random integers into the array, and then displays the sorted array. 

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

INCLUDE Irvine32.inc
MAXLIMIT = 200
MINLIMIT = 10

RMAXLIMIT = 999
RMINLIMIT = 100

;	// ALL MACROS USED //
; Calls the Crlf function from the Irvine Library.
; Pre-Conditions: None.
; Post-Conditions: Makes a new line. 
mCrlf macro
	pushad
	call Crlf
	popad
ENDM

; Reads an integer from the user and stores it into param1.
; Pre-Conditions: param1 is a DWORD.
; Post-Conditions: param1 contains integer from ReadInt.
mReadInt macro param1
	push EAX
	call ReadInt
	mov param1, EAX
	pop EAX
ENDM

; Writes the integer stored in param1. 
; Pre-Conditions: param1 stores an integer.
; Post-Conditions: The integer stored in param1 is printed to screen.
mWriteInt macro param1
	push EAX
	mov EAX, param1
	call WriteInt
	pop EAX;
ENDM

; Writes a string from param1 onto the screen.
; Pre-Conditions: param1 contains a string.
; Post-Conditions: The string stored in param1 is printed to screen.
mWriteString macro param1
	push EDX
	mov EDX, offset param1
	call WriteString
	pop EDX
ENDM

; Re-seeds the random number generator.
; Pre-Conditions: None.
; Post-Conditions: None.
mRandomize macro
	pushad
	call Randomize
	popad
ENDM

; Generates a random number from 0 to param1-1.
; Pre-Conditions: param1 contains a non-zero integer.
; Post-Conditions: A random number is stored into param2. 
mRandomRange macro param1, param2
	push EAX
	mov EAX, param1
	call RandomRange
	mov param2, EAX
	pop EAX
ENDM

; Multiplies param1 with param2 and stores result in param3.
; Pre-Conditions: param1 and param2 are integers.
; Post-Conditions: product of param1 and param2 are stored into param3.
mMul macro param1, param2, param3
	push EAX
	mov EAX, param1
	call mul param2
	mov param3, EAX
	pop EAX
ENDM

; Multiplies param1 with param2 and stores result in param3.
; Pre-Conditions: param1 and param2 are integers.
; Post-Conditions: product of param1 and param2 are stored into param3.
mMultiply macro param1, param2, param3
	push EAX
	mov EAX, param1
	mul param2
	mov param3, EAX
	pop EAX
ENDM

;	// All MACROS USED END. DATA SECTION BEGIN //

.data
	intro1 BYTE "Welcome to Juichi Lee's Arrays and Sorting Program!",0
	prompt BYTE "Please enter a size for the array [min = 10 - max = 200] inclusive.",0
	prompt1 BYTE "The program will populate the array with random numbers(100-999) and sort it using Selection Sort.",0
	prompt2 BYTE "Size: ",0
	errorPrompt BYTE "The range entered is not within [10 -200].",0
	unsortedArrayPrompt BYTE "Unsorted Array: ",0
	sortedArrayPrompt BYTE "Sorted Array(Descending Order): ",0

	uSize DWORD ? ; variable used to store the size.
	array DWORD MAXLIMIT DUP(?) ; array used to store and sort random numbers.
	temp DWORD ? ; temporary variable for creating the array.
	numTermsPerLine DWORD 0  ; Stores the current num words in a line.
	i DWORD ?	; Variables for selection sort proc and general use.
	k DWORD ?
	j DWORD ?

	medianPrompt BYTE "The Median is: ",0
	meanPrompt BYTE "The Mean is: ",0

	bye1 BYTE "Thanks for Playing! Have a Seal Day!",0

.code

;	// DATA SECTION END. MAIN PROGRAM BEGIN //
main proc
	Introduce:
	call Introduction

	RetrieveData:
	call GetData ; Retrieves the input from the user and stores them into uMin and .

	VerifyingInput:
	call CheckInput ; Stores verifying result in EAX. if uSize and  are valid, EAX = 1. Else, EAX = 0

	cmp EAX, 1
	JNE RetrieveData  ; If the output from verifying input is not true, then prompt the user again.

	push offset array	
	push uSize
	call CreateArray	; Creates an array with random numbers.

	mWriteString unsortedArrayPrompt
	mCrlf
	push offset array
	push uSize
	call PrintArray			; Prints the array.

	push offset array
	push uSize
	call SelectionSort		; Sorts the array from largest to smallest.

	mCrlf
	mCrlf
	mWriteString sortedArrayPrompt
	mCrlf
	push offset array
	push uSize
	call PrintArray			; Prints the array.

	mCrlf
	push offset array
	push uSize
	call CalculateMedian	; Calculates the array's median. 

	mCrlf
	push offset array
	push uSize
	call CalculateMean		; Calculates the array's mean.

	mCrlf
	mCrlf
	mWriteString bye1
	mCrlf

	invoke ExitProcess,0
main endp

; // MAIN PROGRAM END. ALL PROCEDURES USED BEGIN //

; Procedure to print introduction. 
; Receives: global variable intro1. 
; Returns: nothing. 
; Preconditions: intro1 is initialized. 
; Registers Changed: EDX.
Introduction PROC	; Print introduction
		mWriteString intro1
		mCrlf
		mCrlf
		ret
Introduction ENDP

; Procedure to get the two integer numbers from user. 
; Receives: prompt1, prompt2, prompt3, are global variables. 
; Returns: uSize global variable with the user's desired numbers. 
; Preconditions: prompt1, prompt2, prompt3, are initialized. 
; Registers Changed: EDX, EAX.
GetData PROC	; Getting the data from the user
		mWriteString prompt
		mCrlf
		mWriteString prompt1
		mCrlf
		mCrlf
		mWriteString prompt2
		mCrlf		
		mReadInt uSize	; Take input for first number
		mCrlf
		ret
GetData ENDP

; Procedure to check the user's inputted numbers. If the numbers are valid, EAX = 1. Otherise, EAX = 0. 
; Receives: uSize, errorPrompt, are global variables. MAXLIMIT and MINLIMIT are constants. 
; Returns: EAX. 
; Preconditions: uSize, errorPrompt are initialized. uSize, store an integer.  
; Registers Changed: EAX, EDX.
CheckInput PROC		; Checking the user's input
		cmp uSize, MINLIMIT
		jl ErrorMessage
		cmp uSize, MAXLIMIT
		jg ErrorMessage
		mov EAX, 1
		ret
		ErrorMessage:
		mWriteString errorPrompt
		mCrlf
		mov EAX, 0
		ret
CheckInput ENDP

; Procedure to create an array based on the range the user provided.
; Receives: uSize.
; Returns: An array of size uSize with random numbers from 100 - 999 in each index.
; Preconditions: uSize is within the range 10 - 200.
; Registers Changed: None.
CreateArray PROC
	pushad
	mov EBP, ESP
	mov EDI, [EBP + 40] ; @list in EDI
	mov EBX, 0 ; index in EBX
	mov ECX, [EBP + 36] ; uSize/Count in ECX
	mRandomize

	more:
	mRandomRange 899, temp
	add temp, 100
	mov EAX, temp
	mov [EDI + EBX], EAX			; Base Indexed Addressing.
	add EBX, 4
	loop more
	popad
	ret 8
CreateArray ENDP

; Procedure to print an array
; Receives: a DWORD array andthe size of the array.
; Returns: The printed array to the screen.
; Preconditions: uSize is within the range 10-200.
; Registers changed: None.
PrintArray PROC
	pushad
	mov EBP, ESP
	mov EDI, [EBP + 40] ; @ list in EDI
	mov EBX, 0 ; index in EBX
	mov ECX, [EBP + 36] ; uSize/Count in ECX
	mov numTermsPerLine, 0

	more: 
	mov EAX, [EDI + EBX]
	mWriteInt EAX
	add EBX, 4

	; increment numTermsPerLine.
	mov EAX, numTermsPerLine
	add EAX, 1
	mov numTermsPerLine, EAX

	; check if current term is 10th term.
	cmp numTermsPerLine, 10
	jne Not10thterm
	call Crlf
	mov numTermsPerLine, 0

	Not10thTerm:
	loop more
	popad
	ret
PrintArray ENDP

; Procedure to selection sort an array.
; Receives: a Dword Array and the size of the array.
; Returns: a sorted array with numbers ordered from smallest to largest.
; Preconditions: uSize is within the range 10 - 200.
; Registers changed: None.
SelectionSort PROC
	; i, k, j are the indexes in the array after registers have been multiplied by 4 bytes.
	; Initialize all i, k, j as 0.
	mov i, 0
	mov k, 0
	mov j, 0
	pushad	; Save register memory prior to procedure.
	mov EBP, ESP
	mov EDI, [EBP + 40] ; @ array in the stack.
	;mov uSize, [EBP + 36]; uSize/Count stored in uSize.
	;inc uSize

	mov EAX, uSize	; EAX is the uSize-1
	dec EAX

	mov ECX, 0		; ECX is outer loop's counter (k)

	outerLoop:
		cmp ECX, EAX
		je done

		mMultiply 4, ECX, k		; Set i to k
		push ECX
		mov ECX, k
		mov i, ECX
		pop ECX

		mov EBX, ECX	; EBX is inner loop's counter (j)
		add EBX, 1

	innerLoop:
		mMultiply 4, EBX, j		; Set j from EBX
		
		push ECX
		mov ECX, i
		mov EDX, [EDI + ECX]	; array[i]		; Base Indexed Addressing.
		mov ECX, j
		mov ESI, [EDI + ECX]	; array[j]
		pop ECX

		cmp ESI, EDX
		jle NOTIF
		push ECX	;	Set i to j
		mov ECX, j
		mov i, ECX
		pop ECX

		NOTIF:

		cmp EBX, uSize
		je innerLoopDone
		inc EBX
		jmp innerLoop

	innerLoopDone:
		call Swap
		inc ECX
		jmp outerLoop

	done: 
		popad
		ret
SelectionSort ENDP

; Procedure to swap the two values at index k and i.
Swap PROC
	pushad		; Base Indexed Addressing.

	mov ECX, k
	mov EDX, [EDI + ECX]	; array[k]				
	mov EAX, i
	mov ESI, [EDI + EAX]	; array[i]
	
	mov [EDI + EAX], EDX	; Swap their values
	mov [EDI + ECX], ESI

	popad
	ret
Swap ENDP

; Procedure to calculate the array median.
; Receives: an array and the length of the array.
; Returns: the median of the array.
; Pre-conditions: the array and length are both initialized.
; Registers changed: none. 
CalculateMedian PROC
	pushad
	mov EDI, [ESP + 40]		; the array offset
	mov ECX, [ESP + 36]		; the uSize
	
	push ECX
	mov EAX, ECX
	mov ECX, 2
	xor EDX, EDX
	div ECX
	pop ECX

	test ECX, 1 
	jz	evenNumber

	oddNumber:			; Base Indexed Addressing.
		mov ECX, EAX
		mMultiply 4, ECX, j
		mov ECX, j
		mov EDX, [EDI + ECX]
		mCrlf
		mWriteString medianPrompt
		mWriteInt EDX

		jmp next
	evenNumber:
		mov ECX, EAX	; EAX is upper index, ECX is lower index.
		dec ECX		
		push ECX
		mov ECX, 4
		mul ECX			; change into bytes.
		mov j, EAX
		pop ECX
		mMultiply 4, ECX, k		; change into bytes.
		mov EAX, j
		mov ECX, k
		mov ESI, [EDi + EAX]	; Base Indexed Addressing.
		mov EDX, [EDI + ECX]
		mov EAX, EDX
		add EAX, ESI
		mov EBX, 2
		xor EDX, EDX
		div EBX
		mov EDX, EAX
		
		mCrlf
		mWriteString medianPrompt
		mWriteInt EDX

	next:

	popad
	ret 8
CalculateMedian ENDP

; Procedure to calculate the array mean.
; Receives: an array and the length of the array.
; Returns: the mean of the array.
; Pre-conditions: the array and length are both initialized.
; Registers changed: none. 
CalculateMean PROC
	pushad
	mov EDI, [ESP + 40]		; offset of array
	mov ECX, [ESP + 36]		; uSize 
	mov EAX, 0
	mov EBX, ECX		; Store the uSize for later.

	sumLoop:		; Indexed Addressing.
	add EAX, [EDI]
	add EDI, 4
	loop sumLoop

	xor EDX, EDX
	div EBX			; divide sum by uSize to get average.
	mCrlf
	mWriteString meanPrompt
	mWriteInt EAX

	popad
	ret 8
CalculateMean ENDP

;	// ALL PROCEDURES USED END //

end main