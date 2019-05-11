.include "data.s"
.section __DATA,__data
.extern key
.extern keylen
.extern string
.section __TEXT,__text
.globl _crypto
_crypto:
lea string, %si
lea string, %di
xor %bx, %bx
pr:
cld
xor %ax,%ax
lodsb
c:
	  cmp $32, %al
	  jne j1
	  jmp pr
j1:
    cmp $44, %al
	  jne j2
	  jmp pr
j2:
    cmp $59, %al
  	jne j3
  	jmp pr
j3:
    cmp $13, %al
  	jne j4
  	jmp pr
j4:
    cmp $10, %al
  	jne j5
  	jmp pr
j5:
    cmp $0, %al
  	jne j6
  	jmp endstr
j6:
    movb %al, %cl
    push %si
    lea key , %si
    add %bx, %si
    lodsb
    xor %al, %cl
    pop %si
    inc %bx
    cmp $keylen, %bx
    jne t
    xor %bx, %bx
    t:
    stosb
jmp pr
endstr:
ret
