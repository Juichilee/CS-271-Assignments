TITLE Battleship     (Battleship.asm)

; Author: ??????????
; Course / Project ID: CS271             Date: 03/03/19
; Description: Plays battleship vs computer

INCLUDE Irvine32.inc

;CONSTANTS

max = 25

.data
welcstr		BYTE	"Welcome to Battleship!", 10, 13, 0
seedstr		BYTE	"Please enter a number between 0 and 4,294,967,295 (Bigger Numbers take longer to load)", 10, 13, 0
spcstr		BYTE	" " , 0
brdlets		BYTE	"   1   2   3   4   5", 10, 13, 0

plc3str		BYTE	"Place your 3 length ship...", 10, 13, 0
plc2str		BYTE	"Place your 2 length ship...", 10, 13, 0
plc1str		BYTE	"Place your 1 length ship...", 10, 13, 0
rotstr		BYTE	"How do you want the ship rotated? [1 = Vertical] [2 = Horizontal]", 10, 13, 0
plcvstr		BYTE	"Where do you want the top of the ship to be?", 10, 13, 0
plchstr		BYTE	"Where do you want the left side of the ship to be?", 10, 13, 0
hrzstr		BYTE	"Column (Top Numbers): ", 0
vrtstr		BYTE	"Row (Side Numbers): ", 0
invstr		BYTE	"Invalid Choice. Please Try Again...", 10, 13, 0
shpstr		BYTE	"Invalid Choice. There is already a ship there. Please Try Again...", 10, 13, 0
brd1str		BYTE	"Your Board:", 10, 13, 0
brd2str		BYTE	"Your Radar:", 10, 13, 0
askstr		BYTE	"Please Enter a Target Coordinates...", 10, 13, 0
pegstr		BYTE	"Invalid Choice. There is already a peg there. Please Try Again...", 10, 13, 0
hitstr		BYTE	"HIT!", 10, 13, 0
mssstr		BYTE	"MISS!", 10, 13, 0
chitstr		BYTE	"The computer HIT you!", 10, 13, 0
cmssstr		BYTE	"The computer MISSED!", 10, 13, 0
winstr		BYTE	"--= You WON against the computer! Outstanding Moves! =--", 10, 13, 0
losestr		BYTE	"--= You LOST against the computer! Better Luck Next Time! =--", 10, 13, 0
agnstr		BYTE	"Do you want to play again? [1 = Yes] [2 = No]", 0
objstr		BYTE	"Objectives:", 10, 13, 0
obrkstr		BYTE	"[" , 0
cbrkstr		BYTE	"]" , 0
xstr		BYTE	"X", 0
ostr		BYTE	"O", 0
snk3str		BYTE	"] - 3 x 1 sunk ", 0 
snk2str		BYTE	"] - 2 x 1 sunk ", 0 
snk1str		BYTE	"] - 1 x 1 sunk ", 10, 13, 0 



strnum		DWORD	1


board1		DWORD	max		DUP (?)
board2		DWORD	max		DUP (?)

.code

main PROC

	call	intro

	push	OFFSET board1
	call	fillboard
	push	OFFSET board2
	call	fillboard
	;
	push	OFFSET board2
	push	OFFSET board1
	call	display

	push	OFFSET board1
	call	plc3ship

	push	OFFSET board2
	push	OFFSET board1
	call	display

	push	OFFSET board1
	call	plc2ship

	push	OFFSET board2
	push	OFFSET board1
	call	display

	push	OFFSET board1
	call	plc1ship
	
	push	OFFSET board2
	push	OFFSET board1
	call	display
	;TESTING ONLY DELETE LATER __________________________
	;push	OFFSET board1
	;call	cplc3ship
	;push	OFFSET board1
	;call	cplc2ship
	;push	OFFSET board1
	;call	cplc1ship
	;_____________________________________________________
	;computer places ship
	push	OFFSET board2
	call	cplc3ship
	push	OFFSET board2
	call	cplc2ship
	push	OFFSET board2
	call	cplc1ship

	turns:
		push	OFFSET board2
		push	OFFSET board1
		call	display
		push	OFFSET board2
		push	OFFSET board1
		call	chckbrd

		push	OFFSET board2
		call	plyrtrn

		push	OFFSET board2
		push	OFFSET board1
		call	display
		push	OFFSET board2
		push	OFFSET board1
		call	chckbrd

		push	OFFSET board1
		call	comptrn


		jmp		turns
	


	exit	; exit to operating system
