LIBRARY ieee ;
USE ieee.std_logic_1164.all;

Entity alucontrol is
	generic(nbits : positive := 32);
	port(AluOp : in std_logic_vector(1 downto 0);
		funct : in std_logic_vector(nbits - 27 downto 0);
		ALUControlD : out std_logic_vector(2 downto 0);
		);
End cu;

Architecture rtl of alucontrol is

Begin
	
	Process(AluOp)
	Begin
		Case AluOp is
			When "00" => --Add
				AluControlD <= "010";
			When "01" =>
				AluControlD <= "110";
			When "10" =>
				Case funct is
					When 
				
				End Case
			
			When Others => null
		End Case
	End
	
End
