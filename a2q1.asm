;
; a2q1.asm
;
; Write a program that displays the binary value in r16
; on the LEDs.
;
; See the assignment PDF for details on the pin numbers and ports.
;
;
;
; These definitions allow you to communicate with
; PORTB and PORTL using the LDS and STS instructions
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B



		ldi r16, 0xFF
		sts DDRB, r16		; PORTB all output
		sts DDRL, r16		; PORTL all output

		ldi r16, 0x22		; display the value
		mov r0, r16			; in r0 on the LEDs

; Your code here
        mov r17,r16
		ldi r18,0x00
		ldi r19,0x00
first:  andi r17,1
		cpi r17,1
		brne second
		ori r18,0x80

second: mov r17,r16
        andi r17,2
		cpi r17,2
		brne third
		ori r18,0x20

third:  mov r17,r16
        andi r17,4
		cpi r17,4
		brne fourth
		ori r18,0x08
	
fourth: mov r17,r16
        andi r17,8
		cpi r17,8
		brne fifth
		ori r18,0x02

fifth:  mov r17,r16
        andi r17,16
		cpi r17,0x10
		brne sixth
		ori r19,0x02

sixth:  mov r17,r16
        andi r17,32
		cpi r17,0x20
		brne end
		ori r19,0x08

end:    sts PORTL,r18
		sts PORTB,r19

;
; Don't change anything below here
;
done:	jmp done
