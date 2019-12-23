library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity hex_to_7_seg is
  generic (
    activeLow : std_logic);
  port (
    sevenSeg : out std_logic_vector(6 downto 0);
    reg      : in  std_logic_vector(3 downto 0));
end hex_to_7_seg;

architecture behavior of Hex_to_7_Seg is

  signal segmentTemp : std_logic_vector(6 downto 0);

begin
--             0
--           -----
--          |     |
--        5 |     | 1
--          |  6  |
--           -----
--          |     |
--        4 |     | 2
--          |     |
--           -----
--             3

  seg_proc : process(reg)
  begin
    case reg is
      when x"0" => segmentTemp <= "0111111";  -- 0
      when x"1" => segmentTemp <= "0000110";  -- 1
      when x"2" => segmentTemp <= "1011011";  -- 2
      when x"3" => segmentTemp <= "1001111";  -- 3
      when x"4" => segmentTemp <= "1100110";  -- 4
      when x"5" => segmentTemp <= "1101101";  -- 5
      when x"6" => segmentTemp <= "1111101";  -- 6
      when x"7" => segmentTemp <= "0000111";  -- 7
      when x"8" => segmentTemp <= "1111111";  -- 8
      when x"9" => segmentTemp <= "1101111";  -- 9
      when x"A" => segmentTemp <= "1110111";  -- A
      when x"B" => segmentTemp <= "1111100";  -- B
      when x"C" => segmentTemp <= "0111001";  -- C
      when x"D" => segmentTemp <= "1011110";  -- D
      when x"E" => segmentTemp <= "1111001";  -- E
      when x"F" => segmentTemp <= "1110001";  -- F
      when others =>
        segmentTemp <= "0000000";
    end case;
  end process seg_proc;

  --  7 Segment displays can be active high or low, so use our generic input to choose
  sevenSeg <= not segmentTemp when activeLow = '1' else segmentTemp;

end behavior;
