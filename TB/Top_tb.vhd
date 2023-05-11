library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
generic(
		bus_width : integer:=16;
		cmd_width : integer:=6;
		dept:   integer:=64
		);
end tb;

architecture rtb of tb is
	signal clk,rst,ena,memWriteTb,progWriteTb,tbActive,done: std_logic;	
	signal tbMemAddr,tbMemData,tbProgData,tbMemDataOut: std_logic_vector(bus_width-1 downto 0);
	signal tbProgAddr: std_logic_vector(cmd_width-1 downto 0);
	constant file_location_prog_init:string(1 to 61) := "C:\Users\orisa\source\modelSim\work\Memory_files\ITCMinit.txt";
	constant file_location_mem_init:string(1 to 61) := "C:\Users\orisa\source\modelSim\work\Memory_files\DTCMinit.txt";
	constant file_location_mem_content:string(1 to 64) := "C:\Users\orisa\source\modelSim\work\Memory_files\DTCMcontent.txt";
begin
	Top_portMap:Top port map(clk,rst,ena,memWriteTb,progWriteTb,tbActive,tbMemAddr,
		tbMemData,tbProgAddr,tbProgData,
		done,tbMemDataOut
		);
	 
	 gen_clk : process  -- clk process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
	gen_rst : process -- rst process
        begin
		  rst <= '1';
		  wait until tbActive='0';
		  rst <= '0';
		 wait;
        end process;
	
	
		read_progData: process -- read from file to program memory (init) process
		file infile : text open read_mode is file_location_prog_init; 
        variable L : line;
		variable line_entry : std_logic_vector(bus_width-1 downto 0);
		variable good : boolean;
		variable count : integer;
		
		begin
		  count:=0;
		  while  not endfile(infile) loop
			readline(infile,L);
			hread(L,line_entry);
			progWriteTb<='1';
			tbProgData<=line_entry;
			tbProgAddr<=conv_std_logic_vector(count,cmd_width);
			count := count+1;
			wait until clk='1';
		  end loop;
			progWriteTb<='0'; -- stop write
			file_close(infile);
		  wait;
        end process;
		
		
		read_write_memData: process
			file infile : text open read_mode is file_location_mem_init; 
			file outfile : text open write_mode is file_location_mem_content; 
			variable L : line;
			variable L_write : line;
			variable line_entry:std_logic_vector(bus_width-1 downto 0);
			variable count : integer;
			begin
				count:=0;
				while not endfile (infile) loop -- read mem data file and write to mem data
					readline(infile,L);
					hread(L,line_entry);
					memWriteTb<='1';
					tbActive<='1';
					tbMemData<=line_entry;
					tbMemAddr<=conv_std_logic_vector(count,bus_width);
					count := count+1;
					wait until clk='1';
				end loop;
				file_close(infile);
				tbActive<='0';
				memWriteTb<='0';
				ena<='1';
				wait until done='1';
				tbActive<='1';
				ena<='0';
				for i in 0 to dept-1 loop -- write memdata file from  mem data
					tbMemAddr<=conv_std_logic_vector(i,bus_width);
					wait until clk='0';
					hwrite(L_write,tbMemDataOut);
					writeline(outfile,L_write);
					wait until clk='1';
				end loop;
				file_close(outfile);
				tbActive<='0'; -- choose to take from bus
				ena<='1'; -- enable to start the states
			wait;
        end process;
		
	end rtb;	
		