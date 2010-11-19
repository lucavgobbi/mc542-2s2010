LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

Entity RF is
	Generic(W : natural := 32);
	port(A1 : in std_logic_vector(4 downto 0);
		A2 : in std_logic_vector(4 downto 0);
		A3 : in std_logic_vector(4 downto 0);
		WD3 : in std_logic_vector(W-1 downto 0);
		clk : in std_logic;
		We3 : in std_logic;
		RD1 : out std_logic_vector(W-1 downto 0);
		RD2 : out std_logic_vector(W-1 downto 0));
End RF;

Architecture rtl of RF is
subtype register1 is std_logic_vector(W-1 downto 0);
type rbank is array(31 downto 0) of register1;
Signal registerbank : rbank;



Begin
	
	--Leitura assincrona
	Process(A1, A2, registerbank)
	Begin
		If(A1 = "00000") Then
			RD1 <= (others => '0');
		Else
			RD1 <= registerbank(to_integer(unsigned(A1)));
		End If;
		If(A2 = "00000") Then
			RD2 <= (others => '0');
		Else
			RD2 <= registerbank(to_integer(unsigned(A2)));
		End If;
	End Process;
		
	--Gravação sincrona
	Process(clk)
	Begin
		If(clk'EVENT AND clk = '1') Then
			If(We3 = '1') Then
				If(NOT(A3 = "00000")) Then
					registerbank(to_integer(unsigned(A3))) <= WD3;
				End If;
			End If;
		End If;
	End Process;
End rtl;