section .data
  message db 'Guess a number between 1 and 100: ', 0
  correctMsg db 'Congratulations, you guessed correctly!', 0
  tooHighMsg db 'Too high, try again.', 0
  tooLowMsg db 'Too low, try again.', 0
  newline db 10
  answer dd 42 ; the correct answer
section .text
  global _start
_start:
  ; Set up random number generator
  mov eax, 40h
  mov ebx, 0
  int 0x21
  
  ; Display message and get user input
  mov eax, 4
  mov ebx, 1
  mov ecx, message
  mov edx, 30
  int 0x80
  
  ; Read user input
  sub esp, 4 ; allocate space on stack for scanf argument
  mov eax, 3
  mov ebx, 0
  mov ecx, esp
  mov edx, 4
  int 0x80
  
  ; Convert user input to integer
  mov eax, [esp]
  sub eax, 48 ; convert from ASCII to integer
  mov ebx, 10
  mul ebx
  mov ebx, eax
  mov eax, [esp+1]
  sub eax, 48 ; convert from ASCII to integer
  add eax, ebx ; combine digits to form integer
  mov ebx, 100
  sub ebx, eax ; subtract user's guess from 100 to get array index
  mov ecx, answer[ebx*4] ; retrieve answer from array
  
  ; Check user's guess against correct answer
  cmp ecx, eax
  je correct
  jg tooHigh
  jl tooLow
  
correct:
  ; Display "Congratulations" message
  mov eax, 4
  mov ebx, 1
  mov ecx, correctMsg
  mov edx, 32
  int 0x80
  jmp end
  
tooHigh:
  ; Display "Too high" message and try again
  mov eax, 4
  mov ebx, 1
  mov ecx, tooHighMsg
  mov edx, 19
  int 0x80
  jmp start
  
tooLow:
  ; Display "Too low" message and try again
  mov eax, 4
  mov ebx, 1
  mov ecx, tooLowMsg
  mov edx, 18
  int 0x80
  jmp start
  
end:
  ; Display newline character and exit
  mov eax, 4
  mov ebx, 1
  mov ecx, newline
  mov edx, 1
  int 0x80
  
  mov eax, 1
  xor ebx, ebx
  int 0x80
