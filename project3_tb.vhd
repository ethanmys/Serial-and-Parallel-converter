--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:07:31 09/22/2011
-- Design Name:   
-- Module Name:   C:/fpgaclass/project2/project3_tb.vhd
-- Project Name:  project2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: project3
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY project3_tb IS
END project3_tb;
 
ARCHITECTURE behavior OF project3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT project3
    PORT(
         clk : IN  std_logic;
         data : IN  std_logic;
         capture : IN  std_logic;
         reset : IN  std_logic;
         odd : IN  std_logic;
         valid : OUT  std_logic;
         out_byte : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal data : std_logic := '0';
   signal capture : std_logic := '0';
   signal reset : std_logic := '0';
   signal odd : std_logic := '0';

 	--Outputs
   signal valid : std_logic;
   signal out_byte : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: project3 PORT MAP (
          clk => clk,
          data => data,
          capture => capture,
          reset => reset,
          odd => odd,
          valid => valid,
          out_byte => out_byte
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

		Odd<='0';
		reset<='1'; --initialize reset
		wait for 20 ns;
		reset<='0';
		capture<='0';
		wait for 100 ns;	
----------------------CHECK FOR EVEN BIT -----------------------------------
---------------------when odd=zero-------------------------------

		odd<='0';
		capture<='1';
		data<='1';
      wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 100ns;
		assert out_byte="01010101"
			report "Error on outbyte, MSB should be 0"
			severity error;
----------------------end of using odd=0 and start of odd='1'----------------------------			
		wait for 100 ns;
		reset <= '1';
		wait for 20 ns;
		reset <='0';
		odd<='1';
		capture<='1';
		data<='1';
      wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 100ns;
		assert out_byte="11010101"
			report "Error on outbyte, MSB should be 1"
			severity error;
---------------------end of using odd='1'---------------------------------------------------			
-----------------------END OF CHECK FOR EVEN BIT----------------------------------------------	
----------------------START OF CHECK FOR ODD BIT---------------------------------------
---------------------odd=zero-------------------------------
		wait for 100 ns;
		reset <= '1';
		wait for 20 ns;
		reset <='0';
		odd<='0';
		capture<='1';
		data<='1';
      wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 100ns;
		assert out_byte="11010111"
			report "Error on outbyte, MSB should be 1"
			severity error;
----------------------end of using odd=0 and start of odd='1'----------------------------			
		wait for 100 ns;
		reset <= '1';
		wait for 20 ns;
		reset <='0';
		odd<='1';
		capture<='1';
		data<='1';
      wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 10 ns;
		data<='0';
		wait for 10 ns;
		data<='1';
		wait for 100ns;
		assert out_byte="01010111"
			report "Error on outbyte, MSB should be 0"
			severity error;
---------------------end of using odd='1'------------------------------------------------
-----------------------END of checking for odd bit-----------------------------------

		--end of my stimulus and checking
		assert false
			report "End of testbench, no error"
			severity failure;
		
   end process;

END;
