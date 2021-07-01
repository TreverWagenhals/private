library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.math_real.all;

entity button_debouncer is
  generic (
    DEBOUNCE_CYCLES : natural := 1000000);
  port (
    clk             : in  std_logic;
    buttonInput     : in  std_logic;
    buttonDebounced : out std_logic);
end button_debouncer;

architecture behavior of button_debouncer is

  -- The size is determined by the value converted to a bit number by using log math and rounding up
  signal debounceCount : std_logic_vector(natural(ceil(log2(real(DEBOUNCE_CYCLES)))) downto 0);

  -- Take the DEBOUNCE_CYCLES natural generic and convert it to a constant std_logic_vector so that it can be used cleanly within the logic
  -- The size of the constant is equal to the length of 
  constant DEBOUNCE_CYCLES_CONSTANT : std_logic_vector(debounceCount'length-1 downto 0) := conv_std_logic_vector(DEBOUNCE_CYCLES, debounceCount'length);

begin
  process (clk)
  begin
    if rising_edge(clk) then
      if (buttonInput = '1') then
        if (debounceCount /= DEBOUNCE_CYCLES_CONSTANT) then
          debounceCount <= unsigned(debounceCount) + 1;
        else
          buttonDebounced <= '1';
        end if;
      else
        buttonDebounced <= '0';
        debounceCount   <= (others => '0');
      end if;
    end if;
  end process;
end behavior;