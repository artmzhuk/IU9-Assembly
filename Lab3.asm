assume CS:code,DS:data
 
data segment
text1 db "Input first string:$"
text2 db 13, 10, "Input second string:$"
newline db 13, 10, '$'
inputBuf1 db 97, 99 dup ('$')
inputBuf2 db 97, 99 dup ('$')
result10 db 5 dup (?), 13, 10, '$'

counter db 0

data ends
 
; 9 strspn
 
code segment
 
printWord proc
mov cx, 5
mov bx, 10
printLoop:
	xor dx, dx
	div bx
	mov si, cx
	add dl, '0'
	mov result10[si-1], dl
loop printLoop
mov ah, 09h
mov dx, offset result10
int 21h
ret
printWord endp
 
strspn proc
push bp
mov bp, sp
sub sp, 4 ;malloc
mov si, [bp+4];a
mov di, [bp+6];b

mov al, [si+1]
mov [bp-1], al ;bp-1 == len1

mov al, [di+1]
mov [bp-2], al ;bp-2 == len2

xor cx, cx

loop1:
cmp cl, [bp-1] ;cl = counter
jae endLoop1
xor ax, ax ;ax - i
loop2:
cmp al, [bp-2]
jae endLoop1
mov si, [bp+4]
add si, 2	
add si, cx

mov di, [bp+6]
add di, 2
add di, ax	

mov dl, [si]

inc ax
cmp dl, [di] ;dl-str1 di-str2
jne loop2
inc cl
jmp loop1

endLoop1:

mov ax, cx
mov sp, bp
pop bp
ret 4
strspn endp

 
start:
mov AX, data
mov DS, AX

mov ah, 09h
mov dx, offset text1
int 21h

mov ah, 0Ah
mov dx, offset inputBuf1
int 21h

mov ah, 09h
mov dx, offset text2
int 21h

mov ah, 0Ah
mov dx, offset inputBuf2
int 21h

mov ah, 09h
mov dx, offset newline
int 21h

push offset inputBuf2
push offset inputBuf1
call strspn
call printWord

mov AX,4C00h
int 21h
code ends
end start
