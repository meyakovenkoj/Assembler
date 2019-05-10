.model small
public max, act, string, menu, error, outfile, infile, endline, choice, handle, key, keylen, error1
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
outfile         db "c:\lab6\outpu_fl.txt",0    ;файл вывода
infile          db "c:\lab6\input_fl.txt",0    ;файл ввода
endline         db 0dh,0ah,'$'
choice          db 0    ;переменная выбора в меню
handle          dw ?    ;дескриптор файла
key             db '4664'     ;ключ шифрования
keylen          dw 4          ;длина ключа
Error1          db "shit",0,0dh,0ah,'$'
end
