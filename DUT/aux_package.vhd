LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package aux_package is

	component top is
		generic (n : positive := 8 ); 
		port(rst,clk : in std_logic);
		   
	end component;
	
	component Alu is
		generic(bus_width:integer := 16;
			 opc_width:integer :=4); 
		port( clk: std_logic;	
		Alu_in:std_logic_vector(bus_width-1 downto 0);
		A_in:std_logic;	
		C_in:std_logic;	
		--c_out_en: in std_logic;
		opc:  std_logic_vector(opc_width-1 downto 0);
		cout_value:  std_logic_vector(bus_width-1 downto 0);
		Cflag :  std_logic;
		Nflag :  std_logic;
		Zflag :  std_logic
		);
		   
	end component;

	component dataMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
		port(	clk,memEn:std_logic;	
				WmemData:std_logic_vector(Dwidth-1 downto 0);
				WmemAddr,RmemAddr:	std_logic_vector(Awidth-1 downto 0);
				RmemData:std_logic_vector(Dwidth-1 downto 0)
			);
	end component;
	
	component ProgMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
	port(clk,memEn:  std_logic;	
		 WmemData: std_logic_vector(Dwidth-1 downto 0);
		 WmemAddr,RmemAddr: std_logic_vector(Awidth-1 downto 0);
		 RmemData: std_logic_vector(Dwidth-1 downto 0)
		 );
	end component;

	component RF is
	generic( Dwidth: integer:=16;
			Awidth: integer:=4);
	port(clk,rst,WregEn: in std_logic;	
		WregData: std_logic_vector(Dwidth-1 downto 0);
		WregAddr,RregAddr: std_logic_vector(Awidth-1 downto 0);
		RregData: std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	component BidirPin is
	generic( width: integer:=16 );
	port(   Dout:std_logic_vector(width-1 downto 0);
			en:std_logic;
			Din:std_logic_vector(width-1 downto 0);
			IOpin:std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component Datapath is
		generic( bus_width:integer :=16;
			m:integer:=4; ------change
			n:integer:=4;------change
			control_width:integer:=15;
			status_width:integer:=13
			);
	port(	clk:  std_logic;	
		Prog_in:  std_logic_vector(m-1 downto 0);
		Data_out:  std_logic_vector(n-1 downto 0);	
		Data_in:  std_logic_vector(n-1 downto 0);	
		Control: std_logic_vector(control_width-1 downto 0);
		Status: std_logic_vector(status_width-1 downto 0)
		);
	end component;
	
	component ControlUnit is
		generic( bus_width:integer :=16;
			control_width:integer:=15;
			status_width:integer:=13);
		port(	clk,rst,ena: std_logic;	
			done: std_logic;	
			Control:std_logic_vector(control_width-1 downto 0);
			Status:std_logic_vector(status_width-1 downto 0)
			);
	end component;

  
end aux_package;

