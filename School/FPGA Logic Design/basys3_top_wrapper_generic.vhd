library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

library work;

entity basys3_top_wrapper_generic is
  port (
    clk               : in  std_logic;
    -- SWITCHES
    switch            : in  std_logic_vector(15 downto 0);
    -- LEDs
    led               : out std_logic_vector(15 downto 0);
    -- 7 SEGMENT MUXed DISPLAY SEGMENTS
    illuminateSegment : out std_logic_vector(6 downto 0);
    -- WHICH DISPLAY IS ACTIVE [NOTE: only 1 high at a time]
    displaySegment    : out std_logic_vector(3 downto 0);
    -- BUTTON PINS
    buttonUp          : in  std_logic;
    buttonDown        : in  std_logic;
    buttonLeft        : in  std_logic;
    buttonRight       : in  std_logic;
    buttonCenter      : in  std_logic;
    -- UART PINS
    uartRX            : in  std_logic;
    uartTX            : out std_logic;
    -- VGA PINS
    vgaRed            : out std_logic_vector(3 downto 0);
    vgaBlue           : out std_logic_vector(3 downto 0);
    vgaGreen          : out std_logic_vector(3 downto 0);
    vgaSyncH          : out std_logic;
    vgaSyncV          : out std_logic);


end basys3_top_wrapper_generic;

architecture behavior of basys3_top_wrapper_generic is

  component button_debouncer
    generic (
      DEBOUNCE_CYCLES : natural := 1000000);
    port (
      clk             : in  std_logic;
      buttonInput     : in  std_logic;
      buttonDebounced : out std_logic);
  end component;

  component basys3_seven_seg_wrapper is
    port (
      clk               : in  std_logic;
      reset             : in  std_logic;
      -- Enable bit to determine which display is currently active
      displaySegment    : out std_logic_vector(3 downto 0);
      -- Output value of each segment for active screen
      illuminateSegment : out std_logic_vector(6 downto 0);
      -- Hexadecimal data to display to each seven-segment screen
      dataSegment0      : in  std_logic_vector(3 downto 0);
      dataSegment1      : in  std_logic_vector(3 downto 0);
      dataSegment2      : in  std_logic_vector(3 downto 0);
      dataSegment3      : in  std_logic_vector(3 downto 0));
  end component;
  
  component uart_rx
    generic (
      CLKS_PER_BIT  : integer := 868       -- CLKS_PER_BIT = clk frequency / baud rate ex. 100MHz / 115,200 = 868
      );
    port (
      clk                : in  std_logic;
      reset_n            : in  std_logic;
      uart_rx_serial     : in  std_logic;
      uart_rx_data_valid : out std_logic;
      uart_rx_data_byte  : out std_logic_vector(7 downto 0)
      );
  end component;
  
  component uart_tx
    generic (
      CLKS_PER_BIT  : integer := 868       -- CLKS_PER_BIT = clk frequency / baud rate ex. 100MHz / 115,200 = 868
      );
    port (
    clk                : in  std_logic;
    reset_n            : in  std_logic;
    uart_tx_data_valid : in  std_logic;
    uart_tx_data_byte  : in  std_logic_vector(7 downto 0);
    uart_tx_active     : out std_logic;
    uart_tx_serial     : out std_logic);
  end component;

  --signal debouncedButtonLeft     : std_logic;
  --signal debouncedButtonRight    : std_logic;
  signal debouncedButtonCenter   : std_logic;
  --signal debouncedButtonUp       : std_logic;
  --signal debouncedButtonDown     : std_logic;

  signal reset        : std_logic;
  signal reset_n      : std_logic;

  signal uart_rx_data_valid : std_logic;
  signal uart_rx_data_byte : std_logic_vector(7 downto 0);

  signal count  : natural   := 0;
  signal strobe : std_logic := '0';

begin


  -- DEBUG SIGNALS 
  led(14) <= debouncedButtonCenter;
  led(15)  <= strobe;
  
  process (clk)
  begin
    if rising_edge(clk) then
      if count = 100000000 then
        count  <= 0;
        strobe <= not strobe;
      else
        count <= count + 1;
      end if;
    end if;
  end process;

  -- No LEDs being used currently, tied off for now to prevent warnings
  led(13 downto 0) <= "00101010101010";
  reset           <= debouncedButtonCenter;
  reset_n         <= not debouncedButtonCenter;
  u_basys3_seven_seg_wrapper : basys3_seven_seg_wrapper
    port map (
      clk               => clk,
      reset             => reset,
      displaySegment    => displaySegment,
      illuminateSegment => illuminateSegment,
      dataSegment0      => "0001",
      dataSegment1      => "0010",
      dataSegment2      => "0011",
      dataSegment3      => "0100");

  u_button_debouncer_left : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonLeft,
      buttonDebounced => open);

  u_button_debouncer_up : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonUp,
      buttonDebounced => open);

  u_button_debouncer_center : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonCenter,
      buttonDebounced => debouncedButtonCenter);

  u_button_debouncer_down : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonDown,
      buttonDebounced => open);

  u_button_debouncer_right : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonRight,
      buttonDebounced => open);
      
  u_uart_rx : uart_rx
        generic map (
          CLKS_PER_BIT => 868)
        port map (
          clk            => clk,
          reset_n        => reset_n,
          uart_rx_serial => uartRx,
          uart_rx_data_valid => uart_rx_data_valid,
          uart_rx_data_byte  => uart_rx_data_byte);
          
  u_uart_tx : uart_tx
                generic map (
                  CLKS_PER_BIT => 868)
                port map (
                  clk                => clk,
                  reset_n            => reset_n,
                  uart_tx_data_valid => uart_rx_data_valid,
                  uart_tx_data_byte  => uart_rx_data_byte,
                  uart_tx_active     => open,
                  uart_tx_serial     => uartTX);

end behavior;