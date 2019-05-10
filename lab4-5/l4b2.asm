.model small
.stack 100h
.data

max             db 255    ;байт с возможной длиной
act             db ?    ;байт с прочитанной длиной строки
string          db 1024 dup('$')    ;строчка которую будем шифровать
menu            db "Menu:",0,0dh,0ah
                db "1. Console input",0,0dh,0ah
			          db "2. File input",0,0dh,0ah
			          db "3. Console output",0,0dh,0ah
                db "4. File output",0,0dh,0ah
                db "5. Encrypt / Decrypt",0,0dh,0ah
                db "0. Exit",0,0dh,0ah,'$'
Error           db "Error! Try again",0,0dh,0ah,'$'
outfile         db "outpu_fl.txt",0    ;файл вывода
infile          db "input_fl.txt",0    ;файл ввода
endline         db 0dh,0ah,'$'
choice          db 0    ;переменная выбора в меню
handle          dw ?    ;дескриптор файла
key             db '4664'     ;ключ шифрования
keylen          dw 4          ;длина ключа

.code
.486

;=================== макрос шифрования
crypto macro strt
local pr, c, j1, j2, j3, j4, j5, j6, t, endstr ;объявляем метки в макросе
xor bx, bx
lea si,strt     ;запоминаем смещение строки
pr:
cld             ;cброс флага направления
xor ax,ax
lodsb     ;загружаем в al символ по адресу si, увеличиваем si на 1
c:
	  cmp al,32       ;сравниваем с пробелом
	  jne j1          ;если не равен продолжаем сравнение
	  jmp pr          ;иначе пропускаем
j1:
    cmp al,44       ;сравниваем с запятой
	  jne j2          ;если не равен продолжаем сравнение
	  jmp pr          ;иначе пропускаем
j2:
    cmp al,59       ;сравниваем с точкой-запятой
  	jne j3          ;если не равен продолжаем сравнение
  	jmp pr          ;иначе пропускаем
j3:
    cmp al,13       ;сравниваем с символом возврата каретки
  	jne j4          ;если не равен продолжаем сравнение
  	jmp pr          ;иначе пропускаем
j4:
    cmp al,10       ;сравниваем с \n
  	jne j5          ;если не равен продолжаем сравнение
  	jmp pr          ;иначе пропускаем
j5:
    cmp al,'$'      ;сравниваем с концом строки
  	jne j6          ;если не равен обрабатываем
  	jmp endstr      ;иначе завершаем
j6:
    xor al,  key[bx] ;сумма по модулю 2 с ключом
    inc bx    ;увеличиваем счетчик ключа
    cmp bx, keylen ;проверяем длину
    jne t       ;если не равно продолжаем
    xor bx, bx  ;иначе обнуляем его
    t:
    mov di, si   ;берем адрес следущего символа
    dec di        ;уменьшаем на 1
    mov [di], al  ;заносим зашифрованный символ
jmp pr    ;повторяем пока не дойдем до конца строки
endstr:     ;выходим из макроса
endm

start:
mov ax,@data
mov ds, ax

;================== меню с опциями работы
men:
lea dx,menu
mov ah,09h    ;вывод меню
int 21h
ent:
mov ah, ch
mov ah, 01h   ;чтение символа
lea dx, choice
int 21h
lea dx, endline
mov ah,09h    ;вывод \n
int 21h
cmp al,'0'
je exit   ;идем на выход
cmp al,'1'
je conin    ;читаем с консоли
cmp al,'2'
je filein   ;читаем из файла
cmp al,'3'
je conout   ;выводим в консоль
cmp al,'4'
je fileout    ;выводим в файл
cmp al,'5'
je begin    ;начинаем шифрование
lea dx,Error    ;если мы дошли до сюда значит неправильный ввод – печатаем сообщение об ошибке
mov ah,09h
int 21h
jmp ent   ;повторяем вывод меню

;=============== ввод строки из консоли
conin:
xor dx,dx
mov ah,0ah    ;читаем из консоли
lea dx, max   ;говорим макс длину буфера
int 21h
xor ax,ax
mov al,act    ;сохраняем количество прочитаных символов
mov bx,ax
mov string[bx],0dh    ;завершаем строчку
mov string[bx+1],0ah
mov string[bx+2],'$'    ;это конец строки
lea dx,endline    ;выводим \n
mov ah,09h
int 21h
lea di,string    ;запоминаем смещение строки
lea si,string
jmp men   ;возврат в меню

;=============== вывод строки в консоль
conout:
lea dx, string    ;записываем смещение строки
mov ah,09h
int 21h   ;выводим строчку
jmp men   ;возврат в меню

;================ ввод из файла
filein:
mov ah,3Dh              ;Функция DOS 3Dh (открытие файла)
xor al,al               ;Режим открытия - только чтение
lea dx,infile          ;Имя файла
xor cx,cx               ;Нет атрибутов - обычный файл
int 21h
jnc f1                  ;если открыли без ошибок идем к f1 иначе сообщение об ошибке
lea dx,Error
mov ah,09h
int 21h
jmp exit                ;завершаем все
f1:
mov handle,ax
mov bx,ax               ;Дескриптор файла
mov ah,3Fh              ;Функция DOS 3Fh (чтение из файла)
lea dx,string           ;Адрес буфера для данных
mov cx,1021              ;Максимальное кол-во читаемых байтов
;1024 размер буфера 1022 это 0dh
                   ;1023 это 0ah
                   ;1024 это '$'
int 21h
jnc f2              ;если прочитали без ошибок идем к f2 иначе вывод сообщения об ошибке
lea dx,Error
mov ah,09h
int 21h
jmp exit            ;завершаем все
f2:
mov bx,ax
mov act, al
mov string[bx],0dh    ;окончание строки
mov string[bx+1],0ah
mov string[bx+2],'$'
mov ah,3Eh              ;Функция DOS 3Eh (закрытие файла)
mov bx,handle           ;Дескриптор
int 21h                 ;Обращение к функции DOS
jnc f3                  ;Если нет ошибки, то выход из программы
lea dx,Error
mov ah,09h
int 21h
jmp exit
f3:
lea di,string
lea si,string
jmp men   ;возврат в меню

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
jmp exit                ;завершаем все
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
jmp men                   ;возвращаемся в меню

;================== вызов макроса шифрования
begin:
crypto string             ;вызов макроса шифрования
jmp men                   ;возвращаемся в меню

;=================== выход из программы
exit:
mov ah, 4ch
int 21h

end start
