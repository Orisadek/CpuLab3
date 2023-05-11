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
		IR_imm_len: integer:=5;
		I_type_sign_ex: integer:=8;
		J_type_sign_ex : integer:=4;
		Dwidth: integer:=16;
		Awidth: integer:=6;
		dept:   integer:=64
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
		IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr: in std_logic;
		RFaddr,PCsel: in std_logic_vector(1 downto 0);
		opc:in std_logic_vector(3 downto 0);
		st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag:out std_logic;
		tbMemDataOut:out std_logic_vector(bus_width-1 downto 0)
		);
end Datapath;

--------------------------------------------------------------

architecture datapath_unit of Datapath is
signal IR_bus,central_bus:std_logic_vector(bus_width-1 downto 0); -- מנסור הבאס
signal Alu_in,Alu_out:std_logic_vector(bus_width-1 downto 0);  -- Alu signals
signal RF_bus_in,RF_bus_out:std_logic_vector(bus_width-1 downto 0); -- register file signals
signal RFaddr_bus:std_logic_vector(RFaddr_width-1 downto 0); --register file bus
signal mem_signal_bus,mem_write_addr,mem_latch_addr,mem_out,mem_reg_out:std_logic_vector(bus_width-1 downto 0); -- mem signals
signal PC_signal:std_logic_vector(cmd_width-1 downto 0);  -- addr from Pc
signal IR:std_logic_vector(bus_width-1 downto 0);--  IR register
signal RmemAddr,memWAddr:std_logic_vector(Awidth-1 downto 0);
signal memData:std_logic_vector(bus_width-1 downto 0);
signal memEn :std_logic;

begin

-----------------------------Alu port map--------------------------------------
Bi_dir_alu: BidirPin generic map(bus_width) port map (
			Dout=>Alu_out,
			en=>Cout, -- Cout Control
			Din=>Alu_in,
			IOpin=>central_bus
			);
			
Alu_port_map : Alu generic map (bus_width,opc_width) port map(
		clk=>clk,
		Alu_in=>Alu_in,
		A_in=>Ain, -- Ain Control
		C_in=>Cin, --Cin Control
		opc=>opc, -- OPC Control
		cout_value=>Alu_out,
		Cflag=>Cflag, 
		Nflag=>Nflag,
		Zflag=>Zflag
		);
    
------------------------------RF port map--------------------------------------------
Bi_dir_RF: BidirPin generic map(bus_width) port map (
			Dout=>RF_bus_out,
			en=>RFout, -- RFout Control
			Din=>RF_bus_in,
			IOpin=>central_bus
			);
			
RF_port_map : RF  port map(
		clk=>clk,
		rst=>rst, 
		WregEn=>RFin, --RFin Control	
		WregData=>RF_bus_in,
		WregAddr=>RFaddr_bus,
		RregAddr=>RFaddr_bus,	
		RregData=>RF_bus_out
		);
		
------------------------------DataMem port map--------------------------------------
Bi_dir_Mem: BidirPin generic map(bus_width) port map (
			Dout=>mem_out,
			en=>MemOut, --Mem_out
			Din=>mem_signal_bus,
			IOpin=>central_bus
			);
		

dataMem_port_map : dataMem generic map(Dwidth,Awidth,dept) port map(
		clk=>clk,
		memEn=>memEn,--Mem_wr	
		WmemData=>memData,
		WmemAddr=>memWAddr,
		RmemAddr=>RmemAddr,
		RmemData=>mem_reg_out
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
		PCin=>PCin, --Pcin
		PCsel=>PCsel, --Pcsel
		AddToPc=>IR(IR_imm_len-1 downto 0), --IR(4...0) -- 
		ReadAddr=>PC_signal
		);
		

------------------------------DataMem Code--------------------------------------	
memEn<=memWriteTb when tbActive='1' else	  
		Mem_wr;

RmemAddr<=tbMemAddr(Awidth-1 downto 0) when tbActive='1' else
		mem_signal_bus(Awidth-1 downto 0);

memData<=tbMemData when tbActive='1' else	  
		mem_signal_bus;
		
memWAddr<=tbMemAddr(Awidth-1 downto 0) when tbActive='1' else	  
		mem_latch_addr(Awidth-1 downto 0);	
				
mem_latch_addr<=central_bus when MemIn='1' else --Mem_in
				unaffected;

				
tbMemDataOut<=mem_reg_out; ---out to the Tb

process(clk)
begin
	if(clk'event and clk='1')then
		mem_out<=mem_reg_out;
	end if;
end process;
-----------------------Fetch------------------------------------------------

process(clk,IRin)
  begin
	if(rst='1') then
	 IR<="1111000000000000";
	elsif (clk'event and clk='1' and IRin='1') then --IRin
	   IR<=IR_bus;
	 else
	 null;
	end if;
  end process;

st<='1'when IR(bus_width-1 downto 12)="1010" else
	'0';
ld<='1'when IR(bus_width-1 downto 12)="1001" else
	'0';
mov<='1'when IR(bus_width-1 downto 12)="1000" else
	'0';
done_signal<='1'when IR(bus_width-1 downto 12)="1011" else
	'0';
add<='1'when IR(bus_width-1 downto 12)="0000" else
	'0'; 
sub<='1'when IR(bus_width-1 downto 12)="0001" else
	'0';
jmp<='1'when IR(bus_width-1 downto 12)="0100" else
	'0'; 
jc<='1'when IR(bus_width-1 downto 12)="0101" else
	'0'; 
jnc<='1'when IR(bus_width-1 downto 12)="0110" else
	'0'; 
nop<='1'when IR(bus_width-1 downto 12)="0010" else
	'0'; 


	

-----------------------------RFaddr-----------------------------------------------------------------------------
RFaddr_bus<=IR(11 downto 8) when RFaddr = "10" else ---Ra 
		IR(7 downto 4) when RFaddr = "01" else ---Rb 
		IR(3 downto 0) when RFaddr = "00" else ---Rc
		unaffected;

---------------------------------sign ext-------------------------------------------------------------------------

central_bus <= (15 downto 4 =>'0')&IR(J_type_sign_ex-1 downto 0) when(Imm2_in='1') else   --Imm2_in sign ext 
			   (15 downto 8 =>'0')&IR(I_type_sign_ex-1 downto 0) when(Imm1_in='1') else ---Imm1_in sign ext 
			   (others => 'Z'); --high z 
			   


end datapath_unit;

