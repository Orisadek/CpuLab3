LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is

	component top is
		generic (n : positive := 8 ); 
		port(rst,clk : in std_logic);
		   
	end component;
	
	component Alu is
		generic ( bus_width: integer :=16;
				  opc_width: integer :=4); 
		port(	clk: in std_logic;	
		Alu_in: in std_logic_vector(bus_width-1 downto 0);
		A_in: in std_logic;	
		C_in: in std_logic;	
		--c_out_en: in std_logic;
		opc: in std_logic_vector(opc_width-1 downto 0);
		cout_value: out std_logic_vector(bus_width-1 downto 0);
		Cflag : out std_logic;
		Nflag : out std_logic;
		Zflag : out std_logic
		);
		   
	end component;

	component dataMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
		port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:in std_logic_vector(Awidth-1 downto 0);
			RmemData:out std_logic_vector(Dwidth-1 downto 0)
			);
	end component;
	
	component ProgMem is
	generic( Dwidth: integer:=16;
		 Awidth: integer:=6;
		 dept:   integer:=64);
		port(	clk,memEn: in std_logic;	
			WmemData:	in std_logic_vector(Dwidth-1 downto 0);
			WmemAddr,RmemAddr:in std_logic_vector(Awidth-1 downto 0);
			RmemData: out std_logic_vector(Dwidth-1 downto 0)
			);
	end component;

	component RF is
	generic( Dwidth: integer:=16;
			Awidth: integer:=4);
	port(	clk,rst,WregEn: in std_logic;	
			WregData:in std_logic_vector(Dwidth-1 downto 0);
			WregAddr,RregAddr:in std_logic_vector(Awidth-1 downto 0);
			RregData:out std_logic_vector(Dwidth-1 downto 0)
		);
	end component;
	
	component BidirPin is
	generic( width: integer:=16 );
		port(Dout:in std_logic_vector(width-1 downto 0);
			en:in std_logic;
			Din:out	std_logic_vector(width-1 downto 0);
			IOpin:inout std_logic_vector(width-1 downto 0)
			);
	end component;
	
	component Datapath is
		generic( bus_width: integer :=16;
			m: integer:=4; ---change
			n: integer:=4; --- same
			control_width: integer:=15;
			status_width: integer:=13
			);
	port(clk:in std_logic;	
		Prog_in:in std_logic_vector(m-1 downto 0);
		Data_out:out std_logic_vector(n-1 downto 0);	
		Data_in:in std_logic_vector(n-1 downto 0);	
		Control:in std_logic_vector(control_width-1 downto 0);
		Status:out std_logic_vector(status_width-1 downto 0)
		);
	end component;
	
	component ControlUnit is
		generic( bus_width: integer :=16;
				control_width: integer:=20;
				status_width: integer:=13);
		port(clk,rst,ena: in std_logic;	
			done: out std_logic;	
			Control:out std_logic_vector(control_width-1 downto 0);
			Status:in std_logic_vector(status_width-1 downto 0)
			);
	end component;

  
end aux_package;