main ENDP

;Greets user with title
intro		PROC
	
	mov		edx, OFFSET welcstr
	call	WriteString
	call	Crlf
	getseed:
		mov		edx, OFFSET seedstr
		call	WriteString
		call	ReadDec
		jnc		runseed
		mov		edx, OFFSET invstr
		call	WriteString
		jmp		getseed
	runseed:
		mov		ecx, eax
		inc		ecx
		floop:
			mov		eax, 1
			call	RandomRange
			loop	floop

	call	WaitMsg
	call	Clrscr

	ret

intro		ENDP

;start of game, fills board with 0 (empty)
fillboard	PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]
	

	mov		ecx, 25
	mov		eax, 0
	forloop:
		mov		[esi], eax
		add		esi, 4
		loop	forloop

	pop		ebp
	ret		4
fillboard	ENDP
display		Proc
	push	ebp
	mov		ebp, esp	
	mov		esi, [ebp + 8]	;player board
	mov		edi, [ebp + 12] ;comp board

	call	Clrscr
	;Displaying Computer's Board/Player's Radar
	mov		edx, OFFSET brd2str
	call	WriteString

	mov		edx, OFFSET brdlets
	call	WriteString

	mov		strnum, 1
	mov		ecx, 25
	mov		eax, 0
	mov		ebx, 0
	mov		edx, OFFSET spcstr

	mov		eax, strnum
	call	WriteDec
	call	WriteString
	inc		strnum

	forloop2:
		mov		edx, OFFSET obrkstr
		call	WriteString

		mov		eax, [edi]

		cmp		eax, 0
		JE		nothing2
		cmp		eax, 4
		JE		miss2
		cmp		eax, 5
		JE		hit2
		nothing2:
			mov		edx, OFFSET spcstr
			call	WriteString
			jmp		doneprinting2
		hit2:
			mov		edx, OFFSET xstr
			call	WriteString
			jmp		doneprinting2
		miss2:
			mov		edx, OFFSET ostr
			call	WriteString
		doneprinting2:
			mov		edx, OFFSET cbrkstr
			call	WriteString
			mov		edx, OFFSET spcstr
			call	WriteString
			add		edi, 4
			inc		ebx

			cmp		ebx, 5
			JL		nonewline2
			call	Crlf
			cmp		strnum, 6
			JE		skp2
			mov		eax, strnum
			call	WriteDec
			mov		edx, OFFSET spcstr
			call	WriteString
			inc		strnum
			skp2:
				mov		ebx, 0
			nonewline2:
				dec		ecx
				cmp		ecx, 0
				JE		leaveloop2
				jmp		forloop2
			leaveloop2:

	;Displaying Player's Board
	mov		edx, OFFSET brd1str
	call	WriteString

	mov		edx, OFFSET brdlets
	call	WriteString

	mov		strnum, 1
	mov		ecx, 25
	mov		eax, 0
	mov		ebx, 0
	mov		edx, OFFSET spcstr

	mov		eax, strnum
	call	WriteDec
	call	WriteString
	inc		strnum

	forloop1:
	mov		edx, OFFSET obrkstr
		call	WriteString

		mov		eax, [esi]

		cmp		eax, 0
		JE		nothing1
		cmp		eax, 4
		JE		miss1
		cmp		eax, 5
		JE		hit1
		shipthere:
			call	WriteDec
			jmp		doneprinting1
		nothing1:
			mov		edx, OFFSET spcstr
			call	WriteString
			jmp		doneprinting1
		hit1:
			mov		edx, OFFSET xstr
			call	WriteString
			jmp		doneprinting1
		miss1:
			mov		edx, OFFSET ostr
			call	WriteString
		doneprinting1:
			mov		edx, OFFSET cbrkstr
			call	WriteString
			mov		edx, OFFSET spcstr
			call	WriteString

			add		esi, 4
			inc		ebx
			cmp		ebx, 5
			JL		nonewline1
			call	Crlf
			cmp		strnum, 6
			JE		skp1
			mov		eax, strnum
			call	WriteDec
			call	WriteString
			inc		strnum
			skp1:
				mov		ebx, 0

			nonewline1:
				dec		ecx
				cmp		ecx, 0
				JE		leaveloop1
				jmp		forloop1
			leaveloop1:

	;Printing the Objectives
	;mov		edx, OFFSET objstr
	;call	WriteString
	;mov		edx, OFFSET obrkstr
	;call	WriteString
	;mov		edx, OFFSET spcstr
	;call	WriteString
	;mov		edx, OFFSET snk3str
	;call	WriteString
	;mov		edx, OFFSET obrkstr
	;call	WriteString
	;mov		edx, OFFSET spcstr
	;call	WriteString
	;mov		edx, OFFSET snk2str
	;call	WriteString
	;mov		edx, OFFSET obrkstr
	;call	WriteString
	;mov		edx, OFFSET spcstr
	;call	WriteString
	;mov		edx, OFFSET snk1str
	;call	WriteString
	;call	Crlf

	pop		ebp
	ret		4
