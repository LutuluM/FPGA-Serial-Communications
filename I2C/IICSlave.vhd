Library IEEE;
use IEEE.std_logic_1164.all;

Entity IICSlave is
	port(	ByteOut:out std_logic_vector(7 downto 0);
			Address:in std_logic_vector(1 downto 0);
			BusCLK,BusData,Clear:in std_logic);
	end Entity;

Architecture Behavioral of IICSlave is

signal IBuffer,IOutData: std_logic_vector(7 downto 0);
signal ABuffer: std_logic_vector(1 downto 0);

type STATES is (Idle,Addressing,Loading,StopNorm,NotAddress,StopFail);
signal State: STATES := Idle;

begin
ByteOut <= IOutData;
Process(State,IOutData,Address,BusCLK,BusData,Clear)
variable Counter: integer;
begin
	if(Clear = '1') then
		IOutData <= "00000000";
		State <= Idle;
	elsif(rising_edge(BusCLK)) then
		case State is
			when Idle =>
				if(BusData = '0') then
					State <= Addressing;
					Counter := 0;
				end if;
			when Addressing =>
				if(Counter > 1) then
					Counter := 0;
					if(ABuffer = Address) then
						State <= Loading;
					else
						State <= NotAddress;
					end if;
				else
					ABuffer <= BusData & ABuffer(1);
					Counter := Counter + 1;
				end if;
			when Loading =>
				if(Counter > 7) then
					State <= StopNorm;
				else
					IBuffer <= BusData & IBuffer(7 downto 1);
					Counter := Counter + 1;
				end if;
			when StopNorm =>
				if(BusData = '1') then
					State <= Idle;
					IOutData <= IBuffer;
				end if;
			when NotAddress =>
				if(Counter > 7) then
					State <= StopFail;
				else
					Counter := Counter + 1;
				end if;
			when StopFail =>
				if(BusData = '1') then
					State <= Idle;
				end if;
		end case;
	end if;
end process;
End Architecture;