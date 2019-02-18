extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TODO TASK 1
        ;mov ebp, esp; for correct debugging
        push ebp
        mov ebp, esp
        mov dword ecx, [ebp + 8] ; stringul
        mov dword edx, [ebp + 12] ; cheia
        mov edi, 0 ; index
        
     loop1:
        mov al, byte [ecx + edi] ; pun in al cate un byte din string (valoare)
        mov bl, byte [edx + edi] ; pun in bl cate un byte din cheie (valoarea)
        
        xor al, bl
        mov byte [ecx + edi], al ;suprascriem ecx[0] cu rezultatul xor-ului, dupa ecx[1] etc..
        inc edi ; pentru a pointa catre un nou caracter
        cmp byte [ecx + edi], 0
        je stop1
        jmp loop1
        
      stop1:
       leave
       ret
       
rolling_xor:
	; TODO TASK 2
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]
        mov edi, 0
       
     string_len:
          inc edi
          cmp byte [ecx + edi], 0
          jne string_len
        
          dec edi
     loop2:
       
        mov dl, byte [ecx + edi] ;rezultatul ultimului xor
        dec edi
        mov bl, byte [ecx + edi] ; bl contine urmatorul caracter din sir
        xor bl, dl
        inc edi
        mov byte [ecx + edi], bl
        dec edi
        cmp edi, 0
        je stop2
        jmp loop2
        
     stop2:
        leave
        ret

xor_hex_strings:
	push ebp
        mov ebp, esp
	; TODO TASK 3
        mov  dword ecx, [ebp + 8] ; stringul
        mov dword edx, [ebp + 12] ; cheia
       
        mov edi, 0
        
     loop3:
        
       
         mov al, byte [ecx + edi] ; pun in al cate un byte din string (valoare)
         mov bl, byte [edx + edi] ; pun in bl cate un byte din cheie (valoarea)
         xor al, bl
         
         mov byte [ecx + edi], al ;suprascriem ecx[0] cu rezultatul xor-ului, dupa ecx[1] etc..
         inc edi ; pentru a pointa catre un nou caracter
         cmp byte [ecx + edi], 0
         je stop3
         jmp loop3
        
      stop3:
       
        leave
	ret


; functie care intoarce 1 daca a gasit force in stringul decriptat, 0 altfel
search_force:

        push ebp
        mov ebp, esp
        ; caut force in ecx
        mov edi, 0 ; edi e pt string
        mov esi, 0 ; daca ramane 0 inseamna ca nu s-a gasit substringul nostru
        mov dword ecx, [ebp + 8] ; stringul
        
        next_char_search:
          cmp byte [ecx + edi], 'f'
          je check_next_char_o
          jmp increment_edi
          
        check_next_char_o:
          inc edi
          cmp byte [ecx + edi], 0
          je exit_search
          cmp byte [ecx + edi], 'o'
          je check_next_char_r
          jmp increment_edi
          
        check_next_char_r:
          inc edi
          cmp byte [ecx + edi], 0
          je exit
          cmp byte [ecx + edi], 'r'
          je check_next_char_c
          jmp increment_edi
          
        check_next_char_c:
          inc edi
          cmp byte [ecx + edi], 0
          je exit_search
          cmp byte [ecx + edi], 'c'
          je check_next_char_e
          jmp increment_edi    
          
        check_next_char_e:
          inc edi
          cmp byte [ecx + edi], 0
          je exit_search
          cmp byte [ecx + edi], 'e'
          je gasit ; inseamna ca am gasit cuvantul
          jmp increment_edi
          
        gasit:
          mov esi, 1
          jmp exit_search
            
        increment_edi:
          inc edi
          cmp byte [ecx + edi], 0
          je exit_search
          jmp next_char_search
          
        exit_search:
        
          mov eax, esi
          ; functia intoarce 1 daca a gasit substringul force in sir, 0 altfel
        
         leave
	 ret

