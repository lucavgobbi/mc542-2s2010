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
	
component cu
	Generic (W : natural := 32);
	port(Op : in std_logic_vector(W -1 downto W -6);
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
	end component;
	
component alucontrol
	Generic (W : natural := 32);
	port(ALUOp : in std_logic_vector(1 downto 0);
		funct : in std_logic_vector(nbits - 27 downto 0);
		ALUControlD : out std_logic_vector(2 downto 0);
		USignedD : out std_logic;
		);
	end component;
	
	
	--Guarda o valor do PC atual + 4, do PC de Branch e do PC atual
	signal PCPlus4F, PCPlus4D, PCBranchM, PC : std_logic_vector(X-1 downto 0);
	--Signal auxiliar que contem o mesmo valor que a saida PCF
	signal PCFaux : std_logic_vector(X-1 downto 0);
	--Seletor do MUX do PC
	signal PCSrcD : std_logic; 
	--Guarda no Pipeline a Instrucao da InstructionMemory
	signal InstrD : std_logic_vector(X-1 downto 0);
	--Guarda o endereço com Sign Extend
	signal SignImmD, SignImmE : std_logic_vector(X-1 downto 0);
	--Guarda o endereco do registrador a ser escrito no rf
	signal WriteRegW : std_logic_vector (4 downto 0);
	--Guarda o valor a ser escrito no rf
	signal ResultW : std_logic_vector(X-1 downto 0);
	--Guarda o enable de escrita do rf
	signal RegWriteD, RegWriteE, RegWriteW : std_logic;
	--Guarda as saidas de letura do rf
	signal RD1, RD2, RD1E, RD2E : std_logic_vector(X-1 downto 0);
	--Guarda o sinal de selecao do mux seletor de registrador de destino do rf
	signal RegDstD, RegDstE : std_logic;
	--Guarda o sinal de selecao do mux seletor de entrada da alu
	signal ALUSrcD, ALUSrcE : std_logic;
	--Guarda o sinal que decide se ocorreu um Branch
	signal BranchD : std_logic;
	--Guarda o sinal de enable de write em memoria
	signal MemWriteD, MemWriteE : std_logic;
	--Guarda o seletor do que vai ser escrito no rf
	signal MemtoRegD, MemtoRegW, MemtoRegE : std_logic
	--Guarda se o jump vai ser executado
	signal JumpD : std_logic;
	--Liga o CU com o ALUControl
	signal AluOP : std_logic_vector (1 downto 0);
	--Guarda se foi feito um Jump com link
	signal LinkD, LinkE : std_logic;
	--Guarda o sinal de controle da ALU
	signal AluControlD, AluControlE : std_logic(2 downto 0);
	--Guarda se a operação é com ou sem sinal
	signal USignedD, USignedE : std_logic;
	--Guarda o possivel endereco de destino de uma gravacao no rf
	signal Rte, Rde : std_logic_vector (4 downto 0);
	
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
				 
	ControlUnit: cu
		 PORT MAP(Op 		  => InstrD (31 downto 25),
			      RegWriteD   => RegWriteD,
				  RegDstD     => RegDstD,
				  AluSrcD     => AluSrcD,
				  BranchD     => BranchD,
				  MemWriteD   => MemWriteD,
				  MemtoRegD   => MemtoRegD,
				  JumpD 	  => JumpD,
				  ALUOp  	  => AluOp,
				  LinkD		  => LinkD);
	
	AluControlUnit : alucontrol
		PORT MAP(ALUOp 		  => ALUOp,
				 funct 		  => InstrD (5 downto 0),
				 ALUControlD  => ALUControlD,
				 USignedD 	  => USignedD);
	
	PCmux : Process (PCPlus4F, PCsrcD, PCBranchD)
	begin
		Case PCsrcD is
			When '0' =>
				PC <= PCPlus4F;
			When '1' =>
				PC <= PCBranchD;
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
		if clk 'EVENT and clk = '1' then
			InstrD <= Instruction;
			PCPlus4D <= PCPlus4F;
		end if; 
	end InstructionMemoryPipeline;
	
	DataPipeline : Process (clk)
	begin
		if clk 'EVENT and clk = '1' then
			Rte 		<= InstrD (20 downto 16);
			Rde 		<= InstrD (15 downto 11);
			SignImmE 	<= SignImmD;
			RD1E 		<= RD1;
			RD2E 		<= RD2;
			RegWriteE	<= RegWriteD;
			MemtoWriteE	<= MemtoWriteD;
			MemWriteE	<= MemWriteD;
			AluControlE	<= AluControlD;
			AluSrcE		<= AluSrcD;
			RegDstE		<= RegDstD;
			LinkE		<= LinkD;
			USignedE	<= USignedD;
		end if;
	end DataPipeline;
	
	SignExtend : Process (InstrD)
	begin
		SignImmD(15 downto 0) <= InstrD(15 downto 0)
		SignImmD(31 downto 15) <= (31 downto 15 => InstrD(15));
	end SignExtend;
	
	PCSrcDGenerator : Process (RD1,RD2,BranchD)
	begin
		if RD1 = RD2 then
			PCSrcD <= BranchD;
		else
			PCSrcD <= '0'
		end if;
	end PCSrcDGenerator;
	
	PCBranchDGenerator : Process (InstrD, PCPlus4D)
	variable temp : std_logic_vector(31 downto 0);
	begin
		temp (17 downto 2) := InstrD(15 downto 0);
		temp (1 downto 0) := (1 downto 0 => '0');
		temp (31 downto 17) := (31 downto 17 => Instrd(15));
		PCBranchD <= std_logic_vector(signed(PCPlus4D) + signed(temp));
	end PCBranchDGenerator;
	
End behaviour;
