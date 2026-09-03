; **********************************************************************
; **  Device Driver                             by Stephen C Cousins  **
; **  Hardware:  RC2014            16550 driver by Colin C MacArthur  **
; **  Interface: Serial 16550 ACE                                     **
; **********************************************************************

; This module is the driver for the RC2014 serial I/O interface which is
; based on the 16550 Asynchronous Communications Element (ACE)
;
; Base addresses for ACE externally defined. eg:
;kACE1:     .EQU 0xC0           ;Base address of serial ACE #1
;
; DLAB (Line Control Register Bit 7 = 1)
; 0xC0   Data registers (read and write)
; 0xC1   Interrupt Enable Register Control register (read and write)
;
; DLAB (Line Control Register Bit 7 = 0)
; 0xC0   Data registers (read and write)
; 0xC1   Interrupt Enable Register Control register (read and write)
; 0xC2   FIFO Control     Register Control register (write)
; 0xC2   Interrupt Ident. Register Control register (read)
; 0xC3   Line Control     Register (read and write)
; 0xC4   Modem Control    Register (read and write)
; 0xC5   Line Status      Register (read)
; 0xC6   Modem Status     Register (read)
; 0xC7   Scratch          Register (read and write)
;
;
;kACE1:    .EQU 0xC0           ; Base address of serial ACE #1
kACE1_R0   .EQU     kACE1 + 0  ; Data             Register (read and write)
kACE1_R1   .EQU     kACE1 + 1  ; Interrupt Enable Register Control register (read and write)
kACE1_R2   .EQU     kACE1 + 2  ; FIFO Control     Register Control register (write)
;                              ; Interrupt Ident. Register Control register (read)
kACE1_R3   .EQU     kACE1 + 3  ; Line Control     Register (read and write)
kACE1_R4   .EQU     kACE1 + 4  ; Modem Control    Register (read and write)
kACE1_R5   .EQU     kACE1 + 5  ; Line Status      Register (read)
kACE1_R6   .EQU     kACE1 + 6  ; Modem Status     Register (read)
kACE1_R7   .EQU     kACE1 + 7  ; Scratch          Register (read and write)

; Status (control) register bit numbers
kACERxRdy:  .EQU 0              ; Receive data available bit number
kACETxRdy:  .EQU 6              ; Transmit data empty bit number

            .CODE

; RC2014 serial ACE initialise
;   On entry: No parameters required
;   On exit:  Z flagged if device is found and initialised
;             AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
; If the device is found it is initialised
; First look to see if the device is present
; SEE IF UART IS THERE BY CHECKING DLAB FUNCTIONALITY
RC2014_SerialACE1_Initialise:
            LD	A,080H          ;DLAB BIT ON
            OUT (kACE1_R3),A    ;OUTPUT TO LCR (DLAB REGS NOW ACTIVE)
            LD	A,04H           ;DIVISOR_LOW
            OUT (kACE1_R0),A    ;OUTPUT TO DLM
            LD	A,00H           ;DIVISOR_HIGH
            OUT (kACE1_R1),A    ;OUTPUT DIVISOR_HIGH
            IN  A,(kACE1_R0)    ;READ IT BACK
            CP  04H			;CHECK VALUE
            RET  NZ             ;Return not found NZ flagged Device NOT found
            LD	A,03H           ;DIVISOR LOAD DISABLE Bit 7=0, 8 bits, No Parity, 1 stopbit
            OUT (kACE1_R3),A    ;OUTPUT TO LCR (DLAB REGS NOW INACTIVE)
            LD  A,02H           ; Enable RTS 
            OUT (kACE1_R4),A    ; Modem Control    Register (read and write)
            LD  A,087H          ; 06-no FIFO, 07-enable FIFO, bits 6,7 - fifo trigger 1(00) or 4(01) or 8(10) or 16(11)
            OUT (kACE1_R2),A    ; IFO Control     Register Control register (write)
            LD  A,00H           ; xxx1B=RXBUF int, xx1xB=TXBUF int, x1xxB=RXCHR int, 00H=POLLING
            OUT (kACE1_R1),A    ; Interrupt Enable Register Control register (read and write)
            XOR  A              ; Return success A=0 and Z flagged
            RET

; RC2014 serial ACE #1 input character
;   On entry: No parameters required
;   On exit:  A = Character input from the device
;             NZ flagged if character input
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
RC2014_SerialACE1_InputChar:
            IN   A,(kACE1_R5)   ; Line Status      Register (read)
            BIT  kACERxRdy,A    ; Receive byte available
            RET  Z              ; Return Z if no character
            IN   A,(kACE1_R0)   ; Read data byte
            RET


; RC2014 serial ACE #1 output character
;   On entry: A = Character to be output to the device
;   On exit:  If character output successful (eg. device was ready)
;               NZ flagged and A != 0
;             If character output failed (eg. device busy)
;               Z flagged and A = Character to output
;             BC DE HL IX IY I AF' BC' DE' HL' preserved
RC2014_SerialACE1_OutputChar:
            PUSH BC
            LD   C,kACE1_R5     ; Line Status      Register (read)
            IN   B,(C)          ;Read SIO control register
            BIT  kACETxRdy,B    ;Transmit register full?
            POP  BC
            RET  Z              ;Return Z as character not output
            OUT  (kACE1_R0),A   ;Write data byte
            OR   0xFF           ;Return success A=0xFF and NZ flagged
            RET

