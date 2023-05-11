library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
generic(
	bus_width : integer :=16
	--control_width: integer :=20;
	--status_width: integer :=13
		);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal clk,rst,ena:std_logic;
	signal done:std_logic;	
	signal IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr:  std_logic;
	signal RFaddr,PCsel:  std_logic_vector(1 downto 0);
	signal opc: std_logic_vector(3 downto 0);
	signal st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag: std_logic;
	
begin
	L0 : ControlUnit generic map (bus_width) port map(clk,rst,ena,done,
	IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr,
	RFaddr,PCsel,opc,st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag);
    
	--------- start of stimulus section ------------------	
		gen_rst : process
        begin
		  rst <= '1';
		  wait for 50 ns;
		  rst <= not rst;
		  ena<='1';
		  wait;
        end process;
		
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= not clk;
		  wait for 50 ns;
        end process;
		
		status_proc : process
		begin
			st<='1';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='1';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='1';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='1';
			Nflag<='0';
		
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='1';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='1';
			Nflag<='0';
			
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='1';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='1';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='1';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='1';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='1';
			jc<='0';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='1';
			jnc<='0';
			nop<='0';
			Cflag<='1';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='1';
			jnc<='0';
			nop<='0';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='1';
			nop<='0';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='1';
			nop<='0';
			Cflag<='1';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns; 
			st<='0';
			ld<='0';
			mov<='0';
			done_signal<='0';
			add<='0';
			sub<='0';
			jmp<='0';
			jc<='0';
			jnc<='0';
			nop<='1';
			Cflag<='0';
			Zflag<='0';
			Nflag<='0';
			wait for 1000 ns;
        end process; 
		
		
		
		
end architecture rtb;
