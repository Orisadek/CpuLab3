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
		status_width: integer:=13
		);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal clk,rst,memWriteTb,progWriteTb,tbActive: std_logic;	
	signal tbMemAddr,tbMemData,tbProgData,tbMemDataOut: std_logic_vector(bus_width-1 downto 0);
	signal tbProgAddr: std_logic_vector(cmd_width-1 downto 0);
	signal Control: std_logic_vector(control_width-1 downto 0);
	signal Status: std_logic_vector(status_width-1 downto 0);
	
begin
	L0 : Datapath  port map(clk,rst,memWriteTb,progWriteTb,tbActive,tbMemAddr,tbMemData,tbProgAddr,
		tbProgData,Control,Status,tbMemDataOut);
    
	--------- start of stimulus section ------------------	
		gen_rst : process
        begin
		  rst <= '1';
		  wait for 500 ns;
		  rst <= '0';
		  wait;
        end process;
		
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= '1';
		  wait for 50 ns;
        end process;
		
		prog_mem_proc: process
		begin
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',8=>'1',0=>'1',others=>'0'); -- mov 
			tbProgAddr<=(0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',9=>'1',3=>'1',others=>'0'); -- mov 
			tbProgAddr<=(1=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(8=>'1',9=>'1',5=>'1',0=>'1',others=>'0'); -- add 
			tbProgAddr<=(1=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(14=>'1',others=>'0'); -- jmp 
			tbProgAddr<=(1=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(2=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',12=>'1',10=>'1',4=>'1',0=>'1',others=>'0'); -- ld
			tbProgAddr<=(2=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			progWriteTb<='0';
			wait;
		end process;
		
	data_mem_proc: process
		begin
			tbActive<='1';
			tbMemAddr<=(others=>'0');
			memWriteTb<='1';
			tbMemData<=(1=>'1',others=>'0');
			wait for 100 ns;
			tbActive<='1';
			tbMemAddr<=(0=>'1',others=>'0');
			memWriteTb<='1';
			tbMemData<=(2=>'1',others=>'0');
			wait for 100 ns;
			tbActive<='0';
			wait;
		end process;
		
		
		control_proc : process
		begin
			Control<=(0=>'1',others=>'0'); --fetch nop
			wait for 100 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0');  --decode nop
			wait for 100 ns;
			Control<=(4=>'1',11=>'1',14=>'1',others=>'0'); --ex nop
			wait for 100 ns; 
			Control<=(1=>'1',3=>'1',12=>'1',13=>'1',others=>'0'); --alu write back nop
			wait for 100 ns; 
			Control<=(0=>'1',others=>'0'); --fetch mov
			wait for 100 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0'); -- decode mov
			wait for 100 ns;
			Control<=(1=>'1',3=>'1',6=>'1',12=>'1',others=>'0'); -- mem a dir mov
			Control<=(0=>'1',others=>'0'); --fetch mov
			wait for 100 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0'); -- decode mov
			wait for 100 ns;
			Control<=(1=>'1',3=>'1',6=>'1',12=>'1',others=>'0'); -- mem a dir mov
			wait for 100 ns;
			Control<=(0=>'1',others=>'0'); --fetch add
			wait for 100 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0');  --decode add
			wait for 100 ns;
			Control<=(4=>'1',11=>'1',14=>'1',others=>'0'); --ex add
			wait for 100 ns; 
			Control<=(1=>'1',3=>'1',12=>'1',13=>'1',others=>'0'); --alu write back add
			wait for 100 ns; 
			Control<=(0=>'1',others=>'0'); -- fetch jmp
			wait for 100 ns; 
			Control<=(12=>'1',16=>'1',others=>'0'); -- branch
			wait for 100 ns; 
			Control<=(0=>'1',others=>'0'); --fetch nop
			wait for 100 ns;
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0');  --decode nop
			wait for 100 ns;
			Control<=(4=>'1',11=>'1',14=>'1',others=>'0'); --ex nop
			wait for 100 ns; 
			Control<=(1=>'1',3=>'1',12=>'1',13=>'1',others=>'0'); --alu write back nop
			wait for 100 ns; 
			Control<=(0=>'1',others=>'0'); -- fetch ld
			wait for 100 ns; 
			Control<=(2=>'1',4=>'1',7=>'1',others=>'0'); -- decode ld
			wait for 100 ns; 
			Control <=(5=>'1',11=>'1',14=>'1',others=>'0'); -- memAdir ld
			wait for 100 ns; 
			Control<=(13=>'1',others=>'0'); -- memRead
			wait for 100 ns; 
			Control<=(1=>'1',3=>'1',12=>'1',17=>'1',others=>'0'); -- MemWriteBack
			wait for 100 ns; 
			
        end process; 
		
		
		
		
end architecture rtb;
