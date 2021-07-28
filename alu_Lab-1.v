/* alu.v: 
 * 
 * Processor ALU block.  This block is purely
 * combinational.  It implements 16 ALU operations, controlled by the
 * FSEL input.
 * edited by Simran Padaniya 
 */


module ALU (
   // Outputs
   FOUT, C, Z, S, V,
   // Inputs
   ABUS, BBUS, FSEL, CIN
   ) ;
   input  [15:0] ABUS,BBUS;          /* Data busses */
   input [3:0] 	 FSEL;	             /* Function select */
   input         CIN;                /* Carry in */
   output [15:0] FOUT;               /* Function out */
   output 	 C,Z,S,V;            /* Current status out */

   /* Reg for output so we can use them in always blocks. */
   reg [15:0] 	 FOUT;  /* output decalared as reg*/
   reg 		 C,Z,S,V; /*   output status flag as reg*/

reg [15:0]tempout; /* variable to store out temperoray */
reg temp; /* variable to store carry bit*/
always@(*)

begin
/* starting of a switch case for FSEL */
/* S = signal flag
   Z = zero flag
   C = carry flag 
   V = overflow flag   */

case(FSEL)

/*Case 1*/
4'b0000:begin //transfer ABUS
	tempout = ABUS;
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	C = 0;
	V = 0;
	FOUT=tempout;	/* assigning temperoray output to FOUT*/
	end 
/*Case 2*/
4'b0001:begin //increment ABUS
	{temp,tempout} = ABUS + 1;
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	C = temp;
	V = temp;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end
 
/*Case 3*/
4'b0010:begin //decrement ABUS
	tempout = ABUS - 1;
	S = tempout[15];
	Z = (tempout==0)?1:0;
	C = 0;
	V = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end
 
/*Case 4*/
4'b0011:begin //add ABUS ,BBUS & CIN
	{temp,tempout} = ABUS + BBUS + CIN;
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	C = temp;
	V = (ABUS[15] == BBUS[15]) ? ((tempout[15] == ABUS[15]) ? 0 : 1) : 0;
	FOUT = tempout;/* assigning temperoray output to FOUT*/
	end 

/*Case 5*/
4'b0100:begin //subs ABUS ,BBUS & CIN
	tempout = ABUS - BBUS - CIN;
	S = tempout[15];
	Z= (tempout == 0)?1:0;
	C = 0;
	V = ABUS[15]^BBUS[15];
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end
 
/*Case 6*/
4'b0101:begin //bitwise ABUS  AND BBUS 
	tempout = ABUS & BBUS;
	S = tempout[15];
	Z = (tempout==0)?1:0;
	C = 0;
	V = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end
 
/*Case 7*/
4'b0110:begin//bitwise ABUS OR BBUS 
	tempout = ABUS|BBUS;
	S = tempout[15];
	Z =(tempout == 0)?1:0;
	C = 0;
	V = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end
 
/*Csse 8*/
4'b0111:begin//bitwise ABUS XOR BBUS
	tempout = ABUS^BBUS;
	S = tempout[15];
	Z = (tempout == 0)?1'b1:1'b0;
	C = 0;
	V = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 9*/
4'b1000:begin//bitwise NOT ABUS 
	tempout = ~ABUS;
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	C = 0;
	V = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 10*/
4'b1001:begin//shift ABUS left,C contains ABUS[15],FOUT[0] contains 0 
	tempout = {ABUS[14:0],1'b0};
	C = ABUS[15];
	V = ABUS[15]^tempout[15];
	S = tempout[15];
	Z = (tempout==0)?1:0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 11*/
4'b1010:begin//shift ABUS right,C contains ABUS[0],FOUT[15] contains 0 
	tempout = {1'b0,ABUS[15:1]};
	C = ABUS[0];
	V = ABUS[15]^tempout[15];
	S = tempout[15];
	Z =(tempout == 0)?1:0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 12*/
4'b1011:begin//Arithmatic shift ABUS right ,C contain ABUS[0] 
	tempout = {ABUS[15],ABUS[15:1]};
	C = ABUS[0];
	V = ABUS[15]^tempout[15];
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 13*/
4'b1100:begin//Rotate Left through Carry ,FOUT[0] contain CIN ,C contain ABUS[15] 
	tempout = {ABUS[14:0],CIN};
	C = ABUS[15];
	V = ABUS[15]^tempout[15];
	S = tempout[15];
	Z = (tempout==0)?1:0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 14*/
4'b1101:begin//Rotate Right through Carry ,FOUT[15] contain CIN ,C contain ABUS[0] 
	tempout = {CIN,ABUS[15:1]};
	C = ABUS[0];
	V = ABUS[15]^tempout[15];
	S = tempout[15];
	Z = (tempout == 0)?1:0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 15*/
4'b1110:begin//Reserved 1 for custom operation
	tempout = {16*1'bX};
	C = 0;
	V = 0;
	S = 0;
	Z = 0;
	FOUT = tempout;	/* assigning temperoray output to FOUT*/
	end

/*Case 16*/
4'b1111:begin//Reserved 2 for custom operation
	tempout = {16*1'bX};
	S = 0;
	Z = 0;
	C = 0;
	V = 0;
	FOUT = tempout;/* assigning temperoray output to FOUT*/
	end

endcase
/* end of switch case*/ 
end 
endmodule 

