library IEEE;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb is
generic(
		bus_width : integer:=16;
		cmd_width : integer:=6
		);
end tb;
---------------------------------------------------------
architecture rtb of tb is
	signal clk,rst,memWriteTb,progWriteTb,tbActive: std_logic;	
	signal tbMemAddr,tbMemData,tbProgData,tbMemDataOut: std_logic_vector(bus_width-1 downto 0);
	signal tbProgAddr: std_logic_vector(cmd_width-1 downto 0);
	signal IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr:std_logic;
	signal RFaddr,PCsel:std_logic_vector(1 downto 0);
	signal opc:std_logic_vector(3 downto 0);
	signal st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag:std_logic;	
begin
	L0 : Datapath  port map(
		clk,rst,memWriteTb,progWriteTb,tbActive,tbMemAddr,tbMemData,tbProgAddr,
		tbProgData,IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,
		MemIn,Mem_wr,RFaddr,PCsel,opc,st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,
		Cflag,Zflag,Nflag,tbMemDataOut
		);
    
	--------- start of stimulus section ------------------	
		gen_rst : process
        begin
		  rst <= '1';
		  wait for 700 ns;
		  rst <= '0';
		  wait;
        end process;
		
        gen_clk : process
        begin
		  clk <= '0';
		  wait for 50 ns;
		  clk <= '1';
		  wait for 50 ns;
        end process;
		
		prog_mem_proc: process
		begin
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',8=>'1',0=>'1',others=>'0'); -- mov 
			tbProgAddr<=(0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',9=>'1',3=>'1',others=>'0'); -- mov 
			tbProgAddr<=(1=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(8=>'1',9=>'1',5=>'1',0=>'1',others=>'0'); -- add 
			tbProgAddr<=(1=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			--tbProgData<=(14=>'1',0=>'1',others=>'0'); -- jmp 
			--tbProgAddr<=(2=>'1',others=>'0');
			--progWriteTb<='1';
			--wait for 100 ns;
			tbProgData<=(13=>'1',others=>'0'); -- nop
			tbProgAddr<=(2=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',12=>'1',10=>'1',4=>'1',0=>'1',others=>'0'); -- ld
			tbProgAddr<=(2=>'1',0=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			tbProgData<=(15=>'1',13=>'1',10=>'1',4=>'1',0=>'1',others=>'0'); -- st
			tbProgAddr<=(2=>'1',1=>'1',others=>'0');
			progWriteTb<='1';
			wait for 100 ns;
			progWriteTb<='0';
			tbProgAddr<=(others=>'0');
			tbProgData<=(others=>'0');
			wait;
		end process;
		
	data_mem_proc: process
		begin
			tbActive<='1';
			tbMemAddr<=(others=>'0');
			memWriteTb<='1';
			tbMemData<=(1=>'1',others=>'0');
			wait for 300 ns;
			--tbActive<='1';
			tbMemAddr<=(0=>'1',others=>'0');
			memWriteTb<='1';
			tbMemData<=(2=>'1',others=>'0');
			wait for 300 ns;
			tbMemAddr<=(1=>'1',others=>'0');
			memWriteTb<='1';
			tbMemData<=(3=>'1',others=>'0');
			wait for 300 ns;
			memWriteTb<='0';
			tbActive<='0';
			wait;
		end process;
		
		control_proc : process
		begin
			-------reset-------
				IRin<='0';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="10";
				opc<="0000";
			wait until rst='0';
			------fetch nop----------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			---------------decode nop----------------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='1';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="01";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			--ex nop----------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='1';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0001";
			wait for 100 ns; 
			--------------alu write back nop-------------------
				IRin<='0';
				RFin<='1';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='1';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="10";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns; 
			--fetch mov--------------------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			-- decode mov-------------------------------
		
			wait for 100 ns;
			-- mem a dir mov------------------------------------------
				IRin<='0';
				RFin<='1';
				RFout<='0';
				Imm1_in<='1';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="10";
				PCsel<="00";
				opc<="0000";	
			wait for 100 ns;
			--fetch mov--------------------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			-- decode mov-------------------------------
			
			wait for 100 ns;
			-- mem a dir mov------------------------------------------
				IRin<='0';
				RFin<='1';
				RFout<='0';
				Imm1_in<='1';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="10";
				PCsel<="00";
				opc<="0000";	
			wait for 100 ns;
			--fetch add----------------------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			--decode add-------------------------------------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='1';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="01";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			--ex add-----------------------------------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='1';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0001";
			wait for 100 ns; 
			--alu write back add----------------------------------------------
				IRin<='0';
				RFin<='1';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='1';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="10";
				PCsel<="00";
				opc<="0000";	
			wait for 100 ns; 
			
			-- fetch jmp------------------------
			--	IRin<='1';
			--	RFin<='0';
			--	RFout<='0';
			--	Imm1_in<='0';
			--	Imm2_in<='0';
			--	Ain<='0';
			--	PCin<='0';
			--	Cout<='0';
			--	Cin<='0';
			--	MemOut<='0';
			--	MemIn<='0';
			--	Mem_wr<='0';
			--	RFaddr<="00";
			--	PCsel<="00";
			--	opc<="0000";
			--wait for 100 ns; 
			-- decode jmp------------------------
			--wait for 100 ns; 
			-- branch--------------------------------
			--	IRin<='0';
			--	RFin<='0';
			--	RFout<='0';
			--	Imm1_in<='0';
			--	Imm2_in<='0';
			--	Ain<='0';
			--	PCin<='1';
			--	Cout<='0';
			--	Cin<='0';
			--	MemOut<='0';
			--	MemIn<='0';
			--	Mem_wr<='0';
			--	RFaddr<="00";
			--	PCsel<="01";
			--	opc<="0000";
			--wait for 100 ns; 
			------fetch nop----------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			---------------decode nop----------------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='1';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="01";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns;
			--ex nop----------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='1';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0001";
			wait for 100 ns; 
			--------------alu write back nop-------------------
				IRin<='0';
				RFin<='1';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='1';
				Cout<='1';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="10";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns; 
			-- fetch ld---------------------------------
				IRin<='1';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns; 
			-- decode ld -------------------------------
				IRin<='0';
				RFin<='0';
				RFout<='1';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='1';
				PCin<='0';
				Cout<='0';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="01";
				PCsel<="00";
				opc<="0000";
			wait for 100 ns; 
			-- memAdir ld-------------------------------
				IRin<='0';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='1';
				Ain<='0';
				PCin<='0';
				Cout<='0';
				Cin<='1';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0001";
			wait for 100 ns; 
			-- memRead--------------------------
				IRin<='0';
				RFin<='0';
				RFout<='0';
				Imm1_in<='0';
				Imm2_in<='0';
				Ain<='0';
				PCin<='0';
				Cout<='1';
				Cin<='0';
				MemOut<='0';
				MemIn<='0';
				Mem_wr<='0';
				RFaddr<="00";
				PCsel<="00";
				opc<="0000";	
			wait for 100 ns; 
			----MemWriteBack ld---------------
					IRin<='0';
					RFin<='1';
					RFout<='0';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='0';
					PCin<='1';
					Cout<='0';
					Cin<='0';
					MemOut<='1';
					MemIn<='0';
					Mem_wr<='0';
					RFaddr<="10";
					PCsel<="00";
					opc<="0000";
			wait for 100 ns; 
			-----fetch st-------------
			IRin<='1';
			RFin<='0';
			RFout<='0';
			Imm1_in<='0';
			Imm2_in<='0';
			Ain<='0';
			PCin<='0';
			Cout<='0';
			Cin<='0';
			MemOut<='0';
			MemIn<='0';
			Mem_wr<='0';
			RFaddr<="00";
			PCsel<="00";
			opc<="0000";
			wait for 100 ns;
			----------------decode st--------------------------
			IRin<='0';
					RFin<='0';
					RFout<='1';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='1';
					PCin<='0';
					Cout<='0';
					Cin<='0';
					MemOut<='0';
					MemIn<='0';
					Mem_wr<='0';
					RFaddr<="01";
					PCsel<="00";
					opc<="0000";
					wait for 100 ns;
			-----------------memAdir st ------------------------
			IRin<='0';
					RFin<='0';
					RFout<='0';
					Imm1_in<='0';
					Imm2_in<='1';
					Ain<='0';
					PCin<='0';
					Cout<='0';
					Cin<='1';
					MemOut<='0';
					MemIn<='0';
					Mem_wr<='0';
					RFaddr<="00";
					PCsel<="00";
					opc<="0001";
					wait for 100 ns;
		--------------------memWrite st--------------------------
					IRin<='0';
					RFin<='0';
					RFout<='0';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='0';
					PCin<='0';
					Cout<='1';
					Cin<='0';
					MemOut<='0';
					MemIn<='1';
					Mem_wr<='0';
					RFaddr<="00";
					PCsel<="00";
					opc<="0000";
					wait for 100 ns;
			-----------------MemWriteBack st--------------------------------
					IRin<='0';
					RFin<='0';
					RFout<='1';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='0';
					PCin<='1';
					Cout<='0';
					Cin<='0';
					MemOut<='0';
					MemIn<='0';
					Mem_wr<='1';
					RFaddr<="10";
					PCsel<="00";
					opc<="0000";
					wait for 100 ns;
				
        end process; 
		
		
		
		
end architecture rtb;
