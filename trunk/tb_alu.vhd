library std;
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_textio.all;
	use ieee.numeric_std.all;
	use std.textio.all;

entity tb_alu is
	
end tb_alu;

architecture behavior of tb_alu is
	constant clk_period : time := 100 ns;  -- Clock period
	constant delta : time := clk_period / 10;  -- Delta time to assert the inputs
	file InFile: text open read_mode is "alu.input";  -- Input file
	file OutFile: text open write_mode is "alu.output";	-- Output file
	file FullFile: text open write_mode is "alu.full.output";  -- Full output
	signal end_of_file: boolean;  -- End of File indicator
	signal iclk: std_logic := '0';	-- Internal Clock (testbench only)
	signal iresetn: std_logic;	-- Internal Resetn (testbench only)
	signal SrcA,SrcB,AluResult: std_logic_vector(31 downto 0);
	signal AluControl: std_logic_vector (2 downto 0);
	signal Overflow, Zero, CarryOut: std_logic;
	
	component alu
		Generic(W : natural := 32);	
		port(SrcA, SrcB: in std_logic_vector(W-1 downto 0);
		 AluControl : in std_logic_vector(2 downto 0);
		 AluResult : out std_logic_vector(W-1 downto 0);
		 Overflow, Zero, CarryOut: out std_logic);
	end component;

begin  -- behavior

	iclk <= not iclk after clk_period / 2;
	iresetn <= '0', '1' after 7 * clk_period;

	alu0: alu
		port map (
			SrcA		=> 	SrcA,
			SrcB		=>	SrcB,
			AluControl	=> 	AluControl,
			AluResult	=>	AluResult,
			Overflow	=>	Overflow,
			Zero		=>	Zero,
			CarryOut	=>	CarryOut);
	
	ReadInput : process(iClk, iResetn)
		variable input_line			: line;
		variable SrcA_value			: std_logic_vector(31 downto 0);
		variable SrcB_value 		: std_logic_vector(31 downto 0);
		variable AluControl_value	: std_logic_vector(2  downto 0);
	begin	-- process ReadInput
		if (iResetn = '0') then
			end_of_file <= false;
		elsif iClk'EVENT and iClk = '0' then
			if EndFile(InFile) then
				end_of_file <= true; -- stop when reaches end of file
			else
				ReadLine(InFile, input_line);
				Read(input_line, SrcA_value);
				Read(input_line, SrcB_value);
				Read(input_line, AluControl_value);
				SrcA <= SrcA_value;-- after delta;
				SrcB <= SrcB_value;-- after delta;
				AluControl <= AluControl_value;-- after delta;
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
			Write(output_line, AluResult, left, 33);
			Write(output_line, CarryOut, left, 2);
			Write(output_line, Overflow, left, 2);
			Write(output_line, Zero, left, 2);
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
			Write(output_line, AluControl, left, 4);
			Write(output_line, SrcA, left, 33);
			Write(output_line, SrcB, left, 33);
			Write(output_line, AluResult, left, 33);
			Write(output_line, CarryOut, left, 2);
			Write(output_line, Overflow, left, 2);
			Write(output_line, Zero, left, 2);
			WriteLine(FullFile, output_line);
		end if;
	end process WriteFull;

	-- stop the simulator when the end of file is reached
	assert not end_of_file report "End of Simulation" severity failure;

end behavior;
