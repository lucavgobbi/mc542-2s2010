LIBRARY ieee ;
USE ieee.std_logic_1164.all;

Entity mips is
	generic(nbits : positive := 32);
	port(Instruction : in std_logic_vector(nbits -1 downto 0);
		Data : in std_logic_vector(nbits -1 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		PCF : out std_logic_vector(nbits -1 downto 0);
		ALUOutM : out std_logic_vector(nbits -1 downto 0));
		WriteDataM : out std_logic_vector(nbits -1 downto 0);
		MemWriteM : out std_logic);
End mips;

Architecture behaviour of mips is

component sum32
	Generic (X : natural := 32);
	port (a, b: in std_logic_vector(X-1 downto 0);
		  CarryIn:in std_logic;
		  Result: out std_logic_vector(X-1 downto 0);
		  Overflow,CarryOut: out std_logic);
	end component;
	
	
	--Guarda o valor do PC atual + 4, do PC de Branch e do PC atual
	signal PCPlus4F, PCBranchM, PC : std_logic_vector(X-1 downto 0);
	--Signal auxiliar que contem o mesmo valor que a saida PCF
	signal PCFaux : std_logic_vector(X-1 downto 0);
	--Seletor do MUX do PC
	signal PCsrcM : std_logic; 
	
	
Begin
	PCPlus4Fsum: sum32 PORT MAP(a=>PCFaux,b=>'00000000000000000000000000000100',CarryIn=>'0',Result=>PCPlus4F);
	
	PCmux : Process (PCPlus4F, PCsrcM, PCBranchM)
	begin
		Case PCsrcM is
			When '0' =>
				PC <= PCPlus4F;
			When '1' =>
				PC <= PCBranchM;
			When others =>
				null;
		end Case;
	end PCmux;
	
	PCPipeline : Process (clk)
	begin
		if clk 'EVENT AND clk = '1' then
			PCF <= PC;
			PCFaux <= PC;
		end if; 
	end PCPipeline;
	
End behaviour;
