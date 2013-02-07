----------------------------------------------------------------------------------
--Name: Chuan Lim Kho
-- Design name: Project 3
-- Design Overview: Serial to parallel converter for 8 bit data and one bit parity
-- Parity can either be odd or even
-- Produces a 'valid' signal as well as a bad_parity, when data is output
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project3 is
port(	clk: in std_logic;
		data:in std_logic;
		capture: in std_logic;
		reset: in std_logic;
		odd: in std_logic;
		valid: out std_logic;
		out_byte: out std_logic_vector(7 downto 0));
end project3;

architecture Behavioral of project3 is
	signal outser: std_logic_vector(6 downto 0);
	signal outpar: std_logic_vector(7 downto 0);
	signal counter: integer :=0;
	signal validsig: std_logic; --internal signal for valid

begin
---serial input block------
ser_in: process(clk,capture,reset,counter)
begin
	if reset='1' then
		counter <= 0;
		outser <="0000000";
	elsif clk'event and clk='1' then
			if (counter<7) and capture='1' then
				outser(counter)<=data;
				counter<=counter+1;
			end if;
	end if;
end process ser_in;
--------------------------parity generator------------------------
par_gen: process(odd, capture,outser,reset,counter)
	variable result: std_logic;
	variable i: integer;
begin
	result :='0';
	if capture='1' and counter=7 then 
		for i in 6 downto 0 loop
			result :=result xor outser(i);
			outpar(i)<=outser(i);
		end loop;
		--determining parity bit
			if odd='1' and counter=7 then
					if result='0' then----if even
						outpar(7)<='1'; --make it to odd
						validsig<= '1';
					else 
						outpar(7)<='0';  --if odd,insert zero on MSB
						validsig<= '1';
					end if;

			elsif odd='0' and counter=7 then
					if result='0' then----if even
						outpar(7)<='0'; --insert zero on MSB
						validsig<= '1';
					else 
						outpar(7)<='1';  --if odd,make it to even
						validsig<= '1';
					end if;			
			else
					null;
			end if;
----------reset feature-------------			
	elsif reset='1' then
			outpar <= "00000000";
			validsig <= '0';
	else
		null;
	end if;
end process par_gen;

--------D flipflop for outbyte--------------------
process (clk)
begin
   if clk'event and clk='1' then  
      if reset='1' then   
         out_byte <= "00000000";
      else
			out_byte <=outpar;
      end if;
   end if;
end process;

-----valid flip flop--------------------------
process (clk)
begin
   if clk'event and clk='1' then  
		valid <= validsig;
	else
		null;
   end if;
end process;
end Behavioral;

