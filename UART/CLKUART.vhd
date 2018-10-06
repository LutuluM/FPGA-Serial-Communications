library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLKUART is
	Port (O:out STD_LOGIC;CLK,Clear:in STD_LOGIC);
	end entity;

architecture Behavioral of CLKUART is
signal W:std_ulogic;
signal count: integer :=0;
begin
	O <= W;
	process(CLK,Clear) begin
		if (Clear = '1') then
			W<= '0';
			count <= 0;
		elsif rising_edge(CLK) then
			count <= count + 1;
			if count=(25000000/9600)-1 then --divided for 9600buad.divide half clk by rate, or clk by 2*rate
				W <= not W;
				count <= 0;
				end if;
		end if;	
	end process;
end Behavioral;