display		ENDP
plc3ship		PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	mov		edx, OFFSET plc3str
	call	WriteString
	ask:
		mov		edx, OFFSET rotstr
		call	WriteString
		call	ReadInt
		cmp		eax, 1
		JE		vertical
		cmp		eax, 2
		JE		horizontal
		JNE		invalid

	vertical:
		mov		edx, OFFSET plcvstr
		call	WriteString 
		askvh:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			mov		ebx, eax
			cmp		eax, 5
			JG		invalidvh
			cmp		eax, 0
			JL		invalidvh
			JG		askvv
			invalidvh:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		vertical
		askvv:
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 3
			JG		invalidvv
			cmp		eax, 0
			JL		invalidvv
			JG		place3shipv
			invalidvv:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		vertical
		place3shipv: ;repetative
				
				
				;(v - 1 * 5) + h h = ebx v = eax
				mov		ecx, eax
				mov		eax, 5
		
				dec		ecx
				mul		ecx
				add		eax, ebx

				;puts ship on array at eax
				dec		eax
				mov		ecx, eax
				findSpotv:
					add		esi, 4
					loop	findSpotv
				mov		ecx, 3
				mov		edx, 3
				dropshipv:
					mov		[esi], edx
					add		esi, 20
					loop	dropshipv
			jmp		exitfnc
		
	horizontal:
		mov		edx, OFFSET plchstr
		call	WriteString 
		askhh:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			cmp		eax, 3
			JG		invalidhh
			cmp		eax, 0
			JL		invalidhh
			JG		askhv
			invalidhh:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		horizontal
		askhv:
			mov		ebx, eax
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 5
			JG		invalidhv
			cmp		eax, 0
			JL		invalidhv
			JG		place3shiph
			invalidhv:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		horizontal
		place3shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 3
			mov		edx, 3
			dropshiph:
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
			jmp		exitfnc


	invalid:
		mov		edx, OFFSET invstr
		call	WriteString
		jmp		ask
	
		
	exitfnc:
		pop		ebp
		ret		4
