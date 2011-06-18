library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity rule_eval is
  port( input0 : in  std_logic; --_vector(2 downto 0);
        input1 : in  std_logic; --_vector(2 downto 0);
        input2 : in  std_logic; --_vector(2 downto 0);
        vals  : in  std_logic_vector(7 downto 0);
        output: out std_logic); 
end rule_eval;

architecture beh of rule_eval is
  signal concat : std_logic_vector(2 downto 0);
begin

  concat <= (input2 & input1 & input0);

  process (concat,vals)
  begin
    case concat is
      when "000" => output <= vals(0);
      when "001" => output <= vals(1);
      when "010" => output <= vals(2);
      when "011" => output <= vals(3);
      when "100" => output <= vals(4);
      when "101" => output <= vals(5);
      when "110" => output <= vals(6);
      when "111" => output <= vals(7);
      when others => output <= '0';
    end case;
  end process;

end beh;

