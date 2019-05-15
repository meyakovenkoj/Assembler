.data
.extern outfile
.extern infile
.extern Error
.extern string
.extern handle
.extern act

.text
.global filein
.global fileout

;================ ввод из файла
filein:
MOV	$open_64,	%rax	# open function
MOV	$infile,	%rdi	# RDI points to file name
MOV	$0,		%rsi	# flags of opened file in RSI
MOV	$mode,		%rdx	# mode of opened file in RDX
SYSCALL

CMP	$0,			%rax
JL	error				# if RAX<0 then something went wrong

MOV	%rax,		file_h	# store file handle returned in RAX

MOV	$read_64,	%rax	# read function
MOV	file_h,		%rdi	# file handle in RDI
MOV	$buffer,	%rsi	# RSI points to data buffer
MOV	bufsize,	%rdx	# bytes to be read
SYSCALL

CMP	$0,			%rax
JL	error				# if RAX<0 then something went wrong

MOV	%rax,		b_read	# store count of read bytes

MOV	$close_64,	%rax	# close function
MOV	file_h,		%rdi	# file handle in RDI
SYSCALL

CMP	$0,			%rax
JL	error				# if RAX<0 then something went wrong

MOV	b_read,		%rax
CMP	bufsize,	%rax	# whole file was read ?
JAE	toobig				# probably not

MOV	$write_64,	%rax	# write function
MOV	$stdout,	%rdi	# file handle in RDI
MOV	$cntmsg,	%rsi	# RSI points to message
MOV	cntlen,		%rdx	# bytes to be written
SYSCALL

MOV	$write_64,	%rax	# write function
MOV	$stdout,	%rdi	# file handle in RDI
MOV	$buffer,	%rsi	# offset to first character
MOV	b_read,		%rdx	# count of characters
SYSCALL
ret   ;возврат в меню

;==================== вывод в файл
fileout:
mov ah,3Ch              ;Открываем или создаем файл
xor al,al               ;Режим открытия - только чтение
lea dx,outfile          ;Имя файла
xor cx,cx               ;Нет атрибутов - обычный файл
int 21h
jnc f4                  ;если открыли без ошибок идем к f4 иначе сообщение об ошибке
lea dx,Error
mov ah,09h
int 21h
jmp exit2                ;завершаем все
f4:
mov handle,ax
mov bx,ax
mov ah,40h               ;пишем строчку
lea dx,string
xor cx,cx
mov cl, act
int 21h
mov ah, 3eh
mov bx,handle
int 21h
mov act,0                 ; очищаем счетчик символов
mov string,'$'            ;зануляем строчку(достаточно в первый символ записать $)
exit2:
ret   ;возврат в меню
