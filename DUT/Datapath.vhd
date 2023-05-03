library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
USE work.aux_package.all;
--------------------------------------------------------------

entity Datapath is
generic( bus_width : integer:=16;
		cmd_width : integer:=6;
		opc_width : integer:=4;
		RFaddr_width : integer:=4;
		control_width: integer:=20;
		status_width: integer:=13;
		IR_imm_len: integer:=5
		);
port(	clk: in std_logic;	
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
end Datapath;

--------------------------------------------------------------

architecture datapath_unit of Datapath is
signal IR_bus,central_bus:std_logic_vector(bus_width-1 downto 0); -- מנסור הבאס
signal Alu_in,Alu_out:std_logic_vector(bus_width-1 downto 0); 
signal RF_in,RF_out:std_logic_vector(bus_width-1 downto 0);
signal RFaddr:std_logic_vector(RFaddr_width-1 downto 0);
signal mem_in,mem_write_addr,mem_latch_addr,mem_out:std_logic_vector(bus_width-1 downto 0);
signal PC_signal:std_logic_vector(cmd_width-1 downto 0);
begin

-----------------------------Alu port map--------------------------------------
Bi_dir_alu: BidirPin generic map(bus_width) port map (
			Dout=>Alu_out,
			en=>Control(13), -- Cout Control
			Din=>Alu_in,
			IOpin=>central_bus
			);
			
Alu_port_map : Alu generic map (bus_width,opc_width) port map(
		clk=>clk,
		Alu_in=>Alu_in,
		A_in=>Control(7), -- Ain Control
		C_in=>Control(14), --Cin Control
		opc=>Control(8 downto 11), -- OPC Control
		cout_value=>Alu_out,
		Cflag=>Status(10), 
		Nflag=>Status(11),
		Zflag=>Status(12)
		);
    
------------------------------RF port map--------------------------------------------
Bi_dir_RF: BidirPin generic map(bus_width) port map (
			Dout=>RF_out,
			en=>Control(4), -- RFout Control
			Din=>RF_in,
			IOpin=>central_bus
			);
			
RF_port_map : RF  port map(
		clk=>clk,
		rst=>rst, 
		WregEn=>Control(3), --RFin Control	
		WregData=>RF_in,
		WregAddr=>RFaddr,
		RregAddr=>RFaddr,	
		RregData=>RF_out
		);
		
------------------------------DataMem port map--------------------------------------
Bi_dir_Mem: BidirPinTwoIn generic map(bus_width) port map (
			DoutBus=>mem_out,
			en=>Control(17),--Mem_out
			secSignal=>mem_write_addr,
			Din=>mem_in,
			SecPin=>mem_latch_addr,
			IOpin=>central_bus
			);
			
mem_port_map : dataMemTop  port map(
		clk=>clk,		
		memWriteC=>Control(19),--Mem_wr
		memWriteTb=>memWriteTb,
		tbActive=>tbActive,
		tbMem=>tbMemData,
		tbAddr=>tbMemAddr,
		busMem=>mem_in
		busWAddr=>mem_write_addr,
		outBus=>mem_out
		);
		

-----------------------------------ProgMem port map--------------------------------------------
			
prog_port_map : ProgMem  port map(
		clk=>clk,
		memEn=>progWriteTb,	
		WmemData=>tbProgData,
		WmemAddr=>tbProgAddr,
		RmemAddr=>PC_signal,
		RmemData=>IR_bus
		);
	

Pc_port_map : Pc port map(
		clk=>clk,
		PCin=>Control(12), --Pcin
		PCsel=>Control(16 downto 15), --Pcsel
		AddToPc=>IR_bus(IR_imm_len-1 downto 0), --IR(4...0)
		ReadAddr=>PC_signal
		);
		


------------------------------DataMem Code--------------------------------------		
mem_latch_addr<=central_bus when Control(18)='1' else --Mem_in
				unaffected;
tbMemDataOut<=mem_out; ---out to the Tb
			
-----------------------IR process------------------------------------------------

IR_decode:process(Control(0))
variable opc:std_logic_vector(len_of_op-1 downto 0);
begin
	if(Control(0)='1') then 
		
end process;


end datapath_unit;

