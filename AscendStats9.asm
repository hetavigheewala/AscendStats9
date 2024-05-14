;  Description: This program will sort an array of numbers in ascending order using the Comb1 sort 
;               algorithm given by the professor. The program will sort the array, find the minimum,
;               maximum, median, sum and average of the list and then the result will print in the base9 format. 

; =====================================================================
;  Macro to convert integer to nonary value in ASCII format.
;  Reads <integer>, converts to ASCII/nonary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer-variable>, value
;	%2 -> <string-address>, string address
;	%3 -> <string-length-value>, string length

;  Macro usgae
;	int2aNonary	<integer-variable>, <string-address>, <string-length>

;  Example usage:
;	int2aNonary	dword [volumes+rsi*4], tempString, STR_LENGTH


;	YOUR CODE GOES HERE
;	Note:  UPDATE ALGORITHM TO ADD "-" for values <0
%macro int2aNonary 3
    mov eax, dword %1
    mov ebx, 0
    movzx rdx, ax

    ; Check if the number is negative
    cmp eax, 0
    jl %%negative_value

    jmp %%not_negative

%%negative_value:
    neg eax

%%not_negative:
    mov     rcx, 0
    mov     ebx, 9

    ; Division loop
%%divide_Loop:
    mov     edx, 0
    div     ebx
    push    rdx
    inc     rcx
    cmp     eax, 0
    jne     %%divide_Loop

    ; Convert remainders to ASCII and store in cubeAveString
    mov     rbx, %2
    mov     rdi, 0

    mov     r10, %3
    sub     r10, 1
    mov     r11, r10

%%noNegativeSign:
    sub r10, rcx
    add al, " "

mov r15, 0
mov r15, r10
dec r15

; Loop to add spaces
%%space_Loop:
    mov     byte [rbx + rdi], al
    inc     rdi

	cmp     dword %1, 0
	jl %%negative_space
	cmp     dword %1, 0
	jge %%positive_spaces
; if positive then add spaces 
%%positive_spaces:
    cmp     rdi, r10
    jne     %%space_Loop
	je %%pop_Loop

; if negative than subtract one space (for '-' sign)
%%negative_space:
    cmp     rdi, r15
    jne     %%space_Loop


    cmp     dword %1, 0
    jge %%pop_Loop
	sub 	byte [rbx + rdi], ' '
    mov     byte [rbx + rdi], '-'
    inc     rdi

%%pop_Loop:
    pop     rax
    add     al, '0'
    mov     byte [rbx + rdi], al
    inc     rdi
    cmp     rdi, r11
    jne     %%pop_Loop

    mov     byte [rbx + rdi], NULL

%endmacro


; =====================================================================
;  Simple macro to display a string to the console.
;	Call:	printString  <stringAddr>

;	Arguments:
;		%1 -> <stringAddr>, string address

;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	mov	rdx, 0
	mov	rdi, %1
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	mov	rsi, %1			; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================

section	.data

; -----
;  Define constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; Successful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
NULL		equ	0
ESC		equ	27

;  Program specfic constants

MAX_STR_LENGTH	equ	15

; -----
;  Provided data

array		dd	  147,  1123,  2245,  4440,   165
		dd	  -69,  -126,   571,   147,  -228
		dd	   27,    90,   177,   -75,    14
		dd	  181,   -25,    15,   -22,  1217
		dd	 -127,    64,   140,   172,    24
		dd	 2161,  -134,   151,   -32,   -12
		dd	 1113,  1232,  2146,  3376,  5120
		dd	 2356,  3164, 34565,  -3155, 23157
		dd	 1001,   128,   -33,   105,  8327
		dd	 -101,   115,   108,  1233,  2115
		dd	 1227,  1226,  5129,   117,  -107
		dd	  105,  -109,   730,   150,  3414
		dd	 1107,  6103, -1245,  6440,   465
		dd	-2311,   254,  4528,   913, -6722
		dd	 1149,  2126,  5671, -4647,  4628
		dd	 -327,  2390,   177,  8275,  5614
		dd	 3121,   415,   615,    22,  7217
		dd	 1221,    34, -6151,  -432,  -114
		dd	 -629,   114,   522,  2413,  -131
		dd	 5639,  -126,   -62,   -41,   127
		dd	 2101,   133,   133,    50,  4532
		dd	 1219,  3116,   -62,   -17,   127
		dd	 6787,  4569,    79,  5675,   -14
		dd	 7881,  8320,  3467,  4559,  1190
		dd	 -186,   134, -1125,  5675,  3476
		dd	 2137,  2113,  1647,   114,    15
		dd	 6571,  7624,   128,  -113, -3112
		dd	 1121,   320,  4540,  5679,  1190
		dd	 9125,  -116,  -192,   117,  -127
		dd	 5677,   101,  3727,  -125,  3184
		dd	-1104,   124,  -112,   143,   176
		dd	 7534, -2126,  6112,  -156,  1103
		dd	 6759,  6326,  2171,   147,  5628
		dd	 7527,  7569, -3177,  6785, -3514
		dd	-1156,  -164,  4165,  -155,  5156
		dd	 5634,  7526,  3413,  7686,  7563
		dd	 2147,  -113,  -143,   140,  -165
		dd	 5721,  5615,  4568,  7813,  1231
		dd	-5527,  6364,  -330,  -172,   -24
		dd	 7525,  5616,  5662,  6328,  2342

length		dd	200