plc3ship		ENDP
plc2ship		PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	mov		eax, esi
	mov		edx, OFFSET plc2str
	call	WriteString
	jmp		ask

	invshp:
		mov		esi, eax
		mov		ebx, 2
		mov		edx, 0
		mov		ecx, 25
		clrbrd:
			cmp		[esi], ebx
			JNE		finishloop
			mov		[esi], edx
			finishloop:
				add		esi, 4
				loop	clrbrd
		mov		esi, eax	
		mov		edx, OFFSET shpstr
		call	WriteString

	ask:
		mov		edx, OFFSET rotstr
		call	WriteString
		call	ReadInt
		cmp		eax, 1
		JE		vertical
		cmp		eax, 2
		JE		horizontal
		JNE		invalid

	vertical:
		mov		edx, OFFSET plcvstr
		call	WriteString 
		askvh:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			cmp		eax, 5
			JG		invalidvh
			cmp		eax, 0
			JL		invalidvh
			JG		askvv
			invalidvh:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		vertical

		askvv:
			mov		ebx, eax
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 4
			JG		invalidvv
			cmp		eax, 0
			JL		invalidvv
			JG		place2shipv
			invalidvv:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		vertical
		place2shipv: ;repetative
				;(v - 1 * 5) + h h = ebx v = eax
				mov		ecx, eax
				mov		eax, 5
		
				dec		ecx
				mul		ecx
				add		eax, ebx

				;puts ship on array at eax
				dec		eax
				mov		ecx, eax
				mov		eax, esi	;making sure spot in array is kept
				findSpotv:
					add		esi, 4
					loop	findSpotv
				mov		ecx, 2
				mov		edx, 2
				mov		ebx, 0
				
				dropshipv:
					cmp		[esi], ebx
					JNE		invshp
					mov		[esi], edx
					add		esi, 20
					loop	dropshipv
			jmp		exitfnc
		
	horizontal:
		mov		edx, OFFSET plchstr
		call	WriteString 
		askhh:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			cmp		eax, 4
			JG		invalidhh
			cmp		eax, 0
			JL		invalidhh
			JG		askhv
			invalidhh:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		horizontal
		askhv:
			mov		ebx, eax
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 5
			JG		invalidhv
			cmp		eax, 0
			JL		invalidhv
			JG		place2shiph
			invalidhv:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		horizontal
		place2shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			mov		eax, esi	;making sure spot in array is kept
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 2
			mov		edx, 2
			mov		ebx, 0
			dropshiph:
				cmp		[esi], ebx
				JNE		invshp
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
			jmp		exitfnc


	invalid:
		mov		edx, OFFSET invstr
		call	WriteString
		jmp		ask
	
		
	exitfnc:
		pop		ebp
		ret		4
plc2ship		ENDP
plc1ship		PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	mov		eax, esi
	mov		edx, OFFSET plc1str
	call	WriteString
	jmp		ask

	invshp:
		mov		esi, eax
		mov		edx, OFFSET shpstr
		call	WriteString

	ask:
		askhh:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			cmp		eax, 5
			JG		invalidhh
			cmp		eax, 0
			JL		invalidhh
			JG		askhv
			invalidhh:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		ask
		askhv:
			mov		ebx, eax
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 5
			JG		invalidhv
			cmp		eax, 0
			JL		invalidhv
			JG		place1shiph
			invalidhv:
				mov		edx, OFFSET invstr
				call	WriteString
				jmp		ask
		place1shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			mov		eax, esi	;making sure spot in array is kept
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 1
			mov		edx, 1
			mov		ebx, 0
			dropshiph:
				cmp		[esi], ebx
				JNE		invshp
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
			jmp		exitfnc
	
	exitfnc:
		pop		ebp
		ret		4
plc1ship		ENDP
cplc3ship		Proc
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	ask:
		;Gen number
		mov		eax, 2
		sub		eax, 1
		inc		eax
		call	RandomRange
		add		eax, 1

		cmp		eax, 1
		JE		vertical
		cmp		eax, 2
		JE		horizontal

	vertical:
		askvh:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			mov		ebx, eax
		askvv:
			mov		eax, 3
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
		place3shipv: ;repetative
				;(v - 1 * 5) + h h = ebx v = eax
				mov		ecx, eax
				mov		eax, 5
		
				dec		ecx
				mul		ecx
				add		eax, ebx

				;puts ship on array at eax
				dec		eax
				mov		ecx, eax
				findSpotv:
					add		esi, 4
					loop	findSpotv
				mov		ecx, 3
				mov		edx, 3
				dropshipv:
					mov		[esi], edx
					add		esi, 20
					loop	dropshipv
			jmp		exitfnc
		
	horizontal:
		askhh:
			mov		eax, 3
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			mov		ebx, eax
		askhv:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
		place3shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 3
			mov		edx, 3
			dropshiph:
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
		
	exitfnc:
		pop		ebp
		ret		4
