library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
generic(
	bus_width : integer :=16;
	control_width: integer :=20;
	status_width: integer :=13
		);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal clk,rst,ena:std_logic;
	signal done:std_logic;	
	signal Control:std_logic_vector(control_width-1 downto 0);
	signal Status:std_logic_vector(status_width-1 downto 0);
	
begin
	L0 : ControlUnit generic map (bus_width,control_width,status_width) port map(clk,rst,ena,done,Control,Status);
    
	--------- start of stimulus section ------------------	
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		status_proc : process
		begin
			Status<=(0=>'1',10=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(1=>'1',11=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(2=>'1',12=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(4=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(5=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(6=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(7=>'1',10=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(7=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(8=>'1',10=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(8=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(9=>'1',others=>'0');
			wait for 1000 ns; 
        end process; 
		
		
		
		
end architecture rtb;
