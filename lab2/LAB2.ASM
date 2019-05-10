.model small
.stack 100h
.data
a dw 1
b dw -124
res db ?
count db 0
.code
.486

mov ax, @data
mov ds, ax

mov ax, a
mov bx, b
xor dx, dx

idiv bx

; there is the rest in dx
xor ax, ax


m1: add count, 1
	shr dx,1
	jc m1
		add count, 1
		shr dx,1
		jc m1
			add count, 1
			shr dx,1
			jc m1
			cmp count, 8
			jg cont
			add al, 1
			cmp count, 4
			jle m1

cont:
mov res, al

mov ax,4c00h
int 21h
end
