
-- alu.vhd:
-- 
-- Processor ALU block.  This block is purely
-- combinational.  It implements 16 ALU operations, controlled by the
-- FSEL input.
-- 
-- Edited by: Abhisha Bhesaniya
-- Date : 18th February, 2021


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;


entity ALU is
  port(
    ABUS : in unsigned(15 downto 0);
    BBUS : in unsigned(15 downto 0);
    FSEL : in std_logic_vector(3 downto 0);
    CIN  : in std_logic;

    C,Z,S,V : out std_logic;
    FOUT : out unsigned(15 downto 0)
    );
end ALU;

architecture RTL of ALU is
 --signal TEMPOUT : std_logic_vector(16 downto 0); 
begin
	process(FSEL,ABUS,BBUS,CIN)

	   variable TEMPOUT : unsigned(15 downto 0); -- creating varible to hold the FOUT data

	begin  
		case FSEL is
			when "0000" => FOUT <= ABUS;  -- TRANSFER ABUS
			               S <= ABUS(15); -- SIGN FLAG
			               C <= '0'; -- 
                                       if (ABUS = 0) then 
			                 Z <= '1'; -- ZERO FLAG
			               else			              
			                 Z <= '0'; -- ZERO FLAG
			               end if;
			               V <= '0'; --  OVERFLOW FLAG


			when "0001" => FOUT <= ABUS + 1; -- INCRIMENT ABUS BY 1 
			               TEMPOUT := ABUS + 1;
			               S <= TEMPOUT(15);
			               C <= '0';
			               if (ABUS + 1 = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
					V <= '0';
			               
			               
			when "0010" => FOUT <= ABUS - 1;-- DECREMENT BBUS BY 1		               
			               TEMPOUT := ABUS - 1;
			               S <= TEMPOUT(15);
			               C <= '0';
			               if (ABUS - 1 = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
			               V <= '0';


			when "0011" => if (CIN = '0') then -- ADD ABUS + BBUS + CIN
			               TEMPOUT := ( ABUS + BBUS + 0); 
			               else
			                 TEMPOUT := ( ABUS + BBUS + 1); 
			               end if; 
			                C <= '0';
					S <= TEMPOUT(15);
			               if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
					V <= (NOT ABUS(15) AND NOT BBUS(15) AND  FOUT(15)) OR ( ABUS(15) AND  BBUS(15) AND  NOT FOUT(15));
			               FOUT <= TEMPOUT;

			               
			when "0100" => TEMPOUT := ( ABUS - BBUS ); -- SUBTRACT ABUS - BBUS - CIN
			               S <= TEMPOUT(15);
			               if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;	
                                       V <= (NOT ABUS(15) AND NOT BBUS(15) AND  FOUT(15)) OR ( ABUS(15) AND  BBUS(15) AND  NOT FOUT(15));		           
			               FOUT <=TEMPOUT;


			when "0101" => TEMPOUT := ABUS AND BBUS; -- BITWISE ABUS AND BBUS
			               S <= TEMPOUT(15);
			               C  <= '0';
			               if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
                                       V <= '0'; 			           
			               FOUT <= TEMPOUT;
			  
			  
			  
			when "0110" => TEMPOUT := ABUS OR BBUS;  -- BITWISE ABUS OR BBUS
			               S <= TEMPOUT(15);
			               C  <= '0';
			               if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
                                       V <= '0';			           
			               FOUT <= TEMPOUT;
			  
			  
			  
			when "0111" => TEMPOUT := ABUS XOR BBUS; -- BITWISE ABUS XOR BBUS
			               S <= TEMPOUT(15);
			               C  <= '0';
			               if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
					V <= '0';			           
			               FOUT <= TEMPOUT;		  
			  
			  
			  
			when "1000" => TEMPOUT := NOT ABUS;  -- BITWISE NOT ABUS
			               S <= TEMPOUT(15);
			               C  <= '0';
	                 	       if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
				       V <= '0';			           
			               FOUT <= TEMPOUT;

			  
			when "1001" => C <= ABUS(15); -- SHIFT ABUS LEFT, C CONTAINS ABUS{15], FOUT[0] 
				       TEMPOUT:= ( ABUS(14 downto 0) & "0" );
				       S <= TEMPOUT(15);
				       if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
                                      V <= TEMPOUT(15) XOR ABUS(15); 
				      FOUT <= TEMPOUT;

			                            
			when "1010" => C <= ABUS(0); -- SHIFT ABUS RIGHT, C CONTAINS ABUS{0], FOUT[15] CONTAINS 0
				       TEMPOUT := ( "0" & ABUS(15 downto 1));  
                                       S <= TEMPOUT(15);
				       if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
                 			V <= TEMPOUT(15) XOR ABUS(15);
					FOUT <= TEMPOUT;
							
							
			
			when "1011" => C <= ABUS(0); -- ARITHMETIC SHIFT A RIGHT, BIT C CONTAINS ABUS[0]
				       TEMPOUT := ( ABUS(15) & ABUS(15 downto 1)); 
					S <= TEMPOUT(15);
					if (TEMPOUT = 0) then
			                 Z <= '1';
			                else			              
			                 Z <= '0';
			                end if;
					V <= TEMPOUT(15) XOR ABUS(15);
					FOUT <= TEMPOUT; 

			
			when "1100" => C <= TEMPOUT(15); -- ROTATE LEFT THROUGH CARRY, FOUT[0] CONTAINS CIN, C CONTAINS ABUS[15]
				       TEMPOUT:= ( ABUS(14 downto 0) & CIN );
				       S <= TEMPOUT(15);
				       if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
                                        V <= TEMPOUT(15) XOR ABUS(15);
				       FOUT <= TEMPOUT; 

			             
			when "1101" => C <= ABUS(0); -- ROTATE RIGHT THROUGH CARRY FOUT[15] CONTAINS CIN, C CONTAINS ABUS[0--FOUT <= TEMPOUT; 
					TEMPOUT:= ( CIN & ABUS(15 downto 1));
					S <= TEMPOUT(15);
					if (TEMPOUT = 0) then
			                 Z <= '1';
			               else			              
			                 Z <= '0';
			               end if;
					V <= TEMPOUT(15) XOR ABUS(15);
				       FOUT <= TEMPOUT; 

			
			when others => FOUT <= "XXXXXXXXXXXXXXXX";

                                      S <= '0';
                                      Z <= '0';
                                      C <= '0';
                                      V <= '0';
		end case;
	end process;
end architecture;



