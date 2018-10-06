library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_std.All;

entity AdrSeg is
	Port(	Inc,Dec:in std_logic;
			Adr:out std_logic_vector(1 downto 0);
			Number:out std_logic_vector(6 downto 0);
			Active:out std_logic_vector(3 downto 0));
end entity;

architecture Behavioral of AdrSeg is
signal Address:integer range 0 to 3 := 0;
signal Trigger:std_logic := '0';

begin
Adr <= std_logic_vector(to_unsigned(Address,2));

process(Inc,Dec)begin
	Trigger <= Inc or Dec;
end process;
process(Trigger,Inc,Dec)begin
	if(rising_edge(Trigger))then
		if(Inc = '1') then
			Address <= Address + 1;
		else 
			Address <= Address - 1;
		end if;
	end if;
end process;
process(Address)begin
	Active <= "1110";
	case(Address) is
		when 0 => Number <= "0000001";
		when 1 => Number <= "1001111";
		when 2 => Number <= "0010010";
		when 3 => Number <= "0000110";
		--when 4 => Number <= "1001100";
		--when 5 => Number <= "0100100";
		--when 6 => Number <= "0100000";
		--when 7 => Number <= "0001111";
		--when 8 => Number <= "0000000";
		--when 9 => Number <= "0000100";
		--when others => Number <= "1111111";
	end case;
end process;
end Behavioral;

