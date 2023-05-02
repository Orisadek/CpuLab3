library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
	bus_width :=16;
	control_width:=20;
	status_width:=13;
	
end tb;
---------------------------------------------------------
architecture rtb of tb is
	--type matrix is array (0 to status_width) of std_logic_vector(status_width-1 downto 0);
	signal clk,rst,ena,done:std_logic;	
	signal Control:std_logic_vector(control_width-1 downto 0);
	signal Status:std_logic_vector(status_width-1 downto 0);
	--SIGNAL upperBound_options : matrix := ("10000000000010","01000000000000",);
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
			Status<=0:'1',10:'1',others=>'0';
			wait for 1000 ns;
			Status<=1:'1',11:'1',others=>'0';
			wait for 1000 ns;
			Status<=2:'1',12:'1',others=>'0';
			wait for 1000 ns;
			Status<=4:'1',others=>'0';
			wait for 1000 ns;
			Status<=5:'1',others=>'0';
			wait for 1000 ns;
			Status<=6:'1',others=>'0';
			wait for 1000 ns;
			Status<=7:'1',10:'1',others=>'0';
			wait for 1000 ns;
			Status<=7:'1',others=>'0';
			wait for 1000 ns;
			Status<=8:'1',10:'1',others=>'0';
			wait for 1000 ns;
			Status<=8:'1',others=>'0';
			wait for 1000 ns;
			Status<=9:'1',others=>'0';
			wait for 1000 ns;
		  end loop; 
        end process; 
		
		
		
		
end architecture rtb;
