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