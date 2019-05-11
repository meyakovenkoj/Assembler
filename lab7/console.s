.data
.extern max
.extern act
.extern string
.text
.globl conin
.globl conout
conin:
sub     $8, %esp
call    gets
add     $8, %esp
ret

conout:
sub     $8, %esp
lea     string, %eax
mov     %eax, (%esp)
call    printf
add     $8, %esp
ret
