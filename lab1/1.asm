.model small
stack 100h
.data
    a db 6
    b db -8
    c db 9
    d db 1
    e db 7
    f dw ?
.486
.code
start:
    mov  ax,@data
    mov  ds,ax
    
    xor  eax,eax
    mov  al,b
    imul al
    xor  ebx,ebx
    mov  bl,2
    imul ebx     ; eax, ax and al contain 2b^2
    xor  ebx,ebx
    mov  bl,a
    add  eax,ebx ; eax, ax and al contain a + 2b^2
    mov  ecx,eax ; saving to ecx, cx and cl
    
    xor  eax,eax
    mov  al,c
    imul eax
    xor  ebx,ebx
    mov  bl,2
    imul ebx
    xor  ebx,ebx
    mov  bl,d
    sub  eax,ebx ; eax, ax and al contain 2c^2 - d
    
    mov  ebx,ecx
	
    imul ebx
    mov  ecx,eax ; ecx contains numerator
    
    xor  eax,eax
    mov  al,e
    imul eax
    xor  ebx,ebx
    mov  bl,a
    add  eax,ebx ; eax, ax and al contain a + e^2
    mov  bx,4
    imul ebx     ; eax, ax and al contain 4(a + e^2)
	
    mov  ebx,eax ; ebx contains denominator
    mov  eax,ecx
	
    idiv ebx     ; divide eax by ebx and save to eax and ax
	
    mov  f,ax
    
    mov ax,4C00h
    int 21h
    end start