; functie care face xor intre sir si cheia la pasul curent
make_xor:

        push ebp
        mov ebp, esp
       
        mov edi, 0 ; edi e pt string
        mov dword ecx, [ebp + 8] ; stringul
        mov byte bl, [ebp + 12] ;cheia, prima e 0, a2a 1 ... 255
        xor eax, eax
        
        do_xor:
            cmp byte [ecx + edi], 0
            je exit_xor
            mov al, byte [ecx + edi]
            xor al, bl
            mov byte [ecx + edi], al
            inc edi
            cmp byte [ecx + edi], 0
            je exit_xor
            jmp do_xor
            ; else
            
        exit_xor:
        leave
        ret
        
bruteforce_singlebyte_xor:

	push ebp
        mov ebp, esp
        mov ebx, 0
        xor_with_singleByte:
        ; mai intai apelam functia make_xor
            push ebx ; cheia 0 initial
            push ecx ; encoded string
            call make_xor
            add esp, 8
            ; acum ecx este decodificat
            ; cautam substringul force in ecx-ul rezultat
            ; daca l-am gasit, ies din loop-ul xor_with_singleByte
            ; si plasez cheia, adica pe ebx, in eax
            push ecx
            call search_force
            add esp, 4
            ; eax contine 1 acum daca sirul force a fost gasit, 0 altfel
            cmp eax, 1
            je was_found
            cmp eax, 0 ; nu a fost gasit, deci apelam functia de xor pentru a ajunge la sirul initial(cel criptat)
            je make_xor_again
            
       make_xor_again:
            push ebx
            push ecx
            call make_xor
            add esp, 8
            jmp increment_ebx ; cheia cu care vom face xor la pasul urmator
            
       increment_ebx:
            inc ebx
            cmp ebx, 255
            je done
            jmp xor_with_singleByte     
            
       was_found:
            mov eax, ebx ;am gasit cheia
            
       done:    
            leave
            ret
            

decode_vigenere:
	
        push ebp
        mov ebp, esp
	; TODO TASK 3
        
        mov dword ecx, [ebp + 8] ; stringul
        mov dword edx, [ebp + 12] ; cheia
        mov edi, 0 ; for string
        mov esi, 0 ; for key
        
        decrypt:
            cmp byte [ecx + edi], 'a' ;compare with a
            jl next_char
            cmp byte [ecx + edi], 'z' ; compare with z
            jg next_char
            ; else inseamna ca e litera
            mov al, byte [ecx + edi] ; al litera din string
            
            mov ah, al
            cmp byte [edx + esi], 0
            je make_esi_0
            
        go_back:
            mov bl, byte [edx + esi] ; bl litera din cheie
            sub bl, 'a' ; bl offsetul literii currente fata de a
             
            sub al, bl 
            cmp al, 'a'
            jl less_than_a
            jmp bigger_than_a
            
         less_than_a:
         
            mov al, ah
            sub al, 'a' ; pentru a afla offsetul fata de a
            sub al, bl
            add al, 26
            mov bh, 'a'
            add bh, al
            mov byte [ecx + edi], bh
            inc edi
            inc esi
            cmp byte [ecx + edi], 0
            je decrypt_done
            jmp decrypt
            
        bigger_than_a:
        
            mov byte [ecx + edi], al
            inc edi
            inc esi
            cmp byte [ecx + edi], 0
            je decrypt_done
            jmp decrypt
        
        make_esi_0:
            mov esi, 0 ; daca am ajuns la finalul cheii
            ; ne intoarcem la inceputul acesteia
            jmp go_back
            
        next_char:
            inc edi
            cmp byte [ecx + edi], 0
            je decrypt_done
            jmp decrypt
        
        decrypt_done:
        
        leave
	ret

