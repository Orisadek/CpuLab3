library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
USE work.aux_package.all;
--------------------------------------------------------------
entity Alu is
generic( bus_width : integer:=16;
		opc_width : integer:=4);
port(	clk: in std_logic;	
		Alu_in: in std_logic_vector(bus_width-1 downto 0);
		A_in: in std_logic;	
		C_in: in std_logic;	
		opc: in std_logic_vector(opc_width-1 downto 0);
		cout_value: out std_logic_vector(bus_width-1 downto 0);
		Cflag : out std_logic;
		Nflag : out std_logic;
		Zflag : out std_logic
);
end Alu;
--------------------------------------------------------------
architecture alu_unit of Alu is

begin			   
  proc_alu:process(clk)
  variable reg_a:std_logic_vector(bus_width-1 downto 0);
  variable reg_b:std_logic_vector(bus_width-1 downto 0);
  variable res:std_logic_vector(bus_width-1 downto 0);
  variable C_reg:std_logic_vector(bus_width-1 downto 0);
  variable carry : STD_LOGIC_VECTOR (bus_width DOWNTO 0);
  variable ones : STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
  variable zeroes : STD_LOGIC_VECTOR (bus_width-1 DOWNTO 0);
  
  begin
	ones:=(others=>'1');
	zeroes:=(others=>'0');
	if(clk'event and clk='0') then --- C get out to the bus in falling edge (master slave)
		cout_value<=C_reg;
	elsif(clk'event and clk='1') then -- if we want to do a math operation
	
		if(A_in='1') then
		 reg_a:=Alu_in;
		 end if;
		 
		if(opc="0001" or opc="0010") then -- add or sub
			if(opc="0001") then -- add
				carry(0) := '0';
				reg_b:= Alu_in;
			else
				carry(0) := '1'; -- sub
				reg_b:= Alu_in XOR ones;
			end if;
		
			FOR i IN 0 TO bus_width-1 LOOP -- an seq option for adder
				res(i):= reg_a(i) XOR reg_b(i) XOR carry(i);
				carry(i+1) := (reg_a(i) AND reg_b(i)) OR (reg_a(i) AND
				carry(i)) OR (reg_b(i) AND carry(i));
			END LOOP;
			Cflag <= carry(bus_width); -- carry
			if(res = zeroes) then --zeroes
				Zflag<='1';
			else
				Zflag<='0';
			end if;
			Nflag<= res(bus_width-1); -- if negative value
			
			if(C_in='1') then 
				C_reg:=res;
			end if;
		elsif(opc="0000") then -- do nothing
			null;
		end if;
		
		
		
	end if;
  end process;
	
end alu_unit;
