LIBRARY ieee;
USE ieee.std_logic_1164.all;


package aux_package is


	
	component Alu is
		generic ( bus_width: integer :=16;
				  opc_width: integer :=4); 
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
		IR_imm_len: integer:=5;
		I_type_sign_ex: integer:=8;
		J_type_sign_ex : integer:=4
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
		IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr: in std_logic;
		RFaddr,PCsel: in std_logic_vector(1 downto 0);
		opc:in std_logic_vector(3 downto 0);
		st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag:out std_logic;
		tbMemDataOut:out std_logic_vector(bus_width-1 downto 0)
		);
	end component;
	
	component ControlUnit is
		generic( bus_width: integer :=16
				--control_width: integer:=20
				--status_width: integer:=13
				);
		port(clk,rst,ena: in std_logic;	
			done: out std_logic;	
			IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr: out std_logic;
			RFaddr,PCsel: out std_logic_vector(1 downto 0);
			opc:out std_logic_vector(3 downto 0);
			st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag:in std_logic
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
	
	component FA IS
	PORT (xi, yi, cin: IN std_logic;
			  s, cout: OUT std_logic);
	END component;

	component Top is
	generic( bus_width : integer:=16;
		cmd_width : integer:=6;
		opc_width : integer:=4;
		RFaddr_width : integer:=4;
		IR_imm_len: integer:=5;
		I_type_sign_ex: integer:=8;
		J_type_sign_ex : integer:=4;
		Dwidth: integer:=16;
		Awidth: integer:=6;
		dept:   integer:=64
		);
	port(	clk,rst,ena: in std_logic;	
		memWriteTb:in std_logic;
		progWriteTb:in std_logic;
		tbActive:in std_logic;
		tbMemAddr:in std_logic_vector(bus_width-1 downto 0);
		tbMemData:in std_logic_vector(bus_width-1 downto 0);
		tbProgAddr:in std_logic_vector(cmd_width-1 downto 0);
		tbProgData:in std_logic_vector(bus_width-1 downto 0);
		done: out std_logic;
		tbMemDataOut:out std_logic_vector(bus_width-1 downto 0)		
	);
	end component;
  
end aux_package;

