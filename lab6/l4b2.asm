.model small
.stack 100h
.data

extrn menu : byte
extrn Error : byte
extrn Error1 : byte
extrn endline  : byte
extrn choice  : byte



.code
.486
EXTRN  crypto : NEAR
EXTRN  conin : NEAR
EXTRN  conout : NEAR
EXTRN  filein : NEAR
EXTRN  fileout : NEAR
;=================== макрос шифрования


start:
mov ax,@data
mov ds, ax

;================== меню с опциями работы
men:
lea dx,menu
mov ah,09h    ;вывод меню
int 21h
ent:
xor ax, ax
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
jne m1
call conin    ;читаем с консоли
jmp men
m1: cmp al,'2'
jne m2
call filein   ;читаем из файла
jmp men
m2: cmp al,'3'
jne m3
call conout   ;выводим в консоль
jmp men
m3: cmp al,'4'
jne m4
call fileout    ;выводим в файл
jmp men
m4: cmp al,'5'
jne m5
call crypto    ;выводим в файл
jmp men   ;начинаем шифрование
m5: lea dx,Error    ;если мы дошли до сюда значит неправильный ввод – печатаем сообщение об ошибке
mov ah,09h
int 21h
jmp ent   ;повторяем вывод меню

;=================== выход из программы
exit:
mov ah, 4ch
int 21h

end start
