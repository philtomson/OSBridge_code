library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity ca_1d is
  port( clk    : in  std_logic;
        rst    : in  std_logic;
        switch : in  std_logic_vector(7 downto 0);
        digits : out std_logic_vector(3 downto 0);
        
        led    : out std_logic_vector(7 downto 0) );
end ca_1d;

architecture beh of ca_1d is
  signal termcount : std_logic := '0';
  signal ctr       : std_logic_vector(23 downto 0) := (others => '0');
  signal curr_gen  : std_logic_vector(7 downto 0)  := "00010000";
  signal next_gen  : std_logic_vector(7 downto 0)  := "00010000";
  signal genctr    : std_logic_vector(15 downto 0) := (others => '0');
  signal rule      : std_logic_vector(7 downto 0)  := "00011110"; --rule 30
  signal rstin     : std_logic;

  component rule_eval
    port ( --input : in  std_logic_vector(2 downto 0);
           input0 : in std_logic;
           input1 : in std_logic;
           input2 : in std_logic;
           vals  : in  std_logic_vector(7 downto 0);
	   output: out std_logic);
  end component;

begin
--  GEN_RULES: for i in 0 to 3 generate
--    GR0: if i = 0 generate
--      RE: rule_eval port map(
--           input0 => curr_gen(7),
--	   input1 => curr_gen(0),
--	   input2 => curr_gen(1), 
--           vals   => switch,
--	   output => next_gen(0));
--    end generate GR0;
--    GR7: if i = 7 generate
--      RE: rule_eval port map(
--           input0 => curr_gen(6),
--	   input1 => curr_gen(7),
--	   input2 => curr_gen(0), 
--           --input  => (curr_gen(0)&curr_gen(7)&curr_gen(6)),
--           vals   => switch,
--	   output => next_gen(7));
--    end generate GR7;
--    GRN: if i /= 7 and i /= 0 generate
--      RE: rule_eval port map(
--           input0 => curr_gen(i-1),
--	   input1 => curr_gen(i),
--	   input2 => curr_gen(i+1), 
--           --input  => (curr_gen(i+1)&curr_gen(i)&curr_gen(i-1)),
--           vals   => switch,
--	   output => next_gen(i));
--    end generate GRN;
--  end generate GEN_RULES;

      RE0: rule_eval port map(
           input0 => curr_gen(7),
	   input1 => curr_gen(0),
	   input2 => curr_gen(1), 
           vals   => rule,
	   output => next_gen(0));

      RE1: rule_eval port map(
           input0 => curr_gen(0),
	   input1 => curr_gen(1),
	   input2 => curr_gen(2), 
           vals   => rule,
	   output => next_gen(1));
      
      RE2: rule_eval port map(
           input0 => curr_gen(1),
	   input1 => curr_gen(2),
	   input2 => curr_gen(3), 
           vals   => rule,
	   output => next_gen(2));

      RE3: rule_eval port map(
           input0 => curr_gen(2),
	   input1 => curr_gen(3),
	   input2 => curr_gen(4), 
           vals   => rule,
	   output => next_gen(3));

      RE4: rule_eval port map(
           input0 => curr_gen(3),
	   input1 => curr_gen(4),
	   input2 => curr_gen(5), 
           vals   => rule,
	   output => next_gen(4));

      RE5: rule_eval port map(
           input0 => curr_gen(4),
	   input1 => curr_gen(5),
	   input2 => curr_gen(6), 
           vals   => rule ,
	   output => next_gen(5));

      RE6: rule_eval port map(
           input0 => curr_gen(5),
	   input1 => curr_gen(6),
	   input2 => curr_gen(7), 
           vals   => rule,
	   output => next_gen(6));

      RE7: rule_eval port map(
           input0 => curr_gen(6),
	   input1 => curr_gen(7),
	   input2 => curr_gen(0), 
           --input  => (curr_gen(0)&curr_gen(7)&curr_gen(6)),
           vals   => rule,
	   output => next_gen(7));

  rstin <= rst;
  rule <= switch;
  process (clk, rstin, switch)
  begin
    if rstin = '1' then
      CTR <= (others => '0');--"0000000000000";
      --rule     <= switch;
      curr_gen <= switch;
      termcount <= '0';
    elsif clk'event and clk = '1' then
      --rule <= rule;
      if (CTR = x"800000") then   -- counter reaches 2^13
	termcount <= '1';
	curr_gen <= next_gen;
      else
	termcount <= '0';
	curr_gen <= curr_gen;
      end if;
      CTR <= CTR + x"000001";
    end if; 
  End Process;

  process(clk, rst, termcount)
  begin
    if rst = '1' then
      genctr <= (others => '0');
    elsif clk'event and clk = '1' then
      if(termcount = '1') then
        genctr <= genctr + x"0001";
      else
	genctr <= genctr;
      end if;
    end if;
  end process;

  led <= curr_gen;

end beh;
