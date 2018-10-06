Library IEEE;
use IEEE.std_logic_1164.all;

Entity UARTReceiver is
	port(ByteOut:out std_logic_vector(7 downto 0);UCLK,UData,Reset:in std_logic);
end Entity;

Architecture Behavioral of UARTReceiver is
signal UINData,UOUTData: std_logic_vector(7 downto 0);
type STATE is (Idle,Loading,Stop,Error);
signal Action: STATE := Idle;
begin
ByteOut <= UOUTData;
Process(UCLK,Reset,Action,UINData)
variable Counter: integer;
begin
	if(Reset = '1') then
		UINData <= "00000000";
		UOUTData <= "00000000";
		Action <= Idle;
	elsif(rising_edge(UCLK)) then
		case Action is
			when Idle =>
				if(UData = '0') then
					Action <= Loading;
					Counter := 0;
				end if;
			when Loading =>
				UINData <= UData & UINData(7 downto 1);
				Counter := Counter + 1;
				if(Counter > 7) then
					Action <= Stop;
				end if;
			when Stop =>
				if(UData = '1') then
					Action <= Idle;
					UOUTData <= UINData;
				end if;
			when Error =>
				null;
		end case;
	end if;
end process;
End Architecture;