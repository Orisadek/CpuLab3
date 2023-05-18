library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity ControlUnit is
generic( bus_width: integer :=16
		
		);
port(	clk,rst,ena: in std_logic;	
		done: out std_logic;
		IRin,RFin,RFout,Imm1_in,Imm2_in,Ain,PCin,Cout,Cin,MemOut,MemIn,Mem_wr: out std_logic;
		RFaddr,PCsel: out std_logic_vector(1 downto 0);
		opc:out std_logic_vector(3 downto 0);
		st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag,jn:in std_logic
	);
end ControlUnit;
--------------------------------------------------------------
--Status
--- 0-st,1-ld,2-mov,3-done ,4- add,5-sub,6-jmp,7-jc,8-jnc,9-nop,10-Cflag,11-Zflag,12-Nflag
architecture control_unit of ControlUnit is
type state is (Reset,Fetch,Decode,Excute,AluWriteBack,Branch,MemAdir,MemReadWrite,MemWriteBack);
signal pr_state,nx_state:state;

begin	
---------------------------Lower Section------------------------------------
mealy_seq:process(rst,clk)
begin
	if(rst='1') then
		pr_state<=Reset;
	elsif (clk'event and clk='1' and ena='1') then 
		pr_state<=nx_state;
	end if;
end process;

---------------------------Upper Section------------------------------------
mealy_comb:process(st,ld,mov,done_signal,add,sub,jmp,jc,jnc,nop,Cflag,Zflag,Nflag,pr_state,jn)
begin
	case pr_state is
-----------------------Reset------------------------------------------------
		when Reset=>
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
			done<='0';
			---- PCin='1',PCsel="10"
			nx_state<=Fetch;
-----------------------level 0------------------------------------------------
		when Fetch=>
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
			done<='0';
			---- IRin="1",PCin='0',Mem_wr = '0', others => dont care
			nx_state<=Decode;
-----------------------level 1------------------------------------------------
		when Decode =>
			if(nop='1' or add='1' or sub='1') then -- nop ,add ,sub
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
			---- RFaddr = "01",RFout ='1',Ain='1'
				nx_state<=Excute;
			elsif(jmp='1' or jc='1' or jnc='1' or jn='1') then --jmp,jc,jnc 
				nx_state<=Branch;
			elsif(ld='1' or st='1' or mov='1' or done_signal='1') then -- ld,st,mov,done
				if(ld='1' or st='1') then
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
				-----RFaddr ="01",RFout = '1',Ain='1'
				else
					IRin<='0';
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
				end if;
				nx_state <=MemAdir;
			end if;
-----------------------level 2------------------------------------------------
			
		when Excute=> -- nop ,add ,sub
			if(nop='1' or add='1') then -- nop ,add 
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
				-----RFaddr ="00" ,RFout = '1',OPC="0001",Cin='1'
			else 	--sub
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
					opc<="0010";
				----RFaddr ="00" ,RFout = '1',OPC="0010",Cin='1'
			end if;
			nx_state <= AluWriteBack;
			
		when Branch=>  --jmp,jc,jnc 
			if(jmp='1' or (jc='1' and  Cflag='1') or (jnc='1' and Cflag='0') or (jn='1'and Nflag='1'))then  --jmp,jc and c=1,jnc and c=0
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
					PCsel<="01";
					opc<="0000";
				-- PCin="1",PCsel="01"
			else
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
					PCsel<="00";
					opc<="0000";
				--- PCin="1",PCsel="00"
			end if;
			nx_state<=Fetch;
			
		when MemAdir=> -- st,ld,mov
			if(mov='1') then --mov
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
				---- RFaddr = "10",RFin ='1',Imm1='1',PCin='1',PCsel="00"
				nx_state<=Fetch;
			elsif(done_signal='1') then
				done<='1';
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
				PCsel<="00";
				opc<="0000";
				nx_state<=Fetch;
			else 				   --st,ld
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
				----Imm2='1',OPC="0001",Cin='1' ,PCsel="00"
				nx_state<=MemReadWrite;
			end if;
				
-----------------------level 3------------------------------------------------

		when AluWriteBack=>	 --add,sub,nop
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
			--- RFaddr ="10",RFin ='1',PCin='1',Cout = '1'
			nx_state<=Fetch;
			
		when MemReadWrite=> --ld,st
			if(st='1') then  -- st
					IRin<='0';
					RFin<='0';
					RFout<='0';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='0';
					PCin<='1';
					Cout<='1';
					Cin<='0';
					MemOut<='0';
					MemIn<='1';
					Mem_wr<='0';
					RFaddr<="00";
					PCsel<="00";
					opc<="0000";
				----Cout = '1',MemIn='1',PCin ='1'
			else --ld
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
				----Cout = '1'
			end if;
			nx_state<=MemWriteBack;
-----------------------level 4------------------------------------------------
		when MemWriteBack=> -- ld ,st
		if(st='1') then  -- st
					IRin<='0';
					RFin<='0';
					RFout<='1';
					Imm1_in<='0';
					Imm2_in<='0';
					Ain<='0';
					PCin<='0';
					Cout<='0';
					Cin<='0';
					MemOut<='0';
					MemIn<='0';
					Mem_wr<='1';
					RFaddr<="10";
					PCsel<="00";
					opc<="0000";
				---RFaddr="10",RFout='1',PCin='1',MEM_wr='1'
			else --ld
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
				----RFaddr="10",RFin='1',PCin='1',MemOut='1'
			end if;
			nx_state<=Fetch;
		end case;
end process;

end control_unit;
