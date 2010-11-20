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
	signal PCPlus4F : std_logic_vector(X-1 downto 0);
Begin
	PCPlus4Fsum: sum32 PORT MAP(a=>PCF,b=>'00000000000000000000000000000100',CarryIn=>'0',Result=>PCPlus4F);
End behaviour;
