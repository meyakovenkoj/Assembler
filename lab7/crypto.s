.include "data.s"
.data
.extern key
.extern keylen
.extern string
.text
.globl crypto
crypto:
lea string, %rsi
lea string, %rdi
xor %rbx, %rbx
pr:
cld
xor %rax,%rax
lodsb
c:
	  cmp $' ', %al
	  jne j1
	  jmp pr
j1:
    cmp $',', %al
	  jne j2
	  jmp pr
j2:
    cmp $';', %al
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
    movq $key, %rdx
		lea (%rdx,%rbx,), %rcx
    xor %cl, %al
    inc %rbx
    cmp $keylen, %rbx
    jne t
    xor %rbx, %rbx
    t:
    stosb
jmp pr
endstr:
ret
