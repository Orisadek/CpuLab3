library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
USE work.aux_package.all;
--------------------------------------------------------------

entity Datapath is
generic( bus_width :=16;
		m:=;
		n:=;
		control_width:=15;
		status_width:=13
		);
port(	clk: in std_logic;	
		Prog_in: in std_logic_vector(m-1 downto 0);
		Data_out: out std_logic_vector(n-1 downto 0);	
		Data_in: in std_logic_vector(n-1 downto 0);	
		Control:in std_logic_vector(control_width-1 downto 0);
		Status:out std_logic_vector(status_width-1 downto 0);
		);
end Datapath;

--------------------------------------------------------------