;
; a2q4.asm
;
; Fix the button subroutine program so that it returns
; a different value for each button
;

;
; Definitions for PORTA and PORTL when using
; STS and LDS instructions (ie. memory mapped I/O)
;
.equ DDRB=0x24
.equ PORTB=0x25
.equ DDRL=0x10A
.equ PORTL=0x10B

;
; Definitions for using the Analog to Digital Conversion
.equ ADCSRA=0x7A
.equ ADMUX=0x7C
.equ ADCL=0x78
.equ ADCH=0x79


		; initialize the Analog to Digital conversion

		ldi r16, 0x87
		sts ADCSRA, r16
		ldi r16, 0x40
		sts ADMUX, r16

		; initialize PORTB and PORTL for ouput
		ldi	r16, 0xFF
		sts DDRB,r16
		sts DDRL,r16


		clr r0
		call display
lp:
		call check_button
		tst r24
		breq lp
		mov	r0, r24

		call display
		ldi r20, 99
		call delay
		ldi r20, 0
		mov r0, r20
		call display
		rjmp lp

;
; An improved version of the button test subroutine
;
; Returns in r24:
;	0 - no button pressed
;	1 - right button pressed
;	2 - up button pressed
;	4 - down button pressed
;	8 - left button pressed
;	16- select button pressed
;
; this function uses registers:
;	r24
;
; if you consider the word:
;	 value = (ADCH << 8) +  ADCL
; then:
;
; value > 0x3E8 - no button pressed
;
; Otherwise:
; value < 0x032 - right button pressed
; value < 0x0C3 - up button pressed
; value < 0x17C - down button pressed
; value < 0x22B - left button pressed
; value < 0x316 - select button pressed
; 
check_button:
		; start a2d
		lds	r16, ADCSRA	
		ori r16, 0x40
		sts	ADCSRA, r16

		; wait for it to complete
wait:	lds r16, ADCSRA
		andi r16, 0x40
		brne wait

		; read the value
		lds r16, ADCL
		lds r17, ADCH

		; put your new logic here:
		clr r24
		cpi r17,0x03
		brsh N0
		cpi r17,0x02
		breq N1
		cpi r17,0x01
		breq N2
		cpi r17,0x00
		breq N3

N0:     cpi r16,0xE8
        brsh no
		cpi r16,0x16
		brlo select
		jmp wait 

N1:     cpi r16,0x2B
        brlo left
		cpi r16,0x2B
		brsh select
		jmp wait

N2:     cpi r16,0x7C
        brlo down
        cpi r16,0x7C
        brsh left
		jmp wait

N3:     cpi r16,0xC3
        brsh down
        cpi r16,0xC3
        brlo N4
		jmp wait

N4:     cpi r16,0x32
        brlo right
        cpi r16,0x32
		brsh up
		jmp wait
;
no:     ret
right:  ldi r24,1
        ret 
up:     ldi r24,2
        ret
down:   ldi r24,4
        ret
left:   ldi r24,8
        ret
select: ldi r24,16
		ret

;
; delay
;
; set r20 before calling this function
; r20 = 0x40 is approximately 1 second delay
;
; this function uses registers:
;
;	r20
;	r21
;	r22
;
delay:	
del1:		nop
		ldi r21,0xFF
del2:		nop
		ldi r22, 0xFF
del3:		nop
		dec r22
		brne del3
		dec r21
		brne del2
		dec r20
		brne del1	
		ret

;
; display
; 
; display the value in r0 on the 6 bit LED strip
;
; registers used:
;	r0 - value to display
;
display:
		; copy your code from a2q2.asm here
		mov r16,r0
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

		ret
