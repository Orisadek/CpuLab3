library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;


entity Top is
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
		done_val: out std_logic;
		tbMemDataOut:out std_logic_vector(bus_width-1 downto 0)		
	);
end Top;

architecture top_control of Top is

signal IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr: std_logic;
signal RFaddr,PCsel: std_logic_vector(1 downto 0);
signal opc:std_logic_vector(3 downto 0);
signal st,ld,mov,done,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag: std_logic;
signal memWriteTb,progWriteTb,tbActive:std_logic;
signal tbMemAddr,tbMemData,tbProgData:std_logic_vector(bus_width-1 downto 0);
signal tbProgAddr:std_logic_vector(cmd_width-1 downto 0);
signal tbMemDataOut:std_logic_vector(bus_width-1 downto 0);

begin
Control_portmap : Control generic map(bus_width) port map(clk,rst,ena,	
		done_val,IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,
		Cin,MemOut,MemIn,Mem_wr,RFaddr,PCsel,opc,
		st,ld,mov,done,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag
		);
Datapath_portmap : Datapath generic map(bus_width,cmd_width,opc_width,RFaddr_width,IR_imm_len,
		I_type_sign_ex,J_type_sign_ex,Dwidth,Awidth,dept) port map(clk,rst,memWriteTb,progWriteTb,
		tbActive,tbMemAddr,tbMemData,tbProgAddr,tbProgData,IRin,RFin,RFout,
		Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr,RFaddr,PCsel,opc,
		st,ld,mov,done,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag,tbMemDataOut
		);
		
		
end top_control;
