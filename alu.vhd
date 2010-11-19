LIBRARY ieee;
        USE ieee.std_logic_1164.all;
        USE ieee.numeric_std.all;
        

Entity ALU is
	Generic(W : natural := 32);	
	port(SrcA, SrcB: in std_logic_vector(W-1 downto 0);
		 AluControl : in std_logic_vector(2 downto 0);
		 AluResult : out std_logic_vector(W-1 downto 0);
		 Overflow, Zero, CarryOut: out std_logic);		 
End ALU;

Architecture behaviour of ALU is
component sum32
	Generic (X : natural := 32);
	port (a, b: in std_logic_vector(X-1 downto 0);
		  CarryIn:in std_logic;
		  Result: out std_logic_vector(X-1 downto 0);
		  Overflow,CarryOut: out std_logic);
	end component;
signal sumresult,complementSrcB: std_logic_vector(W-1 downto 0);
signal AuxOverflow, AuxCarryOut: std_logic;
Begin
	Process(AluControl,SrcA,SrcB)
		begin
		if AluControl(2) = '1' then
			complementSrcB <= std_logic_vector(signed((not SrcB)) + 1);
		else
			complementSrcB <= SrcB;
		end if;
	end process;
	
	soma: sum32 PORT MAP(SrcA,complementSrcB,'0',sumresult,AuxOverflow,AuxCarryOut);
	
	Process(sumresult,SrcA,SrcB,AluControl)
	variable temp: std_logic_vector(W-1 downto 0);
	Begin
		Case AluControl is
			When "000" =>
				temp := SrcA and SrcB;				
			When "001" =>
				temp := SrcA or SrcB;
			When "010" => 
				temp := sumresult;
				Overflow <= AuxOverflow;
				CarryOut <= AuxCarryOut;
			When "100" =>
				temp := SrcA and (not SrcB);
			When "101" =>
				temp := SrcA or (not SrcB);
			When "110" => 
				temp := sumresult;
				Overflow <= AuxOverflow;
				CarryOut <= AuxCarryOut;
			When "111" => 
				if (signed(SrcA) < signed(SrcB)) then 
					temp := "11111111111111111111111111111111";
				else
					temp := "00000000000000000000000000000000";
				end if;
			When Others => null;
		End Case;
		if temp = "00000000000000000000000000000000" then
			Zero <= '1';
		else 
			Zero <= '0';
		end if;
		AluResult <= temp;
	End process;
End behaviour;

