library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity SevenSegment is
  PORT(
	Clk : IN std_logic;
	dataIn : IN std_logic_vector(15 downto 0);          
	Enables : OUT std_logic_vector(3 downto 0);
	Segments : OUT std_logic_vector(6 downto 0));
END SevenSegment;

architecture beh of SevenSegment is
  constant OFF   : std_logic_vector(6 downto 0) := "1111111";
  constant ZERO  : std_logic_vector(6 downto 0) := "0000001";
  constant ONE   : std_logic_vector(6 downto 0) := "1001111";
  constant TWO   : std_logic_vector(6 downto 0) := "0010010";
  constant THREE : std_logic_vector(6 downto 0) := "0000110";


  signal CTR : STD_LOGIC_VECTOR(12 downto 0);
  signal digit : std_logic_vector(3 downto 0);
  signal LED: std_logic_vector(6 downto 0);
  signal data0 : std_logic_vector(6 downto 0);
  signal data1 : std_logic_vector(6 downto 0);
  signal data2 : std_logic_vector(6 downto 0);
  signal data3 : std_logic_vector(6 downto 0);
  signal data4 : std_logic_vector(6 downto 0);
  signal data5 : std_logic_vector(6 downto 0);
  signal data6 : std_logic_vector(6 downto 0);
  signal data7 : std_logic_vector(6 downto 0);
  signal lastData : std_logic_vector(7 downto 0);
begin			
  Process (dataIn)
  begin
    --if(dataIn'event ) then
    if( dataIn(7 downto 0) /= lastData  and dataIn(7 downto 0) /= x"0F")then 
	case dataIn(7 downto 0) is
	  --when "00011100" =>
	  when x"1C" => -- A
	    data0 <= "0001000";
	  --when  "00011011" => -- S
	  --  data1 <= data0;
	  --  data0 <= "0010010";
	  --when  "11011000" => -- S
	  --  data1 <= data0;
	  --  data0 <= "0010010";
	  when  x"1B" => -- S << working one
	    data0 <= "0010010";
	  --when x"23" => -- D
	  when x"23" => -- D
	    data0 <= "0100001";
	  when x"26" => -- 3
	    data0 <= "0110000";
	  when x"43" => -- I
	    data0 <= "1111001";
	  when others => 
	    data0 <= "1111111";
	end case;
	--if( data0 /= data1) then
	  lastData <= dataIn(7 downto 0);
	  data7 <= data6;
	  data6 <= data5;
	  data5 <= data4;
	  data4 <= data3;
	  data3 <= (data2); -- xor data1);
	  data2 <= (data1); -- xor data0);
	  data1 <= (data0); -- xor data3);
	--end if;
      end if;
    --end if;
  end process;

  
  Process (Clk)
  begin
    if Clk'event and Clk = '1' then
      if (CTR="0000000000000") then
	case digit is
	  when "1110" =>
	    digit <= "1101"; --digit 1
            LED <= data2;  -- was data2
	  when "1101" =>
	    digit <= "1011"; --digit 2
            LED <= data4;  -- was data4
	  when "1011" =>
	    digit <= "0111"; --digit 3
            LED <= data6;  -- was data6
	  when "0111" =>
	    digit <= "1110"; --digit 0
            LED <= data0;  -- was data0
	  when others => 
	    digit <= "1110";
	    LED <= "1111111";
	end case;
      end if;
      CTR<=CTR+"0000000000001";
      if (CTR > "1000000000000") then   -- counter reaches 2^13
        CTR<="0000000000000";
      end if;
    end if; -- CLK'event and CLK = '1' 
  End Process;
  Enables <= digit;
  Segments   <= LED ;
end beh;

