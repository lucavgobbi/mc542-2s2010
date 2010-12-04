LIBRARY ieee;
        USE ieee.std_logic_1164.all;
        USE ieee.numeric_std.all;

Entity sum32 is
	Generic (X : natural := 32);
	port (a, b: in std_logic_vector(X-1 downto 0);
		  CarryIn:in std_logic;
		  USigned: in std_logic;
		  Result: out std_logic_vector(X-1 downto 0);
		  Overflow,CarryOut: out std_logic);
End sum32;

Architecture behaviour of sum32 is
signal sum : std_logic_vector (32 downto 0);
signal cin : std_logic_vector (0 downto 0);
begin
		cin(0) <= CarryIn;
		sum <= std_logic_vector(signed(('0' & a)) + signed('0' & b) + signed(cin)) WHEN USigned = '0' ELSE std_logic_vector(unsigned(('0' & a)) + unsigned('0' & b) + unsigned(cin));
		CarryOut <= sum(32);
		Overflow <= sum(32) XOR a(31) XOR b(31) XOR sum(31);
		Result <= sum(31 downto 0);

end behaviour;
