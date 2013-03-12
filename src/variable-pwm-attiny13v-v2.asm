;******************************************************************************
;* Copyright December 2012 Andrew Willson
;* andrew.willson@1024bits.com
;*
;******************************************************************************
;* GPLv3 Licensed software
;*
;* This program is free software: you can redistribute it and/or modify
;* it under the terms of the GNU General Public License as published by
;* the Free Software Foundation, either version 3 of the License, or
;* (at your option) any later version.
;*
;* This program is distributed in the hope that it will be useful,
;* but WITHOUT ANY WARRANTY; without even the implied warranty of
;* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;* GNU General Public License for more details.
;*
;* You should have received a copy of the GNU General Public License
;* along with this program.  If not, see <http://www.gnu.org/licenses/>.
;*
;******************************************************************************
;* Program description
;*
;* Assembly code to output a variable PWM waveform on using an ATtiny13V.
;* This code was successfully assembled using GNU avra version 1.2.3
;* The PWM waveform is intended to function as a control signal to a Parallax
;* servo.
;*
;* Program flow:
;*  Set DDB0 to output only.  This is PIN 5 on the chip and the output
;*  pin for the PWM waveform.
;*
;******************************************************************************

.include "attiny13def.inc"             ;ATMEL ATtiny13 system definition file

;**************************** Interrupt Vectors *******************************

.org 0x0000
     rjmp RESET
     rjmp EXT_INT0
     rjmp PCINT
     rjmp TIM0_OVF
     rjmp EE_RDY
     rjmp ANA_COMP
     rjmp TIM0_COMPA
     rjmp TIM0_COMPB
     rjmp WATCHDOG
     rjmp ADC

;**************************** Begin Program ***********************************

.org 0x000A                        ;Leave room for interrupt vectors
RESET:
     ldi r16, low(RAMEND)
     out SPL, r16                  ;Setup Stack
     sei                           ;Enable interrupts
     ldi r16, 0x01                 ;Prepare to set INT0 to trig on level chng
     out MCUCR, r16                ;Enable INT0 to trig on level chng
     ldi r16, 0x40                 ;Prepare to enable ext interrupt INT0
     out GIMSK, r16                ;Enable ext interrupt INT0
     ldi r16, 0x02                 ;Prepare to enable TOV interrupt
     out TIMSK0, r16               ;Enable TOV interrupt
     ldi r18, 0x00                 ;Counter keeping track of TOV cycles

;     in r19, EEARL
;     andi r19,0x7f
; ADC_SINGLE_RUN:
;     ldi r16, 0x42                ;Select ADC2 and Internal 1.1V Ref
;     out ADMUX, r16
;     sbi ADCSRA, 7
;     cbi ADCSRA, 5
;     cbi ADCSRA, 3
;     cbi ADCSRA, 2
;     cbi ADCSRA, 1
;     cbi ADCSRA, 0
;      ldi r19, 0xff

INIT_RANDOM:
     cpi r19, 0x54
     brsh SHIFT_RIGHT
     rjmp INITIAL

SHIFT_RIGHT:
     ldi r19, 0x40
     rjmp INIT_RANDOM


;* Setup Timer and PWM modes
INITIAL:
     ldi r16, 0x01                 ;Prepare duty cycle FF = 100%
     out OCR0A, r16                ;Set output compare value

     ldi r16, 0x81                 ;Prepare to select Phase Correct PWM
     out TCCR0A, r16               ;Write mode with bits set

     ldi r16, 0x04                 ;Prepare to select internal div clk by 256
     out TCCR0B, r16               ;Write register with set bit

ENPORT:
     ldi r16, 0x01                 ;Prepare to output timer on pin 5
     out DDRB, r16                 ;Activate timer output

WAIT: rjmp WAIT                    ;Wait for Interrupt

     rjmp ENPORT                   ;Output new waveform

;**************************** Program Subroutines *****************************

;**************************** End Program Subroutines *************************

;**************************** Interrupt Subroutines ***************************

;* External interrupt changes amount of randomness of PWM pulses
;* Each button push increments the servo by a few degrees with reset at 180

EXT_INT0:
     in r17, OCR0A                 ;Read current position
     cpi r17, 0x01                 ;If start position
     breq TURN_AROUND              ;Then to 90
     rjmp TURN_BACK                ;Must be at 90, so to start
TURN_AROUND:
     ldi r16, 0x05                 ;Load 90 degree location
     out OCR0A, r16                ;Set new duty cycle
     reti                          ;Return from button pushed
TURN_BACK:
     ldi r16, 0x01                 ;Load start location
     out OCR0A, r16                ;Set new duty cycle
     reti                          ;Return from button pushed

PCINT:
     nop
     reti

EE_RDY:
     nop
     reti

TIM0_OVF:
     inc r18                       ;TOV enabled, so increase count
     cp r18, r19                 ;FF => 27 secs
     breq TOV_TURN
     reti
TOV_TURN:
     ldi r18,0x00                  ;Reset TOV counter
     in r17, OCR0A                 ;Read current position
     cpi r17, 0x01                 ;If start position
     breq TURN_AROUND1             ;Then to 90
     rjmp TURN_BACK1               ;Must be at 90, so to start
TURN_AROUND1:
     ldi r16, 0x03                 ;Load 90 degree location
     out OCR0A, r16                ;Set new duty cycle
     reti                          ;Return from button pushed
TURN_BACK1:
     ldi r16, 0x01                 ;Load start location
     out OCR0A, r16                ;Set new duty cycle
     reti                          ;Return from button pushed

ANA_COMP:
     nop
     reti

TIM0_COMPA:
     nop
     reti

TIM0_COMPB:
     nop
     reti

WATCHDOG:
     nop
     reti

ADC:
     nop
     reti

;**************************** End Interrupt Subroutines ***********************
