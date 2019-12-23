library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.math_real.all;

entity basys3_seven_seg_wrapper is
  port (
    clk               : in  std_logic;
    reset             : in  std_logic;
    displaySegment    : out std_logic_vector(3 downto 0);
    illuminateSegment : out std_logic_vector(6 downto 0);
    dataSegment0      : in  std_logic_vector(3 downto 0);
    dataSegment1      : in  std_logic_vector(3 downto 0);
    dataSegment2      : in  std_logic_vector(3 downto 0);
    dataSegment3      : in  std_logic_vector(3 downto 0));
end basys3_seven_seg_wrapper;

architecture behavior of basys3_seven_seg_wrapper is

  component hex_to_7_seg
    generic (
      activeLow : std_logic);
    port (
      sevenSeg : out std_logic_vector(6 downto 0);
      reg      : in  std_logic_vector(3 downto 0));
  end component;

  constant REFRESH_MAXCOUNT : natural := 200000;

  signal sevenSeg0      : std_logic_vector(6 downto 0);
  signal sevenSeg1      : std_logic_vector(6 downto 0);
  signal sevenSeg2      : std_logic_vector(6 downto 0);
  signal sevenSeg3      : std_logic_vector(6 downto 0);
  signal refreshCounter : std_logic_vector(17 downto 0);
  signal activeDisplay  : std_logic_vector(3 downto 0);

begin

  segment0 : hex_to_7_seg
    generic map (
      activeLow => '1')
    port map (
      sevenSeg => sevenSeg0,
      reg      => dataSegment0);

  segment1 : hex_to_7_seg
    generic map (
      activeLow => '1')
    port map (
      sevenSeg => sevenSeg1,
      reg      => dataSegment1);

  segment2 : hex_to_7_seg
    generic map (
      activeLow => '1')
    port map (
      sevenSeg => sevenSeg2,
      reg      => dataSegment2);

  segment3 : hex_to_7_seg
    generic map (
      activeLow => '1')
    port map (
      sevenSeg => sevenSeg3,
      reg      => dataSegment3);

  process(clk)
  begin
    if (rising_edge(clk)) then

      if (reset = '1') then
        refreshCounter <= (others => '0');
        activeDisplay  <= "1110";
      else
        displaySegment <= activeDisplay;

        case activeDisplay is
          when "1110" => illuminateSegment <= sevenSeg0;
          when "1101" => illuminateSegment <= sevenSeg1;
          when "1011" => illuminateSegment <= sevenSeg2;
          when "0111" => illuminateSegment <= sevenSeg3;
          when others => illuminateSegment <= (others => '0');
        end case;

        -- Count up to 200,000. At a 100Mhz rate, this results in a 500Hz refresh rate
        -- Once we reach the count, we want to rotate the activeDisplay bits so that
        -- a new display can be turned on to present its value
        if (unsigned(refreshCounter) = REFRESH_MAXCOUNT) then
          refreshCounter <= (others => '0');
          activeDisplay  <= activeDisplay(2 downto 0) & activeDisplay(3);
        else
          refreshCounter <= unsigned(refreshCounter) + 1;
        end if;
      end if;
    end if;
  end process;

end behavior;
