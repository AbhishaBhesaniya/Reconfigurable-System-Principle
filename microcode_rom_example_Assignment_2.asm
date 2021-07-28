;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;File Name:  microcode_rom_example.asm
;;;
;;;Discription: this file has a code for DJNZ instruction.
;;;Edited By: Abhisha Bhesaniya
;;; 
;;;Date     :11th April, 2021
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

;;; Desired number of Address bits
DEPTH:	.equ 11			;

	
;;; Field Definitions

ASEL:	.field	3	unsigned		; Right input of ALU
BSEL:	.field	3	unsigned		; Left inpt of ALU
DSEL:	.field	3	unsigned		; Destination Register
FSEL:	.field  4	std_logic_vector	; ALU operation
UPDF:	.field  4	std_logic_vector	; Update flags
MUX1:	.field	1	std_logic		; Next Address Select
MUX2:	.field	4	unsigned		; Load/Increment select
DATA:	.field  16	unsigned		; Address/data field
MISC:	.field	6	std_logic_vector	; Misc Field
	
;;; Constant definitions
;;; ASEL, BSEL, DSEL fields
INP:	.equ	000b		; Select Input port
NONE:	.equ	000b		; No register write
R1:	.equ	001b		; Register 1
R2:	.equ	010b		; Register 2
R3:	.equ	011b		; Register 3
R4:	.equ	100b		; Register 4
R5:	.equ	101b		; Register 5
R6:	.equ	110b		; Register 6
R7:	.equ	111b		; Register 7
PC:	.equ    R7		; R7 is the PC
SP:	.equ 	R6		; R6 is the Stack Pointer

;;; FSEL ALU Selection Field 
TSA:	.equ	0000b ;  Transfer A 
INC:	.equ	0001b ;  Increment A by one
DEC:	.equ	0010b ;	 Decrement A by one
ADD:	.equ	0011b ;	 Add A+B
SUB:	.equ	0100b ;	 Subtract A-B
AND:	.equ	0101b ;	 A AND B
OR:	.equ	0110b ;	 A OR B
XOR:	.equ	0111b ;	 A XOR B
NOT:	.equ	1000b ;	 NOT A
SHL:	.equ	1001b ;	 Shift A left
SHR:	.equ	1010b ;	 Shift A right
ASR:	.equ	1011b ;	 Arithmetic Shift A right
RLC:	.equ	1100b ;	 Rotate Left through Carry
RRC:	.equ	1101b ;	 Rotate Right through Carry
RV1:	.equ	1110b ;	 Reserved 1
RV2:	.equ	1111b ;	 Reserved 2

;;; Update flags field
;;;             ZSCV
UPZ:	.equ 	1000b		; Update Z
UPS:	.equ 	0100b		; Update S
UPC:	.equ 	0010b		; Update C
UPV:	.equ 	0001b		; Update V
UPALL:	.equ    UPZ | UPS | UPC | UPV ; Update Z,S,C,V
UPZS:	.equ	UPZ | UPS	; Update Z,S
	

;;; MUX1 Field 
;;; 			Function
INT:	.equ    0b   ; Internal Address
EXT:	.equ	1b   ; External Address

;;; MUX2 Field
;;; 			Function
NEXT:	.equ 0000b ; 	Go to next address by incrementing CAR
LAD:	.equ 0001b ; 	Load address into CAR (Branch)
LC:	.equ 0010b ; 	Load on Carry = 1
LNC:	.equ 0011b ; 	Load on Carry = 0
LZ:	.equ 0100b ; 	Load on Zero = 1
LNZ:	.equ 0101b ; 	Load on Zero = 0
LS:	.equ 0110b ; 	Load on Sign = 1
LNS:	.equ 0111b ; 	Load on Sign = 0
LV:	.equ 1000b ;    Load on Overflow = 1
LNV:	.equ 1001b ;    Load on Overflow = 0
LLT:	.equ 1010b ;    Load on S XOR V, Signed Less than
LGE:	.equ 1011b ;    Load on Not S XOR V, Signed greater than or equal
	

;;; MISC Field
READ:	.equ 000001b ; Read Memory
WRITE:	.equ 000010b ; Write Memory
LDMAR:	.equ 000100b ; Load MAR
LDIR:	.equ 001000b ; Load IR
FETCH:	.equ 001001b ; Read an instruction into IR
DEREF:	.equ 000101b ; Read mem, and load MAR
RFMUX:	.equ 010000b ; Use IR as source for ASEL, BSEL, and DSEL
DMUX:	.equ 100000b ; Use the microcode data field as regfile DIN
	
	.module "MICROCODE_ROM"	;
        .org 0 ; 
	 ;;;INP  \ - \ R2   \ TSA \  UPALL  \ -   \ NEXT \   3 \ DMUX ;  
    	 ;;; - \ - \ - \ - \ - \ - \ - \ - \ - ;
       

        .org (1 << 3)	; 
        ;;; Micro code for DJNZ instruction start here
       
HERE:   R2  \ - \ R2 \ TSA \  UPALL  \ INT \ NEXT \  - \ - ; 	;;; TRANSFER R2 in R2 and update all register
	  -  \ -  \ -  \ - \  -  \ INT  \ LNZ \ L1 \ - ;	;;; check zero flag and move to next or L1 based on zero flag
	PC \ - \PC \INC\ - \ - \ - \  NEXT  \ - ;		;;; increment PC
        PC \ - \PC \INC\ - \ - \ LAD \  END  \ - ; 		;;; increment PC and return to set when zero is set 
L1:    	R2  \ - \ R2 \ DEC \  UPZ  \ INT \ NEXT \  - \ - ;	;;; decremen the R2 
	PC \ - \PC \INC\ - \ - \ - \  NEXT  \ - ;		;;; increment pc by 1
	PC \ - \- \-\ - \ - \- \  -  \ LDMAR ; 			;;; send the PC value to the MAR reg
        - \ - \- \-\ - \ - \- \  -  \ READ ; 			;;; read the memory pointed by MAR
	INP \ - \PC \TSA\ - \ INT \ - \ NEXT  \ READ ; 		;;; tranfer the address to the PC and return 
END:	-  \ -  \ -  \ - \  -  \ - \ LAD \ HERE \ - ;           ;;; move bake to here  

	;;; Micro code for DJNZ instruction ends here
	.org ((1<<DEPTH)-1) 	; Ensure we have at least DEPTH address bits
	- \ - \ - \ - \ - \ - \ - \ - \ - ;
	.end 			;