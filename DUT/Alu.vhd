library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
USE work.aux_package.all;
--------------------------------------------------------------
entity Alu is
generic( bus_width :=16;
		opc_width :=4);
port(	clk: in std_logic;	
		Alu_in: in std_logic_vector(bus_width-1 downto 0);
		A_in: in std_logic;	
		C_in: in std_logic;	
		--c_out_en: in std_logic;
		opc: in std_logic_vector(opc_width-1 downto 0);
		cout_value: out std_logic_vector(bus_width-1 downto 0);
		Cflag : out std_logic;
		Nflag : out std_logic;
		Zflag : out std_logic;
);
end Alu;
--------------------------------------------------------------
architecture alu_unit of Alu is

begin			   
  proc_alu:process(clk)
  variable reg_a:std_logic_vector(bus_width-1 downto 0);
  variable reg_b:std_logic_vector(bus_width-1 downto 0);
  variable res:std_logic_vector(bus_width-1 downto 0);
  VARIABLE carry : STD_LOGIC_VECTOR (bus_width DOWNTO 0);
  VARIABLE ones : STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
  VARIABLE zeroes : STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
  
  begin
	ones:=(others=>'1');
	zeroes:=(others=>'0');
	if (clk'event and clk='1' and A_in='1') then
	    reg_a:=Alu_in;
	elsif(clk'event and clk='1' and C_in='1') then
		cout_value<=res;
	else
		if(opc="0001" or opc="0010") then
			if(opc="0001") then
				carry(0) := '0';
				reg_b:= Alu_in
			else
				carry(0) := '1';
				reg_b:= Alu_in XOR ones;
			end if;
		
			FOR i IN 0 TO bus_width-1 LOOP
				res(i):= reg_a(i) XOR reg_b(i) XOR carry(i);
				carry(i+1) := (reg_a(i) AND reg_b(i)) OR (reg_a(i) AND
				carry(i)) OR (reg_b(i) AND carry(i));
			END LOOP;
			Cflag <= carry(bus_width);
		elsif(opc="0000") then
			null;
		end if;	
		if(res = zeroes) then
			Zflag<='1';
		end if;
		Nflag<= res(bus_width-1);
		
	end if;
  end process;
	
end alu_unit;