main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
	; TODO TASK 1: call the xor_strings function
       
        mov edx, 0
        loop:
        cmp byte [ecx + edx], 0
        jne increment_contor
        cmp byte [ecx + edx], 0
        je task1_cont
        
        increment_contor:
        inc edx
        jmp loop
        
        task1_cont:
        
        inc edx ;acum ecx + edx pointeaza la cheie
       
        mov edi, 0
        mov ebx, ecx
        add ecx, edx
        
         push ecx ;cheia
         push ebx ;stringul
         call xor_strings
         add esp, 8
        
        
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
	; TASK 2: Rolling XOR

	; TODO TASK 2: call the rolling_xor function
        push ecx
        call rolling_xor
        add esp, 4
        
	push ecx
	call puts
	add esp, 4

	jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings
        mov edx, 0
     loop3task:
        cmp byte [ecx + edx], 0x00
        jne increment_contor3
        cmp byte [ecx + edx], 0x00
        je task3_cont
        
    increment_contor3:
        inc edx
        jmp loop3task
        
    task3_cont:
        
        inc edx ;acum ecx + edx ar trebui sa pointeze la cheie
       
        mov edi, 0
        mov ebx, ecx ; ebx pointeaza la sir
        add ecx, edx ; ecx pointeaza la cheie
        
        
     loop_to_int_forString:
        
        
        cmp byte [ebx + edi], 'a' ; and byte [ebx + edi] <= 'F'
        jge hexLetter
        cmp byte [ebx + edi], '0'
        jge number
        cmp byte [ebx + edi], 0x00
        je integer_conversion_done_forString 
        
     number:
        sub byte [ebx + edi], '0'
        inc edi
        jmp loop_to_int_forString
        
     hexLetter:
        sub byte [ebx + edi], 'a'
        add byte [ebx + edi], 10
        
        inc edi
        jmp loop_to_int_forString
           
     integer_conversion_done_forString:
     
        ; now, the string is converted to int
        ; now, convert the key to int
        ;---------------------------------------
        mov edi, 0
        
     loop_to_int_forKey:
        cmp byte [ecx + edi], 'a'
        jge hexLetterK
        cmp byte [ecx + edi], '0' ; and byte [ebx + edi] <= 'F'
        jge numberK
        cmp byte [ecx + edi], 0x00
        je integer_conversion_done_forKey
        
     numberK: ; K from key
        sub byte [ecx + edi], '0'
        inc edi
        jmp loop_to_int_forKey
        
     hexLetterK:
        sub byte [ecx + edi], 'a'
        add byte [ecx + edi], 10
        
        inc edi
        jmp loop_to_int_forKey
           
     integer_conversion_done_forKey:
     
     ; now, convert the string to hex (ebx)
     
    
       mov edi, 0
       mov esi, 0 ; index pentru vectorul de hexa
    toHexString:
     
       mov al, byte [ebx + edi]
       mov dl, 16
       imul dl
       
       add al, byte [ebx + edi + 1]
       
       mov byte [ebx + esi], al
       inc esi
       inc edi
       inc edi
       cmp byte [ebx + edi], 0x00
       je toHexStringDone
       jmp toHexString
        
   toHexStringDone:
       mov byte [ebx + esi], 0x00
       
       ;now convert the key to HEX
       
       mov edi, 0
       mov esi, 0
       
    toHexKey:
     
      mov al, byte [ecx + edi]
      mov dl, 16
      imul dl
       
      add al, byte [ecx + edi + 1]
       
      mov byte [ecx + esi], al
      inc esi
      inc edi
      inc edi
      cmp byte [ecx + edi], 0x00
      je toHexKeyDone
      jmp toHexKey   
      
    toHexKeyDone:
     
      mov byte [ecx + esi], 0x00
      
     
      push ecx
      push ebx
      call xor_hex_strings
      add esp, 8

      push ecx                     ;print resulting string
      call puts
      add esp, 4

      jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
        push ecx
        call bruteforce_singlebyte_xor
        add esp, 4
        
        push eax
	push ecx                    ;print resulting string
	call puts
	pop ecx
        
        pop eax
	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	
        ; OBSERVATIE: initial, nu m-am prins ce era cu, codul de mai sus
        ; asa ca am aflat adresa cheii ca la celelalte task-uri
        ; practic, in loc sa folosesc strlen, aflu eu lungimea sirului
        mov edx, 0
     loop6:
        cmp byte [ecx + edx], 0
        jne increment_contor6
        cmp byte [ecx + edx], 0
        je task6_cont
        
    increment_contor6:
        inc edx
        jmp loop6
        
    task6_cont:
        
        inc edx ;acum ecx + edx pointeaza la cheie
       
         mov edi, 0
         mov ebx, ecx
         add ecx, edx
        
        push ecx 
        push ebx                   
        call decode_vigenere
	
	add esp, 8

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
