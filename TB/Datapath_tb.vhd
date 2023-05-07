library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
generic(
		bus_width : integer:=16;
		cmd_width : integer:=6;
		control_width: integer:=20;
		status_width: integer:=13;
		);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	clk,rst,memWriteTb,progWriteTb,tbActive:  std_logic;	
	tbMemAddr,tbMemData,tbProgData,tbMemDataOut:in std_logic_vector(bus_width-1 downto 0);
	tbProgAddr: std_logic_vector(cmd_width-1 downto 0);
	Control: std_logic_vector(control_width-1 downto 0);
	Status: std_logic_vector(status_width-1 downto 0);
	
begin
	L0 : Datapath generic map () port map(clk,rst,memWriteTb,progWriteTb,tbActive,tbMemAddr,tbMemData,tbProgAddr,
		tbProgData,Control,Status,tbMemDataOut);
    
	--------- start of stimulus section ------------------	
		gen_rst : process
        begin
		  rst <= '1';
		  wait for 50 ns;
		  rst <= not rst;
		  wait;
        end process;
		
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		prog_mem_proc: process
		begin
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(15=>'1',8=>'1',0=>'1',others=>'0'); -- mov 
			tbProgAddr<=(0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(15=>'1',9=>'1',3=>'1',others=>'0'); -- mov 
			tbProgAddr<=(1=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(8=>'1',9=>'1',5=>'1',0=>'1',others=>'0'); -- add 
			tbProgAddr<=(1=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(14=>'1',,others=>'0'); -- jmp 
			tbProgAddr<=(1=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(2=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
			tbProgData<=(15=>'1',12=>'1',10=>'1',4=>'1',0=>'1',others=>'0'); -- ld
			tbProgAddr<=(2=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 200 ns;
		
		
		
		
		control_proc : process
		begin
			Control<=(0=>'1',others=>'0');
			wait for 1000 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0');
			wait for 1000 ns;
			Status<=(2=>'1',12=>'1',others=>'0');
			wait for 1000 ns;
			Control<=(4=>'1',11=>'1',14=>'1',others=>'0');
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
