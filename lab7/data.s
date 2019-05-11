.globl max, act, string, menu, Error, outfile
.globl infile, choice, handle, key, keylen

.section __DATA,__data
max:             .byte 255
act:             .byte 0
string:          .space 1024
menu:            .asciz "Menu:\n1. Console input\n2. File input\n3. Console output\n4. File output\n5. Encrypt / Decrypt\n0. Exit"
Error:			.asciz "Error! Try again"
outfile:         .asciz "outpu_fl.txt"
infile:          .asciz "input_fl.txt"
choice:          .byte 0
handle:          .word 0
key:             .byte "4664"
keylen:     		 .byte 4
