.data
.extern max
.extern act
.extern string
.extern strlen
.text
.globl conin
.globl conout
.global clear
conin:
movq  $0,   %rax
movq  $1,   %rdi
movq  $string, %rsi
movq  strlen, %rdx
syscall
ret

conout:
movq  $1,   %rax
movq  $1,   %rdi
movq  $string, %rsi
movq  strlen, %rdx
syscall
ret

clear:
movq  $0,   %rax
movq  $1,   %rdi
movq  $trash, %rsi
movq  $1, %rdx
syscall
ret
