library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity breakout_tb is
end breakout_tb;


architecture behavior of breakout_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component breakout_top_wrapper
    port (
      clk                : in  std_logic;
      reset              : in  std_logic;
      pauseGameButton    : in  std_logic;
      movePaddleLeft     : in  std_logic;
      movePaddleRight    : in  std_logic;
      scoreOnes          : out std_logic_vector(3 downto 0);
      scoreTens          : out std_logic_vector(3 downto 0);
      scoreHundreds      : out std_logic_vector(3 downto 0);
      scoreThousands     : out std_logic_vector(3 downto 0);
      programBallSpeedX  : in  std_logic_vector(1 downto 0);
      programBallSpeedY  : in  std_logic_vector(1 downto 0);
      programPaddleSpeed : in  std_logic_vector(1 downto 0);
      vgaSyncH           : out std_logic;
      vgaSyncV           : out std_logic;
      vgaRed             : out std_logic_vector(3 downto 0);
      vgaBlue            : out std_logic_vector(3 downto 0);
      vgaGreen           : out std_logic_vector(3 downto 0));
  end component;

  signal clk               : std_logic;
  signal reset             : std_logic;
  signal pauseGameButton   : std_logic;
  signal movePaddleLeft    : std_logic;
  signal movePaddleRight   : std_logic;
  signal programBallSpeedX : std_logic_vector(1 downto 0);
  signal programBallSpeedY : std_logic_vector(1 downto 0);
  signal vgaSyncV          : std_logic;
  signal vgaSyncH          : std_logic;
  signal vgaRed            : std_logic_vector(3 downto 0);
  signal vgaGreen          : std_logic_vector(3 downto 0);
  signal vgaBlue           : std_logic_vector(3 downto 0);



-- Just setting a low clock period so that simulation is faster. Has nothing to do with the actual clock or vga timing 
constant clk_period : time := 2 ns;

begin

  uut : breakout_top_wrapper
    port map (
      clk                => clk,
      reset              => reset,
      pauseGameButton    => PauseGameButton,
      movePaddleLeft     => movePaddleLeft,
      movePaddleRight    => movePaddleRight,
      scoreOnes          => open,
      scoreTens          => open,
      scoreHundreds      => open,
      scoreThousands     => open,
      programBallSpeedX  => (others => '0'),
      programBallSpeedY  => (others => '0'),
      programPaddleSpeed => (others => '0'),
      vgaSyncH           => vgaSyncH,
      vgaSyncV           => vgaSyncV,
      vgaGreen           => vgaGreen,
      vgaRed             => vgaRed,
      vgaBlue            => vgaBlue);

  clock_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  stim_process : process
  begin
    reset           <= '1';
    pauseGameButton <= '0';
    movePaddleLeft  <= '1';
    movePaddleRight <= '0';
    wait for clk_period * 100;
    reset           <= '0';
    wait for clk_period * 100;
    pauseGameButton <= '1';
    wait for clk_period;
    pauseGameButton <= '0';
    wait for clk_period * (30000000/2);
    movePaddleLeft  <= '0';
    movePaddleRight <= '1';
    wait;
  end process;
end;
