Library IEEE;
use IEEE.std_logic_1164.all;

Entity UARTSender is
	port(UData:out std_logic;ByteIn:in std_logic_vector(7 downto 0);Send,UCLK,Reset:in std_logic);
	end Entity;

Architecture Behavioral of UARTSender is

signal UBuffer: std_logic_vector(7 downto 0);
signal UOUTData: std_logic := '1';
type STATE is (Idle,Sending,Stop,Error);
signal Action: STATE := Idle;

begin
UData <=  UOUTData;

Process(UCLK,Reset,Action,ByteIn,Send)
variable Counter: integer;
begin
	if(Reset = '1') then
		UOUTData <= '1';
		Action <= Idle;
	elsif(rising_edge(UCLK)) then
		case Action is
			when Idle =>
				if(Send = '1') then
					Action <= Sending;
					UOUTData <= '0';
					Counter := 0;
					UBuffer <= ByteIn;
				else
					UOUTData <= '1';
				end if;
			when Sending =>
				UOUTData <= UBuffer(0);
				UBuffer <= '0' & UBuffer(7 downto 1);
				Counter := Counter + 1;
				if(Counter > 7) then
					Action <= Stop;
				end if;
			when Stop =>
					Action <= Idle;
					UOUTData <= '1';
			when Error =>
				null;
		end case;
	end if;
end process;
End Architecture;