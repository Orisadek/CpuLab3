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
signal toPc,PcOffset : std_logic_vector(cmd_width-1 downto 0); -- from PCsel to Pc
signal PcVal : std_logic_vector(cmd_width-1 downto 0); -- Pc value
signal incPc : std_logic_vector(cmd_width-1 downto 0); -- from Pc to Mux
signal reg_one,reg_IR : std_logic_vector(cmd_width downto 0); -- cout from fa
begin 
----------------------------------- add 1 to Pc--------------------------------------------
first_add1 : FA port map(
			xi => PcVal(0),
			yi => '1',
			cin => '0',
			s => incPc(0),
			cout => reg_one(0)
	);
	
	rest_add_1 : for i in 1 to cmd_width-1 generate
		chain : FA port map(
			xi => PcVal(i),
			yi => '0',
			cin => reg_one(i-1),
			s => incPc(i),
			cout => reg_one(i)
		);
		

-----------------------------------add To PC IR IMM-----------------------------------------------------------------
	first_add_IR : FA port map(
			xi => incPc(0),
			yi => '0',
			cin => '0',
			s => PcOffset(0),
			cout => reg_IR(0)
	);
	
	rest_add_IR : for i in 1 to cmd_width-1 generate
		chain : FA port map(
			xi => incPc(i),
			yi => AddToPc(i-1),
			cin => reg_IR(i-1),
			s => PcOffset(i),
			cout => reg_IR(i)
		);
	end generate;
---------------------------------------mux to PCsel--------------------------------------------------------------
toPc<=incPc when PCsel="00" else
	PcOffset when PCsel="01" else
	others=>'0' when PCsel="10" else
	unaffected;
	
----------------------------------------------------------------------------------------------------------------
PC_init:process(PCin)
begin
	if(PCin='1' and clk'event and clk='1') then 
		PcVal<=toPc;
	end if;
end process;

ReadAddr<=PcVal;

end comb;

