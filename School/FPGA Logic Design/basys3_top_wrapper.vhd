library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

library work;
use work.breakout_package.all;

entity basys3_top_wrapper is
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
    -- VGA PINS
    vgaRed            : out std_logic_vector(3 downto 0);
    vgaBlue           : out std_logic_vector(3 downto 0);
    vgaGreen          : out std_logic_vector(3 downto 0);
    vgaSyncH          : out std_logic;
    vgaSyncV          : out std_logic);


end basys3_top_wrapper;

architecture behavior of basys3_top_wrapper is

  component xilinx_mmcm_vga_resolution_clk_gen
    generic (
      CLK_PERIOD     : real   := 10.000;
      VGA_RESOLUTION : string := "1280x1024");
    port (
      systemClk    : in  std_logic;
      vgaClkLocked : out std_logic;
      vgaClk       : out std_logic);
  end component;


  component button_debouncer
    generic (
      DEBOUNCE_CYCLES : natural := 1000000);
    port (
      clk             : in  std_logic;
      buttonInput     : in  std_logic;
      buttonDebounced : out std_logic);
  end component;

  component breakout_top_wrapper is
    port (
      clk                : in  std_logic;
      led                : out std_logic_vector(3 downto 0);
      reset              : in  std_logic;
      movePaddleLeft     : in  std_logic;
      movePaddleRight    : in  std_logic;
      pauseGameButton    : in  std_logic;
      programBallSpeedX  : in  std_logic_vector(1 downto 0);
      programBallSpeedY  : in  std_logic_vector(1 downto 0);
      programPaddleSpeed : in  std_logic_vector(1 downto 0);
      vgaSyncV           : out std_logic;
      vgaSyncH           : out std_logic;
      scoreOnes          : out std_logic_vector(3 downto 0);
      scoreTens          : out std_logic_vector(3 downto 0);
      scoreHundreds      : out std_logic_vector(3 downto 0);
      scoreThousands     : out std_logic_vector(3 downto 0);
      vgaRed             : out std_logic_vector(3 downto 0);
      vgaBlue            : out std_logic_vector(3 downto 0);
      vgaGreen           : out std_logic_vector(3 downto 0));
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

  signal pixelPositionX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal pixelPositionY : std_logic_vector(NUM_V_BITS-1 downto 0);
  --
  signal dataSegment0   : std_logic_vector(3 downto 0);
  signal dataSegment1   : std_logic_vector(3 downto 0);
  signal dataSegment2   : std_logic_vector(3 downto 0);
  signal dataSegment3   : std_logic_vector(3 downto 0);

  signal clkEnable : std_logic;

  signal movePaddleRight : std_logic;
  signal movePaddleLeft  : std_logic;
  signal pauseGameButton : std_logic;

  signal scoreOnes      : std_logic_vector(3 downto 0);
  signal scoreTens      : std_logic_vector(3 downto 0);
  signal scoreHundreds  : std_logic_vector(3 downto 0);
  signal scoreThousands : std_logic_vector(3 downto 0);

  signal debouncedButtonLeft     : std_logic;
  signal debouncedButtonRight    : std_logic;
  signal debouncedButtonCenter   : std_logic;
  signal debouncedButtonCenterR1 : std_logic;
  signal debouncedButtonUp       : std_logic;
  signal debouncedButtonDown     : std_logic;

  signal reset        : std_logic;
  signal vgaClkLocked : std_logic;
  signal vgaClk       : std_logic;

  signal count  : natural   := 0;
  signal strobe : std_logic := '0';

begin


  -- DEBUG SIGNALS 
  led(15) <= buttonDown;
  led(14) <= vgaClkLocked;
  led(13) <= reset;
  led(8)  <= strobe;
  
  process (clk)
  begin
    if rising_edge(clk) then
      if count = 100000000 then
        count  <= 0;
        strobe <= not strobe;
      else
        count <= count + 1;
      end if;

      led(7) <= '1';
    end if;
  end process;

  -- No LEDs being used currently, tied off for now to prevent warnings
  led(6 downto 0) <= (others => '0');
  dataSegment0    <= scoreOnes;
  dataSegment1    <= scoreTens;
  dataSegment2    <= scoreHundreds;
  dataSegment3    <= scoreThousands;

  movePaddleRight <= debouncedButtonRight;
  movePaddleLeft  <= debouncedButtonLeft;
  reset           <= debouncedButtonUp or not vgaClkLocked;

  u_basys3_seven_seg_wrapper : basys3_seven_seg_wrapper
    port map (
      clk               => clk,
      reset             => reset,
      displaySegment    => displaySegment,
      illuminateSegment => illuminateSegment,
      dataSegment0      => dataSegment0,
      dataSegment1      => dataSegment1,
      dataSegment2      => dataSegment2,
      dataSegment3      => dataSegment3);

  mmcm : xilinx_mmcm_vga_resolution_clk_gen
      port map(
          systemClk     => clk,
          vgaClkLocked  => vgaClkLocked,
          vgaClk        => vgaClk);

  u_breakout_top_wrapper : breakout_top_wrapper
    port map (
      clk                => clk,
      reset              => reset,
      movePaddleRight    => movePaddleRight,
      movePaddleLeft     => movePaddleLeft,
      led                => led(12 downto 9),
      programPaddleSpeed => switch(1 downto 0),
      programBallSpeedX  => switch(3 downto 2),
      programBallSpeedY  => switch(5 downto 4),
      pauseGameButton    => pauseGameButton,
      vgaSyncH           => vgaSyncH,
      vgaSyncV           => vgaSyncV,
      scoreOnes          => scoreOnes,
      scoreTens          => scoreTens,
      scoreHundreds      => scoreHundreds,
      scoreThousands     => scoreThousands,
      vgaRed             => vgaRed,
      vgaBlue            => vgaBlue,
      vgaGreen           => vgaGreen);

  u_button_debouncer_left : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonLeft,
      buttonDebounced => debouncedButtonLeft);

  u_button_debouncer_up : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonUp,
      buttonDebounced => debouncedButtonUp);

  u_button_debouncer_center : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonCenter,
      buttonDebounced => debouncedButtonCenter);

  u_button_debouncer_down : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonDown,
      buttonDebounced => debouncedButtonDown);

  u_button_debouncer_right : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonRight,
      buttonDebounced => debouncedButtonRight);


  -- Assign the pause button to the center button
  -- The Breakout logic will handle determining when to actually pause, regardless
  -- of whether this is active for multiple cycles, a single cycle, etc.
  pauseGameButton <= debouncedButtonCenter;

end behavior;
