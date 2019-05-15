.include "crypto.s"
.include "console.s"
.data

.extern menu
.extern menulen
.extern Error
.extern erlen
.extern clear

.text
.globl _start
.extern  crypto
.extern  conin
.extern  conout
.extern  filein
.extern  fileout


_start:
men:
movq  $1,   %rax
movq  $1,   %rdi
movq  $menu, %rsi
movq  menulen, %rdx
syscall

ent:
xor %ax, %ax
movq  $0,   %rax
movq  $1,   %rdi
movq  $choice, %rsi
movq  $1, %rdx
syscall
call clear
cld
movq $choice, %rsi
lodsb

cmpb $'0', %al
je exit

cmpb $'1', %al
jne m1
call conin
jmp men

m1:
cmpb $'2', %al
jne m2
//call filein
jmp men

m2:
cmpb $'3', %al
jne m3
call conout
jmp men

m3:
cmpb $'4', %al
jne m4
//call fileout
jmp men

m4:
cmpb $'5', %al
jne m5
call crypto
jmp men

m5:
movq  $1,   %rax
movq  $1,   %rdi
movq  $Error, %rsi
movq  erlen, %rdx
syscall
jmp ent


exit:
MOV		$60,	%rax
SYSCALL
