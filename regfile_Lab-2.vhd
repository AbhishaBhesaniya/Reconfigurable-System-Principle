-- regfile.vhd
--
--   Implementation of a register file.
-- 	edited by Simran Padaniya
 
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity REGFILE is
  port(
    ASEL, BSEL, DSEL : in unsigned(2 downto 0);
    RIN, DIN :         in unsigned(15 downto 0);
    ABUS, BBUS :       out unsigned(15 downto 0);
    CLK :              in std_logic;
    RST :              in std_logic
    );
end REGFILE;

architecture RTL of REGFILE is
type Reg is array (7 downto 1) of unsigned(15 downto 0);
signal R : Reg;    -- assigning REG to signal R 
begin
    -- sequential block
    process(CLK, RST)
    begin
	 -- checking at rising edge
    	if( rising_edge(CLK) ) then

		if ( DSEL /= "000")then

    			R(to_integer(DSEL)) <= RIN;

		end if;

	 	if (RST = '0') then

   		
        		R(1) <= (others => '0');
        		R(2) <= (others => '0');
        		R(3) <= (others => '0');
			R(4) <= (others => '0');
			R(5) <= (others => '0');
			R(6) <= (others => '0');
			R(7) <= (others => '0');
	

    		end if;

	end if;

    end process;
  
-- combinational block
   process( ASEL, BSEL, R, DIN)
   begin
       		-- converting ASEL to integer  in this block to comparing it with integer value.
		if(to_integer(ASEL) = 0) then  
			
			ABUS <= DIN;
  		else
			ABUS <= R(to_integer(ASEL));

		end if;

		if(to_integer(BSEL) = 0) then

			BBUS <= DIN;
				
  		else
			 BBUS <= R(to_integer(BSEL));	

		end if;

  
  
   end process;


end architecture;


