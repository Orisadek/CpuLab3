LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
-------------------------------------
ENTITY dataMemTop IS
  GENERIC (Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
  PORT ( 
		clk: in std_logic;	
		memWriteC:in std_logic;
		memWriteTb:in std_logic;
		tbActive:in std_logic;
		tbMem:in std_logic_vector(Dwidth-1 downto 0);
		tbAddr:in std_logic_vector(Dwidth-1 downto 0);
		busMem:in std_logic_vector(Dwidth-1 downto 0);
		busWAddr:in std_logic_vector(Dwidth-1 downto 0);
		outBus:out std_logic_vector(Dwidth-1 downto 0);
		);
END dataMemTop;

architecture data_mem_top of dataMemTop is
signal memEn std_logic;
signal memWAddr,memRAddr:std_logic_vector(Awidth-1 downto 0);
signal memData:std_logic_vector(Dwidth-1 downto 0);

begin
dataMem_port_map : dataMem  port map(
		clk=>clk,
		memEn=>memEn,--Mem_wr	
		WmemData=>memData,
		WmemAddr=>memWAddr,
		RmemAddr=>memRAddr,
		RmemData=>outBus
		);



memEn<=memWriteTb when tbActive='1' else
	   memWriteC;

memRAddr<=tbAddr(Awidth-1 downto 0) when tbActive='1' else	  
		  busMem(Awidth-1 downto 0);

memWAddr<=tbAddr(Awidth-1 downto 0) when tbActive='1' else	
		  busWAddr(Awidth-1 downto 0);
		  
memData<=tbMem when tbActive='1' else	
		 busMem;

end process;


end data_mem_top;