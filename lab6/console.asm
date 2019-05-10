.model small
.data
extrn max : byte
extrn act : byte
extrn string : byte
extrn endline : byte
.code
.486
public conin, conout
;=============== ввод строки из консоли
conin proc
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
ret   ;возврат в меню
conin endp

;=============== вывод строки в консоль
conout proc
lea dx, string    ;записываем смещение строки
mov ah,09h
int 21h   ;выводим строчку
ret  ;возврат в меню
conout endp

end
