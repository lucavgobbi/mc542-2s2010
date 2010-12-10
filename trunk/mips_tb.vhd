LIBRARY ieee ;
USE ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;



entity mips_tb is
	
end mips_tb;

architecture behavior of mips_tb is
	constant clk_period : time := 100 ns;  -- Clock period
	constant delta : time := clk_period / 10;  -- Delta time to assert the inputs
	file InFile: text open read_mode is "mips.input";  -- Input file
	file OutFile: text open write_mode is "mips.output";	-- Output file
	file FullFile: text open write_mode is "mips.full.output";  -- Full output
	signal end_of_file: boolean;  -- End of File indicator
	signal iclk: std_logic := '0';	-- Internal Clock (testbench only)
	signal iresetn: std_logic;	-- Internal Resetn (testbench only)
	signal Instruction, Data, PCF, ALUOutM, WriteDataM : std_logic_vector(31 downto 0);
	signal clk, reset, MemWriteM: std_logic;
	
	component mips 
	generic(nbits : positive := 32);
	port(Instruction : in std_logic_vector(nbits -1 downto 0);
		Data : in std_logic_vector(nbits -1 downto 0);
		clk : in std_logic;
		reset : in std_logic;
		PCF : out std_logic_vector(nbits -1 downto 0);
		ALUOutM : out std_logic_vector(nbits -1 downto 0);
		WriteDataM : out std_logic_vector(nbits -1 downto 0);
		MemWriteM : out std_logic);
	end component;

begin  -- behavior

	iclk <= not iclk after clk_period / 2;
	iresetn <= '0', '1' after 7 * clk_period;

	mips0: mips
		port map (
			Instruction		=> 	Instruction,
			Data			=>	Data,
			clk				=> 	clk,
			reset			=>	reset,
			PCF				=>	PCF,
			ALUOutM			=>	ALUOutM,
			WriteDataM		=>	WriteDataM,
			MemWriteM		=>  MemWriteM);
	
	ReadInput : process(iClk, iResetn)
		variable input_line			: line;
		variable Instruction_value	: std_logic_vector(31 downto 0);
		variable Data_value 		: std_logic_vector(31 downto 0);
		variable reset_value		: std_logic;
	begin	-- process ReadInput
		if (iResetn = '0') then
			end_of_file <= false;
		elsif iClk'EVENT and iClk = '0' then
			if EndFile(InFile) then
				end_of_file <= true; -- stop when reaches end of file
			else
				ReadLine(InFile, input_line);
				Read(input_line, Instruction_value);
				Read(input_line, Data_value);
				Read(input_line, reset_value);
				Instruction <= Instruction_value;-- after delta;
				Data <= Data_value;-- after delta;
				reset <= reset_value;-- after delta;
			end if;
		end if;
	end process ReadInput;

	-- Writes a simple output report
	WriteOutput: process(iClk, iResetn)
		variable output_line: line;
		variable command: character;  --Input command
	begin	-- process WriteInput
		if (iResetn = '0') then
			null;
		elsif iClk'EVENT and iClk = '0' then
			Write(output_line, now, left, 12);
			Write(output_line, PCF, left, 33);
			Write(output_line, ALUOutM, left, 33);
			Write(output_line, WriteDataM, left, 33);
			Write(output_line, MemWriteM, left, 2);
			WriteLine(OutFile, output_line);
		end if;
	end process WriteOutput;
	
	-- Writes an extende output report (including the input)
	WriteFull : process(iClk, iResetn)
		variable output_line: line;
		variable command: character;  -- Input command
	begin	-- process WriteFull
		if (iResetn = '0') then
			null;
		elsif iClk'EVENT and iClk = '0' then
			Write(output_line, now, left, 11);
			Write(output_line, Instruction, left, 33);
			Write(output_line, Data, left, 33);
			Write(output_line, clk, left, 2);
			Write(output_line, reset, left, 2);
			Write(output_line, PCF, left, 33);
			Write(output_line, ALUOutM, left, 33);
			Write(output_line, WriteDataM, left, 33);
			Write(output_line, MemWriteM, left, 2);
			WriteLine(OutFile, output_line);
		end if;
	end process WriteFull;

	-- stop the simulator when the end of file is reached
	assert not end_of_file report "End of Simulation" severity failure;

end behavior;