cplc3ship		ENDP
cplc2ship		Proc
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	mov		eax, esi
	jmp		ask

	invshp:
		mov		esi, eax
		mov		ebx, 2
		mov		edx, 0
		mov		ecx, 25
		clrbrd:
			cmp		[esi], ebx
			JNE		finishloop
			mov		[esi], edx
			finishloop:
				add		esi, 4
				loop	clrbrd
		mov		esi, eax	

	ask:
		mov		eax, 2
		sub		eax, 1
		inc		eax
		call	RandomRange
		add		eax, 1
		cmp		eax, 1
		JE		vertical
		cmp		eax, 2
		JE		horizontal

	vertical:
		askvh:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			mov		ebx, eax
		askvv:
			mov		eax, 4
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
		place2shipv: ;repetative
				;(v - 1 * 5) + h h = ebx v = eax
				mov		ecx, eax
				mov		eax, 5
		
				dec		ecx
				mul		ecx
				add		eax, ebx

				;puts ship on array at eax
				dec		eax
				mov		ecx, eax
				mov		eax, esi	;making sure spot in array is kept
				findSpotv:
					add		esi, 4
					loop	findSpotv
				mov		ecx, 2
				mov		edx, 2
				mov		ebx, 0
				
				dropshipv:
					cmp		[esi], ebx
					JNE		invshp
					mov		[esi], edx
					add		esi, 20
					loop	dropshipv
			jmp		exitfnc
		
	horizontal:
		askhh:
			mov		eax, 4
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			mov		ebx, eax
		askhv:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
		place2shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			mov		eax, esi	;making sure spot in array is kept
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 2
			mov		edx, 2
			mov		ebx, 0
			dropshiph:
				cmp		[esi], ebx
				JNE		invshp
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
			jmp		exitfnc


	invalid:
		mov		edx, OFFSET invstr
		call	WriteString
		jmp		ask
	
		
	exitfnc:
		pop		ebp
		ret		4
cplc2ship		ENDP
cplc1ship		Proc
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp + 8]

	mov		eax, esi
	jmp		ask

	invshp:
		mov		esi, eax
	ask:
		askhh:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			mov		ebx, eax
		askhv:
			mov		eax, 5
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
		place1shiph: 
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			mov		eax, esi	;making sure spot in array is kept
			findSpoth:
				add		esi, 4
				loop	findSpoth
			mov		ecx, 1
			mov		edx, 1
			mov		ebx, 0
			dropshiph:
				cmp		[esi], ebx
				JNE		invshp
				mov		[esi], edx
				add		esi, 4
				loop	dropshiph
			jmp		exitfnc
	
	exitfnc:
		pop		ebp
		ret		4
