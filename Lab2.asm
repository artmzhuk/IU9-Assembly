assume CS:code,DS:data

data segment
a db 10, 2, 21, 40, 45, 15, 8
len EQU $-a
minDiff db 127
minDiffIndex db 0
result10 db ?, ?, ?, 13, 10, '$'
data ends

; Определить, какие два последовательных элемента массива наименее
; отличаются друг от друга. Найти индекс первого элемента пары. 

code segment

print proc ;prints byte number from al register
xor ah, ah
mov bl, 100
div bl
add al, '0'
mov result10[0], al
mov al, ah
xor ah, ah
mov bl, 10
div bl
add al, '0'
add ah, '0'
mov result10[1], al
mov result10[2], ah
mov dx, offset result10
mov ah, 09h
int 21h
ret
print endp

start:
mov AX, data
mov DS, AX

mov cx, len
sub cx, 1
l1:
	mov si, cx
	
	mov al, a[si]
	mov bl, a[si-1]
	;cmp a[cx], a[cx-1]
	cmp al, bl
	jle else1
		sub al, a[si-1]
		mov bl, minDiff
		cmp bl, al
		jle endOfLoop
			mov minDiff, al
			mov ax, si
			mov minDiffIndex, al 
			dec minDiffIndex
			jmp endOfLoop
	else1:
		mov al, a[si-1]
		sub al, a[si]
		mov bl, minDiff
		cmp minDiff, al
		jle endOfLoop
			mov minDiff, al
			mov ax, si
			mov minDiffIndex, al
			dec minDiffIndex
		endOfLoop:
loop l1

mov al, minDiff
call print

mov al, minDiffIndex
call print

mov AX,4C00h
int 21h
code ends
end start
