assume CS:code,DS:data
 
data segment
a dw 10, 14, 16, 30000, 30001, 89
len EQU $-a
minDiff dw 65535
minDiffIndex dw 0
result10 db 5 dup (?), 13, 10, '$'
diffStr db "Minimal diference is: $"
indexStr db "Index: $"
oneElementStr db "Array has only one element$"
data ends
 
; Определить, какие два последовательных элемента массива наименее
; отличаются друг от друга. Найти индекс первого элемента пары. 
 
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
 
 
start:
mov AX, data
mov DS, AX

mov cx, len
mov si, len
shr cx, 1
sub cx, 1

cmp cx, 0; checks array with len == 1
jne moreThanOneElement
	mov dx, offset oneElementStr
	mov ah, 09h
	int 21h
	mov AX,4C00h
	int 21h
moreThanOneElement:

l1: ; for(int i = a.size - 1; i > 0; i++)
	sub si, 2
	mov ax, a[si]
	mov bx, a[si-2]
	cmp ax, bx
	jbe else1 ; if(a[i] > a[i-1])
		sub ax, bx; a[i] - a[i-1]
		mov bx, ax
		jmp endOfCompare
	else1: ;else
		sub bx, ax
	endOfCompare:
	cmp minDiff, bx ; if(minDiff > a[i-1] - a[i]
	jbe endOfLoop
		mov minDiff, bx
		mov minDiffIndex, cx
		dec minDiffIndex
	endOfLoop:
loop l1

mov ah, 09h
mov dx, offset diffStr
int 21h

mov ax, minDiff
call printWord

mov ah, 09h
mov dx, offset indexStr
int 21h

mov ax, minDiffIndex
call printWord

mov AX,4C00h
int 21h
code ends
end start
