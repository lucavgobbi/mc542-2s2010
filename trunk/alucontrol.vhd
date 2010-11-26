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
			When "01" => --Sub
				AluControlD <= "110";
			When "10" =>
				Case funct is
					When "100000" => --Add
						AluControlD <= "010";
					When "100010" => --Sub
						AluControlD <= "110";
					When "100100" => --And
						AluControlD <= "000";
					When "100101" => --Or
						AluControlD <= "001";
					When "101010" => --Slt
						AluControlD <= "111";
					When "100110" => --Xor
						AluControlD <= "011"
				End Case
			When Others => null
		End Case
	End
End
