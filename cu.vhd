LIBRARY ieee ;
USE ieee.std_logic_1164.all;

Entity cu is
	generic(nbits : positive := 32);
	port(Op : in std_logic_vector(nbits -1 downto nbits -6);
		RegWriteD : out std_logic;
		RegDstD : out std_logic;
		AluSrcD : out std_logic;
		BranchD : out std_logic;
		MemWriteD : out std_logic;
		MemtoRegD : out std_logic;
		JumpD: out std_logic;
		ALUOp : out std_logic_vector(1 downto 0);
		LinkD: out std_logic;
		);
End cu;

Architecture rtl of cu is

Begin
	
	Process(Op)
	Begin
		Case Funct is
			When "100011" => --Load
				RegWriteD <= '1';
				RegDstD <= '0';
				AluSrcD <= '1';
				BranchD <= '0';
				MemWriteD <= '0';
				MentoRegD <= '1';
				ALUOp <= "00";
				JumpD <= '0';
				LinkD <= '0'
			When "101011" => --Store
				RegWriteD <= '0';
				RegDstD <= '0';
				AluSrcD <= '1';
				BranchD <= '0';
				MemWriteD <= '1';
				MentoRegD <= '0';
				ALUOp <= "00";
				JumpD <= '0';
				LinkD <= '0'
			When "001000" => --Addi
				RegWriteD <= '1';
				RegDstD <= '0';
				AluSrcD <= '1';
				BranchD <= '0';
				MemWriteD <= '0';
				MentoRegD <= '0';
				ALUOp <= "00";
				JumpD <= '0';
				LinkD <= '0'
			When "000010" => --j
				RegWriteD <= '0';
				RegDstD <= '0';
				AluSrcD <= '0';
				BranchD <= '0';
				MemWriteD <= '0';
				MentoRegD <= '0';
				ALUOp <= "00";
				JumpD <= '1';
				LinkD <= '0'
			When "000011" => --jal
				RegWriteD <= '1';
				RegDstD <= '0';
				AluSrcD <= '0';
				BranchD <= '0';
				MemWriteD <= '0';
				MentoRegD <= '0';
				ALUOp <= "00";
				JumpD <= '1';
				LinkD <= '1'
			When "000100" => --beq
				RegWriteD <= '0';
				RegDstD <= '0';
				AluSrcD <= '0';
				BranchD <= '1';
				MemWriteD <= '0';
				MentoRegD <= '0';
				ALUOp <= "01";
				JumpD <= '0';
				LinkD <= '0'
			When "000000" => --R Type
				RegWriteD <= '1';
				RegDstD <= '1';
				AluSrcD <= '0';
				BranchD <= '0';
				MemWriteD <= '0';
				MentoRegD <= '0';
				ALUOp <= "10";
				JumpD <= '0';		
				LinkD <= '0'
		end Case;
	End Process;
End rtl;