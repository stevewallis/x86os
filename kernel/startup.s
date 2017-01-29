[bits 32]
global start
start:
[extern kernel_main]
call kernel_main
jmp $