; Hardware: Set baud rate
;   On entry: No parameters required
;   On entry: A = Baud rate code
;             C = Console device number (1 to 6)
;   On exit:  IF successful: (ie. valid device and baud code)
;               A != 0 and NZ flagged
;             BC HL not specified
;             DE? IX IY I AF' BC' DE' HL' preserved
; A test is made for valid a device number and baud code.
;  +----------+--------------+---------------+---------------+
;  |  Serial  |   Baud rate  |    DIVISOR    |    DIVISOR    |
;  |    Baud  |        code  |     HIGH      |      LOW      |
;  +----------+--------------+---------------+---------------+
;  |  230400  |   1 or 0x23  |           00  |           02  |
;  |  115200  |   2 or 0x11  |           00  |           04  |
;  |   57600  |   3 or 0x57  |           00  |           08  |
;  |   38400  |   4 or 0x38  |           00  |           0C  |
;  |   19200  |   5 or 0x19  |           00  |           18  |
;  |   14400  |   6 or 0x14  |           00  |           20  |
;  |    9600  |   7 or 0x96  |           00  |           30  |
;  |    4800  |   8 or 0x48  |           00  |           60  |
;  |    2400  |   9 or 0x24  |           00  |           C0  |
;  |    1200  |  10 or 0x12  |           01  |           80  |
;  |     600  |  11 or 0x60  |           03  |           00  |
;  |     300  |  12 or 0x30  |           06  |           00  |
;  +----------+--------------+---------------+---------------+
RC2014_SerialACE1_Hardware_BaudSet:
; Search for baud rate in table
; A = Baud rate code  (not verified)
; C = Console device number (1 to 6)  (not verified)
            LD   HL,Hardware_BaudTable
            LD   B,12           ;Number of table entries
@Search:    CP   (HL)           ;Record for required baud rate?
            INC  HL             ;point to DIVISOR_HIGH
            JR   Z,@Found       ;Yes, so Set Baud Rate
            INC  HL             ;point to DIVISOR_LOW
            INC  HL             ;Point to next record
            DJNZ @Search        ;Repeat until end of table
@Failed:    XOR  A              ;Return failure (A=0 and Z flagged)
            RET                 ;Abort as invalid baud rate
; Found location in table
; B = Baud code (1 to 11)  (verified)
; C = Console device number (1 to 6)  (not verified)
; (HL)   = Divisor High  (verified) 
; (HL)+1 = Divisor Low   (verified)
@Found:
            LD	A,080H          ;DLAB BIT ON
            OUT (kACE1_R3),A    ;OUTPUT TO LCR (DLAB REGS NOW ACTIVE)
            LD	A,(HL)          ;DIVISOR_HIGH FROM Hardware_BaudTable
            OUT (kACE1_R1),A    ;OUTPUT DIVISOR_HIGH
            INC HL              ; POINT TO DIVISOR_LOW
            LD	A,(HL)          ;DIVISOR_LOW FROM Hardware_BaudTable
            OUT (kACE1_R0),A    ;OUTPUT TO DLM
            LD	A,03H           ;DIVISOR LOAD DISABLE Bit 7=0, 8 bits, No Parity, 1 stopbit
            OUT (kACE1_R3),A    ;OUTPUT TO LCR (DLAB REGS NOW INACTIVE)
            OR   0xFF           ;Return success (A=0xFF and NZ flagged)
            RET
;
; 16550 (ACE) Baud DIVISOR HIGH / LOW FOR 7.3734 MHz Clock
; Baud rate table 
; Position in table matches value of short baud rate code (1 to 11)
; First column in the table is the long baud rate code
; Second column is the Divisor (16 bit)
;Hardware_BaudTable:
;            .DB  0x30,0x06,0x00     ;12 =    300 baud
;            .DB  0x60,0x03,0x00     ;11 =    600 baud
;            .DB  0x12,0x01,0x80     ;10 =   1200 baud
;            .DB  0x24,0x00,0xC0     ; 9 =   2400 baud
;            .DB  0x48,0x00,0x60     ; 8 =   4800 baud
;            .DB  0x96,0x00,0x30     ; 7 =   9600 baud
;            .DB  0x14,0x00,0x20     ; 6 =  14400 baud
;            .DB  0x19,0x00,0x18     ; 5 =  19200 baud
;            .DB  0x38,0x00,0x0C     ; 4 =  38400 baud
;            .DB  0x57,0x00,0x08     ; 3 =  57600 baud
;            .DB  0x11,0x00,0x04     ; 2 = 115200 baud
;            .DB  0x23,0x00,0x02     ; 1 = 230400 baud

;
; 16550 (ACE) Baud DIVISOR HIGH / LOW FOR 1,8432 MHz Clock
Hardware_BaudTable:
            .DB  0x30,0x01,0x80     ;12 =    300 baud
            .DB  0x60,0x00,0xC0     ;11 =    600 baud
            .DB  0x12,0x00,0x60     ;10 =   1200 baud
            .DB  0x24,0x00,0x30     ; 9 =   2400 baud
            .DB  0x48,0x00,0x18     ; 8 =   4800 baud
            .DB  0x96,0x00,0x0C     ; 7 =   9600 baud
            .DB  0x14,0x00,0x08     ; 6 =  14400 baud
            .DB  0x19,0x00,0x06     ; 5 =  19200 baud
            .DB  0x38,0x00,0x03     ; 4 =  38400 baud
            .DB  0x57,0x00,0x02     ; 3 =  57600 baud
            .DB  0x11,0x00,0x01     ; 2 = 115200 baud
            .DB  0x00,0x00,0x00     ; 1 = 230400 baud N/A
;


; **********************************************************************
; **  Private functions                                               **
; **********************************************************************





; **********************************************************************
; **  End of driver: RC2014, Serial 16550 ACE                         **
; **********************************************************************





