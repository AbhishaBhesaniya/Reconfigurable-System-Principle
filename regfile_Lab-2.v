/* regfile.v:
 *
 * Register file for processor.
 * 
 * Contains 7 registers, and muxes to move the data in and out.
 * 
 * Programed BY: Abhisha Bhesaniya
 */

module REGFILE (
   // Outputs
   ABUS, BBUS,
   // Inputs
   ASEL, BSEL, DSEL, DIN, RIN, CLK, RST
   ) ;
   input [2:0]   ASEL,BSEL,DSEL;
   input [15:0]  DIN,RIN;
   output [15:0] ABUS,BBUS;
   input 	 CLK;
   input 	 RST;
   reg [15:0]R[1:7];
   reg [15:0]ABUS, BBUS;

//sequential block
always@(posedge CLK or negedge RST)
begin
        
	if(DSEL != 0)
	begin
		R[DSEL] = RIN; 
	end

	if (RST == 0) //if RST is 0 then make all the elements of register 0.
	begin
		R[1] = {16{1'b0}};
		R[2] = {16{1'b0}};
		R[3] = {16{1'b0}};
		R[4] = {16{1'b0}};
		R[5] = {16{1'b0}};
		R[6] = {16{1'b0}};
		R[7] = {16{1'b0}};
	end
end

//combinational block
always@(ASEL or BSEL or R[1] or R[2] or R[3] or R[4] or R[5] or R[6] or R[7] or DIN)//always@(*) 
begin
	ABUS = (ASEL == 0)?DIN[15:0]:R[ASEL];
	BBUS = (BSEL == 0)?DIN[15:0]:R[BSEL];
end
   
endmodule // REGFILE

