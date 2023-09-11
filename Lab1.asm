assume CS:code,DS:data

data segment
a db 2
b db 8
c db 14
d db 7
data ends

;variant 9
;a*b + c/d + 5

code segment
start:
mov AX, data 
mov DS, AX

mov DL, a
add DL, b

xor AX, AX
mov AL, c
div d

add DL, AL
add DX, 5

mov AX,4C00h
int 21h ; returns to OS

code ends
end start
