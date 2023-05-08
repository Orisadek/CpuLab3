library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity ControlUnit is
generic( bus_width: integer :=16;
		control_width: integer:=20;
		status_width: integer:=13);
port(	clk,rst,ena: in std_logic;	
		done: out std_logic;	
		Control:out std_logic_vector(control_width-1 downto 0);
		Status:in std_logic_vector(status_width-1 downto 0)
	);
end ControlUnit;
--------------------------------------------------------------
--Status
--- 0-st,1-ld,2-mov,3-done ,4- add,5-sub,6-jmp,7-jc,8-jnc,9-nop,10-Cflag,11-Zflag,12-Nflag
architecture control_unit of ControlUnit is
type state is (Reset,Fetch,Decode,Excute,AluWriteBack,Branch,MemAdir,MemReadWrite,MemWriteBack,Done);
signal pr_state,nx_state:state;

begin	
---------------------------Lower Section------------------------------------
mealy_seq:process(rst,clk)
begin
	if(rst='1') then
		pr_state<=Reset;
	elsif (clk'event and clk='1') then 
		pr_state<=nx_state;
	end if;
end process;

---------------------------Upper Section------------------------------------
mealy_comb:process(Status,pr_state)
begin
	case pr_state is
-----------------------Reset------------------------------------------------
		when Reset=>
			Control<=(12=>'1',15=>'1',others=>'0'); -- PCin='1',PCsel="10"
			nx_state<=Fetch;
-----------------------level 0------------------------------------------------
		when Fetch=>
			Control<=(0=>'1',others=>'0'); -- IRin="1",PCin='0',Mem_wr = '0', others => dont care
			nx_state<=Decode;
-----------------------level 1------------------------------------------------
		when Decode =>
			if(Status(4)='1' or Status(9)='1' or Status(5)='1') then -- nop ,add ,sub
				Control<=(2=>'1',4=>'1',7=>'1',others=>'0'); -- RFaddr = "01",RFout ='1',Ain='1'
				nx_state<=Excute;
			elsif(Status(6)='1' or Status(7)='1' or Status(8)='1') then --jmp,jc,jnc 
				nx_state<=Branch;
			elsif(Status(1)='1' or Status(0)='1' or Status(2)='1' or Status(3)='1') then -- ld,st,mov , done
				if(Status(3)='1') then 
					nx_state <=Done;
				end if;
				Control<=(2=>'1',4=>'1',7=>'1',others=>'0'); ---RFaddr ="01",RFout = '1',Ain='1'
				nx_state <=MemAdir;
			end if;
-----------------------level 2------------------------------------------------
		when Done=>
			done<='1';
			
		when Excute=> -- nop ,add ,sub
			if(Status(4)='1' or Status(9)='1') then -- nop ,add 
				Control<=(4=>'1',11=>'1',14=>'1',others=>'0');---RFaddr ="00" ,RFout = '1',OPC="0001",Cin='1'
			else 	--sub
				Control<=(4=>'1',10=>'1',14=>'1',others=>'0');---RFaddr ="00" ,RFout = '1',OPC="0010",Cin='1'
			end if;
			nx_state <= AluWriteBack;
			
		when Branch=>  --jmp,jc,jnc 
			if(Status(6)='1' or (Status(10)='1' and  Status(7)='1') or (Status(8)='1' and Status(10)='0'))then  --jmp,jc and c=1,jnc and c=0
				Control<=(12=>'1',16=>'1',others=>'0'); -- PCin="1",PCsel="01"
			else
				Control<=(12=>'1',others=>'0'); -- PCin="1",PCsel="00"
			end if;
			nx_state<=Fetch;
			
		when MemAdir=> -- st,ld,mov
			if(Status(2)='1') then --mov
				Control<=(1=>'1',3=>'1',6=>'1',12=>'1',others=>'0');-- RFaddr = "10",RFin ='1',Imm1='1',PCin='1',PCsel="00"
				nx_state<=Fetch;
			else 				   --st,ld
				Control <=(5=>'1',11=>'1',14=>'1',others=>'0'); ---Imm2='1',OPC="0001",Cin='1' ,PCsel="00"
				nx_state<=MemReadWrite;
			end if;
				
-----------------------level 3------------------------------------------------

		when AluWriteBack=>	 --add,sub,nop
			Control<=(1=>'1',3=>'1',12=>'1',13=>'1',others=>'0'); -- RFaddr ="10",RFin ='1',PCin='1',Cout = '1'
			nx_state<=Fetch;
			
		when MemReadWrite=> --ld,st
			if(Status(0)='1') then  -- st
				Control<=(13=>'1',18=>'1',12=>'1',others=>'0'); --Cout = '1',MemIn='1',PCin ='1'
			else --ld
				Control<=(13=>'1',others=>'0'); --Cout = '1'
			end if;
			nx_state<=MemWriteBack;
-----------------------level 4------------------------------------------------
		when MemWriteBack=> -- ld ,st
		if(Status(0)='1') then  -- st
				Control<=(1=>'1',4=>'1',12=>'1',19=>'1',others=>'0'); --RFaddr="10",RFout='1',PCin='1',MEM_wr='1'
			else --ld
				Control<=(1=>'1',3=>'1',12=>'1',17=>'1',others=>'0'); --RFaddr="10",RFin='1',PCin='1',MemOut='1'
			end if;
			nx_state<=Fetch;
		end case;
end process;

end control_unit;
