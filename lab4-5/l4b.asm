.model small
.stack 100h
.data

max db 255 ;bite with max length
act  db ? ;length of string (that was read)
string db 1024 dup ('$') ;string that will be coded
menu            db "Menu:",0,0dh,0ah
                db "1. Console input",0,0dh,0ah ; 0dh - end string, 0ah - change
			          db "2. File input",0,0dh,0ah
			          db "3. Console output",0,0dh,0ah
                db "4. File output",0,0dh,0ah
                db "5. Encrypt / Decrypt",0,0dh,0ah
                db "0. Exit",0,0dh,0ah,'$'
Error db "Error :(", 0,0dh,0ah, '$'
outfile         db "outpu_fl.txt",0
infile          db "input_fl.txt",0
endline db 0dh, 0ah, '$'
choice db 0
handle dw ?
key db '4664'
keylen dw 4

.code
.486

;===================cypher=================;
crypto macro strt
local pr, c, j1, j2, j3, j4, j5, j6, t, enstr
xor bx, bx
lea si, strt
;lea di, strt
pr:
cld ;clean flag of direction
xor ax, ax
lodsb ;load into al symbol with adress si, inc si
c:
	cmp al, 32 ;compare symbol and ' '
	jne j1 ;continue compare
	jmp pr ;skip
j1:
	cmp al, 44 ; cmp with ','
	jne j2
	jmp pr
j2:
	cmp al, 59 ; cmp with ';'
	jne j3
	jmp pr
j3:
	cmp al, 13 ;cmp with '\r'
	jne j4
	jmp pr
j4:
	cmp al, 10 ;cmp with '\n'
	jne j5
	jmp pr
j5:
	cmp al, '$'
	jne j6 ;process if not equal
	jmp endstr
j6:
	xor al, key[bx] ;sum mod 2 with key
	inc bx
	cmp bx, keylen ; check length
	jne t ; if not equal continue
		xor bx, bx ;else
t:
	mov di, si ;take address of the next symbol
	dec di
	mov [di], al ;write coded symbol
	;stosb
jmp pr
endstr:
endm

start:
mov ax, @data
mov ds, ax

;==================menu======================;
men:
lea dx, menu
mov ah, 09h ;out menu
int 21h
ent:
mov ah, ah
mov ah, 01h ;read symbol
lea dx, choice
int 21h
lea dx, endline
mov ah, 09h ;cout<<endl;
int 21h
cmp al, '0'
je exit
cmp al, '1'
je conin ;read from console
cmp al, '2'
je filein ;read from file
cmp al, '3'
je  conout ;write at console
cmp al, '4'
je fileout ;write to file
cmp al, '5'
je begin ;start crypto
lea dx, Error ;uncorrect input
mov ah, 09h
int 21h
jmp ent ;repeat menu


;=================read string from console==================;
conin:
	xor dx, dx
	mov ah, 0ah ;read
	lea dx, max ;fix the max length of buf
	int 21h
	xor bx, bx
	mov bl, act ;save amount of symbols that we have read
	mov string[bx], 0dh ;end the string
	mov string[bx+1], 0ah
	mov string[bx+2], '$'
	lea dx, endline ;cout<<endl;
	mov ah, 09h
	int 21h
	lea di, string ;save offset of string
	lea si, string
	jmp men

;====================write to console======================;
conout:
	lea dx, string ;fix offset
	mov ah, 09h
	int 21h
	jmp men

;====================read from file========================;
filein:
	mov ah, 3Dh ;open file
	xor al, al ;only reading
	lea dx, infile
	xor cx, cx
	int 21h
	jnc f1 ;if no errors
	lea dx, Error
	mov ah, 09h
	int 21h
	jmp exit ;end all
f1:
	mov handle, ax
	mov bx, ax ;descyptor
	mov ah, 3Fh ;read from file
	lea dx, string
	mov cx, 1021 ;max amount of readable bytes

	int 21h
	jnc f2
	lea dx, Error
	mov ah, 09h
	int 21h
	jmp exit
f2:
	mov bx, ax
	mov string[bx], 0dh
	mov string[bx+1], 0ah
	mov string[bx+2], '$'
	mov ah, 3Eh ;close file
	mov bx, handle
	int 21h
	jnc f3 ;if no errors
	lea dx, Error
	mov ah, 09h
	int 21h
	jmp exit
f3:
	lea di, string
	lea si, string
	jmp men

;=======================write to file================;
fileout:
	mov ah, 3Ch ;create file
	xor al,al
	lea dx, outfile
	xor cx, cx ;no any atributes
	int 21h
	jnc f4
	lea dx, Error
	mov ah, 09h
	int 21h
	jmp exit
f4:
	mov handle, ax
	mov bx, ax
	mov ah, 40h ;write string
	lea dx, string
	xor cx, cx
	mov cl, act
	int 21h
	mov ah, 3eh ;close file
	mov bx, handle
	int 21h
	mov act, 0 ;clean counter of symbols
	mov string, '$' ;string  = null
	jmp men

;===========call macro of crypto========;
begin:
	crypto string
	jmp men

;======exit========;
exit:
	mov ah, 4ch
	int 21h

end start
