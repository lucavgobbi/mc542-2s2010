LIBRARY ieee ;
USE ieee.std_logic_1164.all;

Entity cu is
	generic(nbits : positive := 32);
	port(Op : in std_logic_vector(nbits -1 downto 6);
		Funct : in std_logic_vector(nbits 5 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		RegWriteD : out std_logic; 
		MentoRegD : out std_logic;
		MenWriteD : out std_logic;
		BranchD : out std_logic;
		AluControlD : out std_logic;
		AluSrcD : out std_logic;
		RegDstD : out std_logic;
		);
End cu;

Architecture rtl of cu is

Begin
	
	--Leitura assincrona
	Process(clk, Op, Funct)
	Begin
		If(clk'EVENT AND clk = '1') Then
			Case Funct is
				When "100011" => --Load
				When "101011" => --Store
				When "001000" => --Addi
				When "000010" => --j
				When "000011" => --jal
				When "000100" => --beq
			end Case;
		End If;
	End Process;
End rtl;