library ieee;
use ieee.std_logic_1164.all;
library work;
USE work.aux_package.all;
-----------------------------------------------------------------
entity Pc is
	generic( width: integer:=16;
			immToPc: integer:=5;
			cmd_width: integer:=6;
			Pcsel_width: integer:=2);
	port(   clk:in std_logic;
			PCin:in std_logic;
			PCsel:in std_logic_vector(Pcsel_width-1 downto 0);
			AddToPc:in std_logic_vector(immToPc-1 downto 0);
			ReadAddr:out std_logic_vector(cmd_width-1 downto 0);
			);
end Pc;

architecture comb of Pc is
begin 
	
end comb;

