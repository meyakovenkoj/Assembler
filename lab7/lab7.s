.include "crypto.s"
.data

.extern menu
.extern Error

.text
.globl main
.extern  crypto
.extern  conin
.extern  conout
.extern  filein
.extern  fileout



main:
men:
sub     $8, %esp
lea     menu, %eax
mov     %eax, (%esp)
call    _printf
add     $8, %esp

ent:
xor %ax, %ax
sub     $8, %esp
call    _getchar
add     $8, %esp
cmp $48, %al
je exit
cmp $49, %al
jne m1
call _conin
jmp men
m1: cmp $50, %al
jne m2
call _filein
jmp men
m2: cmp $51, %al
jne m3
call _conout
jmp men
m3: cmp $52, %al
jne m4
call _fileout
jmp men
m4: cmp $53, %al
jne m5
call _crypto
jmp men
m5:
sub     $8, %esp
lea     Error, %eax
mov     %eax, (%esp)
call    _printf
add     $8, %esp
jmp ent


exit:
movl  $0, %eax
ret