cplc1ship		ENDP
plyrtrn		PROC
	push	ebp
	mov		ebp, esp	
	mov		esi, [ebp + 8]
	mov		eax, esi

	ask:
		mov		edx, OFFSET askstr
		call	WriteString
		call	Crlf
		jmp		horizontal
		pegthere:
			mov		esi, eax

			mov		edx, OFFSET pegstr
			call	WriteString

			jmp		horizontal
		invalid:
			mov		edx, OFFSET invstr
			call	WriteString
		horizontal:
			mov		edx, OFFSET hrzstr
			call	WriteString
			call	ReadInt
			cmp		eax, 1
			JL		invalid
			cmp		eax, 5
			JG		invalid
			mov		ebx, eax
		vertical:	
			mov		edx, OFFSET vrtstr
			call	WriteString
			call	ReadInt
			cmp		eax, 1
			JL		invalid
			cmp		eax, 5
			JG		invalid
		plcpeg:
			;(v - 1 * 5) + h h = ebx v = eax
			mov		ecx, eax
			mov		eax, 5
	
			dec		ecx
			mul		ecx
			add		eax, ebx
			
			;puts ship on array at eax
			dec		eax
			mov		ecx, eax
			mov		eax, esi
			findSpot:
				add		esi, 4
				loop	findSpot
			mov		ebx, 3

			;check if peg is there
			cmp		[esi], ebx
			JG		pegthere

			mov		ecx, 0
			mov		eax, 4 ;miss
			mov		edx, 5 ;hit
			cmp		[esi], ebx
			JG		pegthere
			cmp		[esi], ecx
			JG		hit
			miss:
				mov		[esi], eax
				mov		edx, OFFSET mssstr
				call	Crlf
				call	WriteString
				call	WaitMsg
				jmp		exitfnc
			hit:
				mov		[esi], edx
				mov		edx, OFFSET hitstr
				call	Crlf
				call	WriteString
				call	WaitMsg
	exitfnc:
		pop		ebp
		ret		8
plyrtrn		ENDP
comptrn		PROC
	push	ebp
	mov		ebp, esp	
	mov		esi, [ebp + 8]
	mov		eax, esi

	ask:
		jmp		placepeg
		pegthere:
			mov		esi, eax
			
		placepeg:
			mov		eax, 25
			sub		eax, 1
			inc		eax
			call	RandomRange
			add		eax, 1
			
			mov		ecx, eax
			mov		eax, esi
			findSpot:
				add		esi, 4
				loop	findSpot
			mov		ebx, 3

			;check if peg is there
			cmp		[esi], ebx
			JG		pegthere

			mov		ecx, 0
			mov		eax, 4 ;miss
			mov		edx, 5 ;hit
			cmp		[esi], ebx
			JG		pegthere
			cmp		[esi], ecx
			JG		hit
			miss:
				mov		[esi], eax
				mov		edx, OFFSET cmssstr
				call	Crlf
				call	WriteString
				call	WaitMsg
				jmp		exitfnc
			hit:
				mov		[esi], edx
				mov		edx, OFFSET chitstr
				call	Crlf
				call	WriteString
				call	WaitMsg
	exitfnc:
		pop		ebp
		ret		8
comptrn		ENDP
chckbrd		PROC
	push	ebp
	mov		ebp, esp	
	mov		esi, [ebp + 8] ;player board
	mov		edi, [ebp + 12]	;comp board
	
	mov		eax, esi
	
	mov		ecx, 25
	mov		ebx, 5
	mov		edx, 0
	checkw:
		cmp		[esi], ebx
		JE		addhitw
		jmp		loopwin
		addhitw:
			inc		edx
			cmp		edx, 6		; if 5 hits
			JE		playerwin
		loopwin:
			add		esi, 4
			loop	checkw


	mov		ecx, 25
	mov		ebx, 5
	mov		edx, 0
	checkl:
		cmp		[edi], ebx 
		JE		addhitl
		jmp		loopl
		addhitl:
			inc		edx
			cmp		edx, 6		; if 5 hits
			JE		playerwin
		loopl:
			add		edi, 4
			loop	checkl
	mov		esi, eax


	jmp		exitfnc

	playerwin:
		mov		edx, OFFSET winstr
		call	WriteString
		jmp		playagain
	playerlose:
		mov		edx, OFFSET losestr
		call	WriteString
		jmp		playagain
	playagain:
		mov		edx, OFFSET agnstr
		call	WriteString
		call	ReadInt
		cmp		eax, 1
		JE		newgame
		cmp		eax, 2
		JNE		invalid
	destroygame:
		invoke	ExitProcess,0 
	newgame:
		call	Main
	invalid:
		mov		edx, OFFSET invstr
		call	WriteString
		jmp		playagain

	exitfnc:
		pop		ebp
		ret 8
chckbrd		ENDP
END main
