.model small
stack 100h
.data
	mas db 8, 5, 23, 120
		db 3, 6, 10, 15
	tmp db 0

	crlf db 13, 10, '$'
	msgPress db 13, 10, 'press any key...$'
	before db 13, 10, 'before$'
	after db 13, 10, 'after$'

.486
.code


;;;;;;;;;;;;;;;;;macro for print 'str \n'
write macro str
	push ax
	push dx

	lea dx, str
	mov ah, 09h
	int 21h

	pop dx
	pop ax
endm


;;;;;;;;;;;;;;;;;macro for print 'digit'
outdg macro
	local loop1, loop2, ext

	push ax
	push cx
	push -1

	mov cx, 10

	loop1:
		xor dx, dx
		mov ah, 0
		div cl
		mov dl, ah
		push dx
	
		cmp al, 0
	jne loop1
		mov ah, 2h
	
	loop2:
		pop dx
		cmp dx, -1
		
		je ext
	
		add dl, '0'
		int 21h
	jmp loop2
	
	ext:
	mov dl, 9
	int 21h
	pop cx
	pop ax

endm


;;;;;;;;;;;;;;;;;proc for print 'mas'
print proc
	out10:
		push cx
		mov cx, 4
		xor si, si
		write crlf
	out20:
		xor ax, ax
		mov ax, [bx][si]
		outdg
		inc si
	loop out20
	
		add bx, 4
		pop cx
	loop out10
	ret
print endp


;;;;;;;;;;;;;;;;; for 
start:
	mov ax, @data
	mov ds, ax

	lea bx, mas
	mov cx, 2

	write before

	call print

	xor cx, cx
	xor bx, bx
	xor dx, dx
	mov cx, 2

	cycl_1:
		push cx
		xor si, si
		mov cx, 2
	
		cycl_2:
			mov dl, mas[bx+si]
			mov tmp, dl
	
			mov di, 3
			sub di, si
			mov dl, mas[bx+di]
			mov mas[bx+si], dl
			mov dl, tmp
			mov mas[bx+di], dl
			inc si
		loop cycl_2
	
		pop cx
		add bx, 4
	loop cycl_1 

	lea bx, mas
	mov cx, 2

	write after

	call print

	write msgPress
	mov ah, 0
	int 16h

	mov ax,4C00h
	int 21h
end start