; Autor reseni: jakub lucny xlucnyj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jakublucny"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
key:            .asciiz "luc"

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:
                ; r8 -- current char value
                ; r9 -- index of current char
                ; r10 -- index of key
                ; r11 -- current value of key
                ; r12 -- indicator if we should do '+' (when 0) or '-' (when 1)

                ; r20 -- holds ASCII value of a
                ; r21 -- holds ASCII value of z
                ; r22 -- holds true if char < a
                ; r23 -- holds true if char > z

                addi r20, r0, 97    ; ASCII value of a
                addi r21, r0, 122   ; ASCII value of z

cypher_loop:    
                lbu r8, msg(r9)     ; saves msg letter into r8
                lbu r11, key(r10)   ; saves current key value
                beqz r8, loop_end   ; compares it to 0(== \0) and jumps to end if true
                
                addi r11, r11, -96  ; changes it to value of letter, a=1, b=2, c=3,...
                beqz r12, do_plus   ; Decide if we do + or -
do_minus:
                dsub r8, r8, r11    ; decrement value of current char
                j do_end
do_plus:
                dadd r8, r8, r11    ; increment value of current char
do_end:
                ; Checks if char is still between "a" and "z" and if needed does conversion back to letter
                sltu r22, r8, r20   ; If r8 < r20 --> r22 = 1; else r22 = 0 
                sltu r23, r21, r8   ; If r21 < r8 --> r23 = 1; else r23 = 0 
                beqz r22, z_check   ; jumps if r22 == 0 (meaning: not below "a" value)
below_a:
                addi r8, r8, 26     ; sets char back to be letter
                j conversion_end
z_check:
                beqz r23, conversion_end  ; jumps if r22 == 0 (meaning: not above "z" value)
above_z:
                addi r8, r8, -26     ; sets char back to be letter

conversion_end:
                addi r10, r10, 1    ; increment pointer to current key char
                sltiu r22, r10, 3   ; If r10 < 3 --> r22 = 1; else r22 = 0
                beqz r22, cnt_reset   ; jumps if r22 == 0 (meaning: needs to reset r10 back to 0)
                j cnt_reset_end
cnt_reset:
                addi r10, r0, 0   ; reset r10 back to 0

cnt_reset_end:
                xori r12, r12, 1    ; xor the indicator of +/- (from 0 to 1 and 1 to 0)
                sb r8, cipher(r9)   ; store the char into space for ciphered text

                addi r9, r9, 1      ; increment r9
                j cypher_loop       ; jumps back to start
loop_end:
                sb r8, cipher(r9)   ; put 0 at the end of string
                ; print the final string
                daddi   r4, r0, cipher ; vozrovy vypis: adresa msg do r4
                jal     print_string ; vypis pomoci print_string - viz nize

; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
