				; how often does the '000' combination meet in the remainder of division one world to another

.model small
.stack 100h
.data

a dw 129
b dw 130
counter db 0
msk dw 0

.code
.486

mov ax, @data
mov ds, ax 		;stack

mov ax, a
cwd
mov bx, b


idiv bx		;ax = contains a/b, dx contains remainder, bx contains denominator

xor cx, cx
mov cx, 14  ;cycle will check 13 combinations of 3 bytes
mov msk, 7	;define register mask

countCombinations:
	test dx, 1111111111111111b
	jz exit
	test dx, msk
	jz incCounter
	jnz continue
	incCounter:
		add counter,1
	continue:
	shr dx, 1
	loop countCombinations

exit:
mov ax, 4c00h
int 21h
end
