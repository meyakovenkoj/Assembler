.model small
.data
extrn outfile  : byte
extrn infile  : byte
extrn Error : byte
extrn string : byte
extrn handle  : word
extrn act : byte  
.code
.486
public filein, fileout
;================ ввод из файла
filein proc
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
exit:
ret   ;возврат в меню
filein endp
;==================== вывод в файл
fileout proc

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
fileout endp

end
