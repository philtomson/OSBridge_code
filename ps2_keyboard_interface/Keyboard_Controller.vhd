library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
entity Keyboard_Controller is
    Port ( Clk : in  STD_LOGIC;
  	   Clk2 : in  STD_LOGIC;
           DataIn : in  STD_LOGIC;
	   Enables : out  STD_LOGIC_VECTOR (3 downto 0);
	   pressed : out  STD_LOGIC_VECTOR (7 downto 0);
	   Segments : out  STD_LOGIC_VECTOR (6 downto 0));
end Keyboard_Controller;
architecture Behavioral of Keyboard_Controller is
signal data : STD_LOGIC_VECTOR (21 downto 0) := "1111111111111111111111";
signal OutByte1,OutByte2 : STD_LOGIC_VECTOR (7 downto 0);
signal presses,npresses : STD_LOGIC_VECTOR (7 downto 0) := x"00";
signal Counter,nCounter : STD_LOGIC_VECTOR (4 downto 0) := "00000";
COMPONENT SevenSegment
PORT(
	Clk : IN std_logic;
	dataIn : IN std_logic_vector(15 downto 0);          
	Enables : OUT std_logic_vector(3 downto 0);
	Segments : OUT std_logic_vector(6 downto 0));
END COMPONENT;
begin
--pressed <= presses;
pressed <= OutByte2;
npresses <= presses + 1;
nCounter <= Counter + 1;
Inst_SevenSegment: SevenSegment PORT MAP(
	Clk => Clk2,
	Enables => Enables,
	Segments => Segments,
	dataIn(15 downto 8) => OutByte1,
	dataIn(7 downto 0) => OutByte1); --was OutByte2

process (Clk) begin
	if (falling_edge(Clk)) then
		--data(21 downto 1) <= data(20 downto 0);
		data(20 downto 0) <= data(21 downto 1);
		--data(0) <= DataIn;
		data(21) <= DataIn;
		if (Counter = "10101") then
			--if (data(9 downto 2) <= x"0F") then
			--if (data(9 downto 2) /= x"F0") then
			--if (data(20 downto 13) /= x"F0") then
		  
		          if( data(9 downto 2 ) = x"F0") then
				OutByte1 <= data(20 downto 13);
				presses <= npresses;
                          elsif( data(20 downto 13) = x"F0") then
				OutByte1 <= data(9 downto 2);
				presses <= npresses;
                          end if;
				--was: OutByte2 <= data(20 downto 13);
				--     presses <= npresses;
			--end if;
		end if;
		if (Counter = "10101") then
			Counter <= "00000";
		else
			Counter <= nCounter;
		end if;
	end if;
end process;
end Behavioral;
