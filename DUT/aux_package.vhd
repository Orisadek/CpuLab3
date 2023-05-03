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
		port(clk,memEn: in std_logic;	
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
	generic( bus_width : integer:=16;
		cmd_width : integer:=6;
		opc_width : integer:=4;
		RFaddr_width : integer:=4;
		control_width: integer:=20;
		status_width: integer:=13;
		IR_imm_len: integer:=5
		);
	port(clk: in std_logic;	
		rst:in std_logic;
		memWriteTb:in std_logic;
		progWriteTb:in std_logic;
		tbActive:in std_logic;
		tbMemAddr:in std_logic_vector(bus_width-1 downto 0);
		tbMemData:in std_logic_vector(bus_width-1 downto 0);
		tbProgAddr:in std_logic_vector(cmd_width-1 downto 0);
		tbProgData:in std_logic_vector(bus_width-1 downto 0);
		Control:in std_logic_vector(control_width-1 downto 0);
		Status:out std_logic_vector(status_width-1 downto 0);
		tbMemDataOut:out std_logic_vector(bus_width-1 downto 0)
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

	component Pc is
	generic( width: integer:=16;
			immToPc: integer:=5;
			cmd_width: integer:=6;
			Pcsel_width: integer:=2);
	port(   clk:in std_logic;
			PCin:in std_logic;
			PCsel:in std_logic_vector(Pcsel_width-1 downto 0);
			AddToPc:in std_logic_vector(immToPc-1 downto 0);
			ReadAddr:out std_logic_vector(cmd_width-1 downto 0)
			);
	end component;
	
	component BidirPinTwoIn is
	generic( width: integer:=16 );
	port(   DoutBus: in std_logic_vector(width-1 downto 0);
			en:	in 	std_logic;
			secSignal: out std_logic_vector(width-1 downto 0);
			Din:out	std_logic_vector(width-1 downto 0);
			SecPin: inout std_logic_vector(width-1 downto 0);
			IOpin: inout std_logic_vector(width-1 downto 0)	
	);
	end component;
	
	component dataMemTop IS
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
	end component;
	

  
end aux_package;

