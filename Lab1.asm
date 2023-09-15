assume CS:code,DS:data

data segment
a db 3
b db 4
c db 12
d db 6
result10 db ?, ?, ?, 13, 10, '$'
result16 db ?, ?, '$'
data ends

;a*b + c/d + 5

code segment
start:
mov AX, data
mov DS, AX

mov al, a
mov bl, b
mul bl ;a*b
mov cx, ax 
xor ax, ax
mov al, c
mov bl, d
div bl ;c/d
add cx, ax
add cx, 5 ;result

jmp resultNotOverwriten ;comment to overwrite result
mov cx, 239 
resultNotOverwriten:

mov ax, cx
mov bl, 100
div bl
add al, '0'
mov [result10 + si], al
inc si

mov bl, 10
mov al, ah
xor ah, ah
div bl
add al, '0'
mov [result10 + si], al
inc si

add ah, '0'
mov [result10 + si], ah

mov dx, offset result10
mov ah, 09h
int 21h 

mov ax, cx
mov bl, 16
div bl
cmp al, 9
jle label1
sub al, 10
add al, 'A'
jmp label2
label1:
add al, '0'
label2:
xor si, si
mov [result16 + si], al
inc si

cmp ah, 9
jle label21
sub ah, 10
add ah, 'A'
jmp label22
label21:
add ah, '0'
label22:
mov [result16 + si], ah

mov dx, offset result16
mov ah, 09h
int 21h 

mov AX,4C00h
int 21h
code ends
end start
