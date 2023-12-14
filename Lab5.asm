include Lab5_macro.asm

assume CS:code,DS:data
 
data segment
text1 db "Input first string:$"
inputBuf1 db 97, 99 dup ('$')
charToReplace db 0
charReplaceWith db 0

data ends
  
code segment

  
start:
mov AX, data
mov DS, AX

printLn text1

scanStringLn inputBuf1

scanChar charToReplace

scanChar charReplaceWith

replaceFirstLetter inputBuf1, charToReplace, charReplaceWith

printResult inputBuf1

mov AX,4C00h
int 21h
code ends
end start
