.globl max, act, string, menu, Error, outfile
.globl infile, choice, handle, key, keylen

.data
max:             .byte 255
act:             .byte 0
string:          .space 1024
strlen:          .quad (. - string)
menu:            .asciz "Menu:\n1. Console input\n2. File input\n3. Console output\n4. File output\n5. Encrypt / Decrypt\n0. Exit\n"
menulen:         .quad 	(. - menu)
Error:					 .asciz "Error! Try again"
erlen:           .quad 	(. - Error)
outfile:         .asciz "outpu_fl.txt"
infile:          .asciz "input_fl.txt"
choice:          .quad 0
handle:          .word 0
key:             .ascii "4664"
keylen:     		 .quad 4
trash:           .space 1
