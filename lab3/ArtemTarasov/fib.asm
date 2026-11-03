global main
extern printf
extern scanf
extern puts

section .data
    .LC0 db "Enter the Fibonacci number you want to calculate (0-93): ", 0
    .LC1 db "%d", 0
    .LC2 db "Please enter a number between 0 and 93.", 0
    .LC3 db "The %dth Fibonacci number is %llu", 10, 0

section .text

fibonacci:
    push    rbp
    mov     rbp, rsp
    push    rbx                 ; Збереження регістра rbx для подальшого використання
    sub     rsp, 24             ; Виділення пам'яті під локальні змінні

    mov     dword [rbp-20], edi ; Збереження аргументу n
    cmp     dword [rbp-20], 0   ; Перевірка на базовий випадок (n == 0)
    jne     .L2
    mov     eax, 0              ; Повертаємо 0
    jmp     .L3

.L2:
    cmp     dword [rbp-20], 1   ; Перевірка на базовий випадок (n == 1)
    jne     .L4
    mov     eax, 1              ; Повертаємо 1
    jmp     .L3

.L4:
    ; Обчислення fibonacci(n - 1)
    mov     eax, dword [rbp-20]
    sub     eax, 1
    mov     edi, eax
    call    fibonacci
    mov     rbx, rax            ; Зберігаємо результат n-1 у rbx

    ; Обчислення fibonacci(n - 2)
    mov     eax, dword [rbp-20]
    sub     eax, 2
    mov     edi, eax
    call    fibonacci
    
    add     rax, rbx            ; Додавання результатів (n-1) + (n-2)

.L3:
    mov     rbx, qword [rbp-8]  ; Відновлення значення rbx
    leave
    ret

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16

    ; Вивід запрошення
    mov     edi, .LC0
    mov     eax, 0
    call    printf

    ; Ввід числа
    lea     rax, [rbp-4]
    mov     rsi, rax
    mov     edi, .LC1
    mov     eax, 0
    call    scanf

    ; Перевірка введеного числа на межі (0-93)
    mov     eax, dword [rbp-4]
    test    eax, eax
    js      .L6                 ; Якщо менше 0
    mov     eax, dword [rbp-4]
    cmp     eax, 93
    jle     .L7                 ; Якщо в межах норми

.L6:
    ; Повідомлення про помилку вводу
    mov     edi, .LC2
    call    puts
    mov     eax, 1              ; Код помилки 1
    jmp     .L9

.L7:
    ; Виклик рекурсії та вивід результату
    mov     eax, dword [rbp-4]
    mov     edi, eax
    call    fibonacci
    
    mov     rdx, rax            ; Результат обчислення
    mov     eax, dword [rbp-4]
    mov     esi, eax            ; Введене число
    mov     edi, .LC3           ; Рядок форматування
    mov     eax, 0
    call    printf
    mov     eax, 0              ; Код успіху 0

.L9:
    leave
    ret
