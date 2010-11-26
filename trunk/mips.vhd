--#TODO: Implementar o comando de Jump usando Pipelines	

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

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
	
component rf
	Generic (W : natural := 32);
	port(A1 : in std_logic_vector(4 downto 0);
		A2 : in std_logic_vector(4 downto 0);
		A3 : in std_logic_vector(4 downto 0);
		WD3 : in std_logic_vector(W-1 downto 0);
		clk : in std_logic;
		We3 : in std_logic;
		RD1 : out std_logic_vector(W-1 downto 0);
		RD2 : out std_logic_vector(W-1 downto 0));
	end component;
	
	--Guarda o valor do PC atual + 4, do PC de Branch e do PC atual
	signal PCPlus4F, PCPlus4D, PCBranchM, PC : std_logic_vector(X-1 downto 0);
	--Signal auxiliar que contem o mesmo valor que a saida PCF
	signal PCFaux : std_logic_vector(X-1 downto 0);
	--Seletor do MUX do PC
	signal PCSrcM : std_logic; 
	--Guarda no Pipeline a Instrucao da InstructionMemory
	signal InstrD : std_logic_vector(X-1 downto 0);
	--Guarda o endereço com Sign Extend
	signal SignImmD : std_logic_vector(X-1 downto 0);
	--Guarda o endereco do registrador a ser escrito no rf
	signal WriteRegW : std_logic_vector (4 downto 0);
	--Guarda o valor a ser escrito no rf
	signal ResultW : std_logic_vector(X-1 downto 0);
	--Guarda o enable de escrita do rf
	signal RegWriteW : std_logic;
	--Guarda as saidas de letura do rf
	signal RD1, RD2 : std_logic_vector(X-1 downto 0);
	
Begin

	PCPlus4Fsum: sum32
		PORT MAP(a 		 => PCFaux,
				 b  	 => '00000000000000000000000000000100',
				 CarryIn => '0',
				 Result  => PCPlus4F);
	
	RegisterFile: rf 
		PORT MAP(A1		=> InstrD(25 downto 21),
				 A2		=> InstrD(20 downto 16),
				 A3		=> WriteRegW,
				 WD3	=> ResultW,
				 clk 	=> clk,
				 We3	=> RegWriteW,
				 RD1	=> RD1,
				 RD2	=> RD2);
	
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
	
	InstructionMemoryPipeline: Process (clk)
	begin
		if clk 'EVENT AND clk = '1' then
			InstrD <= Instruction;
			PCPlus4D <= PCPlus4F;
		end if; 
	end InstructionMemoryPipeline;
	
	SignExtend : Process (InstrD)
	begin
		SignImmD(15 downto 0) <= InstrD(15 downto 0)
		SignImmD(31 downto 15) <= (31 downto 15 => InstrD(15));
	end SignExtend;
	
End behaviour;
