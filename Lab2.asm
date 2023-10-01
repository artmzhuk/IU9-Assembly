assume CS:code,DS:data
 
data segment
a dw 10, 2, 21, 40, 45, 15, 8
len EQU $-a
minDiff dw 65535
minDiffIndex dw 0
result10 db ?, ?, ?, ?, ?, 13, 10, '$'
diffStr db "Minimal diference is: $"
indexStr db "Index: $"
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
start:
mov AX, data
mov DS, AX

mov cx, len
mov si, len
shr cx, 1
sub cx, 1
l1: ; for(int i = a.size - 1; i > 0; i++)
	sub si, 2
	mov ax, a[si]
	mov bx, a[si-2]
	cmp ax, bx
	jbe else1 ; if(a[i] > a[i-1])
		sub ax, bx; a[i] - a[i-1]
		cmp minDiff, ax
		jbe endOfLoop ;if(minDiff > a[i] - a[i-1])
			mov minDiff, ax
			mov minDiffIndex, cx 
			dec minDiffIndex
			jmp endOfLoop
	else1: ;else
		sub bx, ax
		cmp minDiff, bx ; if(minDiff > a[i-1] - a[i]
		jbe endOfLoop
			mov minDiff, cx
			mov minDiffIndex, ax
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
