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
		IR_imm_len: integer:=5;
		I_type_sign_ex: integer:=8;
		J_type_sign_ex : integer:=4
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
signal Alu_in,Alu_out:std_logic_vector(bus_width-1 downto 0);  -- Alu signals
signal RF_in,RF_out:std_logic_vector(bus_width-1 downto 0); -- register file signals
signal RFaddr:std_logic_vector(RFaddr_width-1 downto 0); --register file bus
signal mem_in,mem_write_addr,mem_latch_addr,mem_out:std_logic_vector(bus_width-1 downto 0); -- mem signals
signal PC_signal:std_logic_vector(cmd_width-1 downto 0);  -- addr from Pc
signal IR:std_logic_vector(bus_width-1 downto 0);--  IR register
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
		AddToPc=>IR(IR_imm_len-1 downto 0), --IR(4...0) -- 
		ReadAddr=>PC_signal
		);
		


------------------------------DataMem Code--------------------------------------		
mem_latch_addr<=central_bus when Control(18)='1' else --Mem_in
				unaffected;
tbMemDataOut<=mem_out; ---out to the Tb
-----------------------Fetch------------------------------------------------

process(clk,Control(0))
  begin
	if (clk'event and clk='1' and Control(0)='1') then --IRin
	   IR<=IR_bus;
	 else
	 null;
	end if;
  end process;

Status<=(0=>'1',others=>'0') when IR(bus_width-1 downto 12)="1010" else --st
		(1=>'1',others=>'0') when IR(bus_width-1 downto 12)="1001" else --ld
		(2=>'1',others=>'0') when IR(bus_width-1 downto 12)="1000" else --mov
		(3=>'1',others=>'0') when IR(bus_width-1 downto 12)="1011" else --done
		(4=>'1',others=>'0') when IR(bus_width-1 downto 12)="0000" else --add
		(5=>'1',others=>'0') when IR(bus_width-1 downto 12)="0001" else --sub
		(6=>'1',others=>'0') when IR(bus_width-1 downto 12)="0100" else --jmp
		(7=>'1',others=>'0') when IR(bus_width-1 downto 12)="0101" else --jc
		(8=>'1',others=>'0') when IR(bus_width-1 downto 12)="0110" else --jnc
		(9=>'1',others=>'0') when IR(bus_width-1 downto 12)="0010" else --nop
		unaffected;

-----------------------------RFaddr-----------------------------------------------------------------------------
RFaddr<=IR(11 downto 8) when Control(2 downto 1) = "00" else ---Ra 
		IR(7 downto 4) when Control(2 downto 1) = "01" else ---Rb 
		IR(3 downto 0) when Control(2 downto 1) = "10" else ---Rc
		unaffected;

---------------------------------sign ext-------------------------------------------------------------------------

central_bus <= IR(J_type_sign_ex-1 downto 0) when(Control(5)='1') else   --Imm2_in sign ext 
			   IR(I_type_sign_ex-1 downto 0) when(Control(6)='1') else ---Imm1_in sign ext 
			   (others => 'Z'); --high z 
			   


end datapath_unit;

