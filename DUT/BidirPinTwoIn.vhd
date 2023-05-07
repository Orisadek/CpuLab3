library ieee;
use ieee.std_logic_1164.all;
library work;
USE work.aux_package.all;
-----------------------------------------------------------------
entity BidirPinTwoIn is
	generic( width: integer:=16 );
	port(   DoutBus: in std_logic_vector(width-1 downto 0);
			en:	in 	std_logic;
			secSignal: out std_logic_vector(width-1 downto 0);
			Din:out	std_logic_vector(width-1 downto 0);
			SecPin: inout std_logic_vector(width-1 downto 0);
			IOpin: inout std_logic_vector(width-1 downto 0)	
	);
end BidirPinTwoIn;

architecture comb of BidirPinTwoIn is
begin 
	Din  <= IOpin;
	IOpin <= DoutBus when(en='1') else (others => 'Z');
	secSignal<=SecPin;
end comb;

