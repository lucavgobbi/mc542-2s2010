LIBRARY ieee ;
USE ieee.std_logic_1164.all;

Entity cu is
	generic(nbits : positive := 32);
	port(Op : in std_logic_vector(nbits -1 downto nbits -6);
		funct : in std_logic_vector(nbits - 27 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		RegWrite : out std_logic;
		RegDst : out std_logic;
		AluSrc : out std_logic;
		Branch : out std_logic;
		MemWrite : out std_logic;
		MemtoReg : out std_logic;
		Jump: out std_logic;
		ALUOp : out std_logic_vector(1 downto 0);
		);
End cu;

Architecture rtl of cu is

Begin
	
	Process(clk, Op)
	Begin
		If(clk'EVENT AND clk = '1') Then
			Case Funct is
				When "100011" => --Load
					RegWrite <= '1';
					RegDst <= '0';
					AluSrc <= '1';
					Branch <= '0';
					MemWrite <= '0';
					MentoReg <= '1';
					ALUOp <= "00";
					Jump <= '0';
				When "101011" => --Store
					RegWrite <= '0';
					RegDst <= '0';
					AluSrc <= '1';
					Branch <= '0';
					MemWrite <= '1';
					MentoReg <= '0';
					ALUOp <= "00";
					Jump <= '0';
				When "001000" => --Addi
					RegWrite <= '1';
					RegDst <= '0';
					AluSrc <= '1';
					Branch <= '0';
					MemWrite <= '0';
					MentoReg <= '0';
					ALUOp <= "00";
					Jump <= '0';
				When "000010" => --j
					RegWrite <= '0';
					RegDst <= '0';
					AluSrc <= '0';
					Branch <= '0';
					MemWrite <= '0';
					MentoReg <= '0';
					ALUOp <= "00";
					Jump <= '1';
				When "000011" => --jal
				When "000100" => --beq
					RegWrite <= '0';
					RegDst <= '0';
					AluSrc <= '0';
					Branch <= '1';
					MemWrite <= '0';
					MentoReg <= '0';
					ALUOp <= "01";
					Jump <= '0';
				When "000000" => --R Type
					RegWrite <= '1';
					RegDst <= '1';
					AluSrc <= '0';
					Branch <= '0';
					MemWrite <= '0';
					MentoReg <= '0';
					ALUOp <= "10";
					Jump <= '0';		
			end Case;
		End If;
	End Process;
End rtl;