minimum		dd	0
median		dd	0
maximum		dd	0
sum		dd	0
average		dd	0

; -----
;  Misc. data definitions (if any).





; -----
;  Provided string definitions.

newLine		db	LF, NULL

hdr		db	LF, "---------------------------"
		db	"---------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #7", ESC, "[0m"
		db	LF, "Comb Sort", LF, LF, NULL

hdrMin		db	"Minimum:  ", NULL
hdrMax		db	"Maximum:  ", NULL
hdrMed		db	"Median:   ", NULL
hdrSum		db	"Sum:      ", NULL
hdrAve		db	"Average:  ", NULL

; ---------------------------------------------

section .bss

tempString	resb	MAX_STR_LENGTH

; ---------------------------------------------

section	.text
global	_start
_start:


; ******************************
; void function combSort(array, length)
;    gap = length
;    swapped = true
;
;    outer loop while gap>1 OR swapped = true
;        // update gap for next comb sweep
;        gap = (gap * 10) / 12
;        if gap < 1
;            gap = 1
;        end if
;
;        i = 0
;        swapped = false
;
;        inner loop until i + gap >= length	// single comb sweep
;            if  array[i] > array[i+gap]
;                swap(array[i], array[i+gap])
;                swapped = true
;            end if
;            i = i + 1
;        end inner loop
;     end outer loop
; end function


; Initialize variables
mov esi, array      ; array
mov ecx, dword[length]  ; length
mov eax, ecx        ; gap = length
mov ebx, 1          ; swapped = true
 ; Calculate new gap
outer_loop:
    imul eax, 10        ; gap * 10
    mov edx, 0
    mov r15d, 12         ; Adjusted division factor
    idiv r15d            ; gap * 10 / 12
    cmp eax, 1          ; if gap < 1
    jge gap_ok
    mov eax, 1          ; gap = 1
gap_ok:

; Reset loop counters
xor edi, edi        ; i = 0
mov ebx, 0          ; swapped = false

inner_loop:
    ; Check loop termination condition
    mov edx, dword[esi + edi * 4]   ; array[i]
    cmp edi, ecx
    jge loop_end

    ; Compare array[i] with array[i+gap]
    mov r8d, edi               ; Store i in r8
    add r8d, eax               ; i + gap
    cmp r8d, ecx               ; Check if i + gap >= length
    jge not_swapped

    ; Load array[i+gap] into r9d
    mov r9d, dword[esi + r8d * 4]   ; array[i+gap]
    cmp edx, r9d                 ; Compare array[i] with array[i+gap]
    jle not_swapped

    ; Swap array[i] and array[i+gap]
    mov dword[esi + edi * 4], r9d   ; array[i] = array[i+gap]
    mov dword[esi + r8d * 4], edx   ;  array[i+gap] = array[i]
    mov ebx, 1              ; swapped = true

not_swapped:
; Inc loop counter
inc edi             ; i = i + 1
jmp inner_loop

loop_end:
; Check loop conditions for outter loop
cmp eax, 1          ; gap > 1
jg outer_loop
cmp ebx, 1       ; swapped = true
je outer_loop

; ******************************
; -------------------- MIN AND MAX  -------------------- ;
mov eax, 0
mov eax, dword[array]
mov dword[minimum], eax

mov eax, 0
mov ecx, 0
mov edi, 0
mov ecx, dword[length]
sub ecx, 1
mov eax, dword[array+ecx*4]
mov dword[maximum], eax


; -------------------- LIST SUM AND AVERAGE  -------------------- ;
; Initialize variables
mov ecx, dword [length]      
mov esi, array
mov eax, dword [esi]         
mov dword [sum], eax     


calcSumLoop:
add esi, 4
cmp ecx, 1
je endCalcSumLoop
mov eax, dword [esi]         
add dword [sum], eax    
loop calcSumLoop
endCalcSumLoop:

; -------------------- CALCULATE AVERAGE -------------------- ;
; Calculate Average
; Load the Sum
; Sign extend EAX into EDX:EAX
; Divide the sum by the length of the list
; Store the average in average
mov eax, dword [sum]   
cdq         
idiv dword [length]          
mov dword [average], eax   

; -------------------- CALCULATE MEDIAN -------------------- ;
mov eax, dword[length]
mov r9d, 2
mov edx, 0
div 		r9d
mov rdi, 0
mov edi, eax

mov eax, dword[length]
mov r9d, 2
mov edx, 0
div r9d
dec eax
mov rbp, 0
mov ebp, eax

mov eax, dword[array + rdi*4]
add eax, dword[array + rbp*4]
mov r9d, 2
div r9d

mov dword[median], eax
; ******************************
;  Display results to screen in duodecimal.

	printString	hdr

	printString	hdrMin
	int2aNonary	dword [minimum], tempString, MAX_STR_LENGTH
	printString	tempString
	printString	newLine

	printString	hdrMax
	int2aNonary	dword [maximum], tempString, MAX_STR_LENGTH
	printString	tempString
	printString	newLine

	printString	hdrMed
	int2aNonary	dword [median], tempString, MAX_STR_LENGTH
	printString	tempString
	printString	newLine

	printString	hdrSum
	int2aNonary	dword [sum], tempString, MAX_STR_LENGTH
	printString	tempString
	printString	newLine

	printString	hdrAve
	int2aNonary	dword [average], tempString, MAX_STR_LENGTH
	printString	tempString
	printString	newLine
	printString	newLine


; ******************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
