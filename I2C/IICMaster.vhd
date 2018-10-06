Library IEEE;
use IEEE.std_logic_1164.all;

Entity IICMaster is
	port(	BusData,BusClock:out std_logic;
			ByteIn:in std_logic_vector(7 downto 0);
			Address: in std_logic_vector(1 downto 0);
			Send,ICLK,Reset:in std_logic);
			end Entity;

Architecture Behavioral of IICMaster is

signal IBuffer: std_logic_vector(7 downto 0);
signal ABuffer: std_logic_vector(1 downto 0);
signal IOUTData: std_logic := '1';

type STATES is (Idle,Addressing,Sending,Stop);
signal State: STATES := Idle;

begin
BusData <=  IOUTData;
BusClock <= ICLK;
Process(ICLK,Reset,State,ByteIn,Send,Address)
variable Counter: integer;
begin
	if(Reset = '1') then
		IOUTData <= '1';
		State <= Idle;
	elsif(rising_edge(ICLK)) then
		case State is
			when Idle =>
				if(Send = '1') then
					State <= Addressing;
					ABuffer <= Address;
					IOUTData <= '0';
					Counter := 0;
					IBuffer <= ByteIn;
				else
					IOUTData <= '1';
				end if;
			when Addressing =>
				if(Counter > 1) then
					Counter := 0;
					State <= Sending;
				else
					IOUTData <= ABuffer(0);
					ABuffer <= '0' & ABuffer(1 downto 1);
					Counter := Counter + 1;
				end if;
			when Sending =>
				if(Counter > 7) then
					State <= Stop;
				else
					IOUTData <= IBuffer(0);
					IBuffer <= '0' & IBuffer(7 downto 1);
					Counter := Counter + 1;
				end if;
			when Stop =>
					State <= Idle;
					IOUTData <= '1';
		end case;
	end if;
end process;
End Architecture;