				; f = ((a+b)^3)/(3*a) + a*(3*c-d^3)/(2*e^2)

.model small
.stack 100h
.data  
 a db -78
 b db 25 
 c db 11
 d db -1
 e db 36
 
 t dd ? 		;numerator 1
 g dd ? 		;denominator 1
 
 w dd ? 		;denominator 2
 q dd ? 		;numerator 2 
 
 f dd ? 		;result 
 
.code
.486

mov ax, @data
mov ds, ax		;stack

xor eax, eax
mov al, a		;write a to al
cbw				; fill ah the sign-byte of a number, that is in al, ariphmetical operations with operand - byte like opeartions with word in ax
cwde			;fill the first part of eax with sign - byte of ax, 16 bit number  - in 32 bit number

xor ebx, ebx
xchg eax, ebx ;ebx = a


xor eax, eax
mov al, b		;write b to al
cbw				; ah - sign of al
cwde			; in eax sign

add eax, ebx
mov ebx, eax		;in ebx saved (a+b)

imul eax 		;(a+b)^2
imul ebx		;eax contains (a+b)^3
mov ecx, eax	;save (a+b)^3 in ecx

xor eax, eax
mov al, a
cbw				; fill ah the sign-byte of a number, that is in al, ariphmetical operations with operand - byte like opeartions with word in ax
cwde			;fill the first part of eax with sign - byte of ax, 16 bit number  - in 32 bit number
xor ebx, ebx
mov ebx, eax 	    ; ebx = a
add eax, eax
add eax, ebx 	; eax contains 3a

mov ebx, ecx	; ebx = (a+b)^3
xchg eax, ebx   ;eax = (a+b)^3, ebx = 3a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cdq				; expand sign of dw that was in eax to edx. needs for correct division
idiv ebx		;eax = contains (a+b)^3/3a, edx contains remainder, ebx contains denominator
mov f, eax		; f = semi result

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov t, edx		;save numerator 1 from edx
mov g, ebx		;save denominator 1 from ebx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


xor eax, eax
xor ebx, ebx
mov al, d
cbw				; fill ah the sign-byte of a number, that is in al, ariphmetical operations with operand - byte like opeartions with word in ax
cwde			;fill the first part of eax with sign - byte of ax, 16 bit number  - in 32 bit number
xor ebx, ebx
mov ebx, eax
imul eax
imul ebx		;eax = d^3
mov ebx, eax	;ebx = d^3


xor eax, eax
xor edx, edx
xor ecx, ecx
mov al, c
cbw				; ah - sign of al
cwde			; in eax sign
mov ecx, eax	;ecx = c with sign
xor eax,eax
mov eax, 3
imul ecx			;eax = 3c

sub eax, ebx	;eax = (3c - d^3)
mov g, eax		;g = (3c - d^3)
xor eax, eax
mov al, a
cbw
cwde

mov ebx, g
imul ebx		;eax = a*(3c - d^3) - numerator 2
mov ebx, eax	; ebx = numerator 2

xor eax, eax
mov al, e 
cbw
cwde
imul eax
add eax, eax	;eax = 2e^2 = denominator 2

mov w, eax		; save denominator 2

xchg eax, ebx	;eax = a(3c-d^3), ebx = (2e^2)

cdq				; expand sign of dw that was in eax to edx. needs for correct division
idiv ebx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mov q, edx		; saved numerator 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

add f, eax		;saved result

mov ax, 4c00h
int 21h
end