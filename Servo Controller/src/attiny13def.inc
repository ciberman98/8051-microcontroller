;*
;**************************** SPECIFY DEVICE **********************************
.device ATtiny13
.equ SIGNATURE_000 = 0x1e
.equ SIGNATURE_001 = 0x90
.equ SIGNATURE_002 = 0x07

;**************************** I/O REGISTER DEFINITIONS ************************
.equ SREG      = 0x3f
.equ SPL       = 0x3d
.equ GIMSK     = 0x3b
.equ GIFR      = 0x3a
.equ TIMSK0    = 0x39
.equ TIFR0     = 0x38
.equ SPMCSR    = 0x37
.equ OCR0A     = 0x36
.equ MCUCR     = 0x35
.equ MCUSR     = 0x34
.equ TCCR0B    = 0x33
.equ TCNT0     = 0x32
.equ OSCCAL    = 0x31
.equ TCCR0A    = 0x2f
.equ DWDR      = 0x2e
.equ OCR0B     = 0x29
.equ GTCCR     = 0x28
.equ CLKPR     = 0x26
.equ WDTCR     = 0x21
.equ EEARL     = 0x1e
.equ EEDR      = 0x1d
.equ EECR      = 0x1c
.equ PORTB     = 0x18
.equ DDRB      = 0x17
.equ PINB      = 0x16
.equ PCMSK     = 0x15
.equ DIDR0     = 0x14
.equ ACSR      = 0x08
.equ ADMUX     = 0x07
.equ ADCSRA    = 0x06
.equ ADCH      = 0x05
.equ ADCL      = 0x04
.equ ADCSRB    = 0x03

;**************************** CPU REGISTER DEFINITIONS ************************
.def XH   = r27
.def XL   = r26
.def YH   = r29
.def YL   = r28
.def ZH   = r31
.def ZL   = r30

;**************************** DATA MEMORY DECLARATIONS ************************
.equ FLASHEND       = 0x01ff            ; Note: Word address
.equ IOEND          = 0x003f
.equ SRAM_START     = 0x0060
.equ SRAM_SIZE      = 64
.equ RAMEND         = 0x009f
.equ XRAMEND        = 0x0000
.equ E2END          = 0x003f
.equ EEPROMEND      = 0x003f
.equ EEADRBITS      = 6

;**************************** BOOTLOADER DECLARATIONS *************************
.equ PAGESIZE       = 16

