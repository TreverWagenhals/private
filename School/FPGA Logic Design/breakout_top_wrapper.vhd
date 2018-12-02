library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.math_real.all;

library work;
use work.breakout_package.all;

entity breakout_top_wrapper is
  port (
    clk                : in  std_logic;
    led                : out std_logic_vector(3 downto 0);
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
end breakout_top_wrapper;

architecture behavior of breakout_top_wrapper is

  component vga_controller
    generic (
      H_PIXELS       : natural   := 640;
      H_FRONT_PORCH  : natural   := 16;
      H_SYNC_PULSE   : natural   := 96;
      H_BACK_PORCH   : natural   := 48;
      H_POLARITY     : std_logic := '1';
      H_PERIOD       : natural   := 800;
      NUM_H_BITS     : natural   := natural(ceil(log2(real(800))));
      --
      V_PIXELS       : natural   := 480;
      V_FRONT_PORCH  : natural   := 10;
      V_SYNC_PULSE   : natural   := 2;
      V_BACK_PORCH   : natural   := 33;
      V_POLARITY     : std_logic := '1';
      V_PERIOD       : natural   := 525;
      NUM_V_BITS     : natural   := natural(ceil(log2(real(525))));
      --
      USE_CLK_ENABLE : std_logic := '0');
    port (
      clk            : in  std_logic;  -- pixel clock at frequency of VGA mode being used
      clkEnable      : in  std_logic;
      reset          : in  std_logic;   -- active low asycnchronous reset
      vgaSyncH       : out std_logic;   -- horizontal sync pulse
      vgaSyncV       : out std_logic;   -- vertical sync pulse
      pixelPositionX : out std_logic_vector(NUM_H_BITS-1 downto 0);  -- horizontal pixel coordinate
      pixelPositionY : out std_logic_vector(NUM_V_BITS-1 downto 0));  -- vertical pixel coordinate     
  end component;

  component breakout_paddle_control
    generic (
      PADDLE_COLOR   : std_logic_vector(11 downto 0)           := "111111111111";
      PADDLE_START_X : std_logic_vector(NUM_H_BITS-1 downto 0) := (others => '0');
      PADDLE_START_Y : std_logic_vector(NUM_V_BITS-1 downto 0) := (others => '0');
      PADDLE_END_X   : std_logic_vector(NUM_H_BITS-1 downto 0) := (others => '0');
      PADDLE_END_Y   : std_logic_vector(NUM_V_BITS-1 downto 0) := (others => '0'));
    port (
      clk                    : in  std_logic;
      reset                  : in  std_logic;
      pauseGame              : in  std_logic;
      gameLost               : in  std_logic;
      ballWithinPaddleX      : out std_logic;
      pixelPositionY         : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      pixelPositionX         : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionStartX     : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionStartY     : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      ballPositionEndX       : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionEndY       : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      movePaddleLeft         : in  std_logic;
      movePaddleRight        : in  std_logic;
      paddleSpeed            : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      paddleUpdateYDirection : out std_logic;
      paddleVga              : out std_logic_vector(11 downto 0));
  end component;

  component breakout_control
    port (
      clk                : in  std_logic;
      reset              : in  std_logic;
      programBallSpeedX  : in  std_logic_vector(1 downto 0);
      programBallSpeedY  : in  std_logic_vector(1 downto 0);
      programPaddleSpeed : in  std_logic_vector(1 downto 0);
      ballSpeedX         : out std_logic_vector(NUM_H_BITS-1 downto 0);
      ballSpeedY         : out std_logic_vector(NUM_V_BITS-1 downto 0);
      blockVGA           : in  blockVgaArray;
      paddleVGA          : in  std_logic_vector(11 downto 0);
      ballVGA            : in  std_logic_vector(11 downto 0);
      vgaRed             : out std_logic_vector(3 downto 0);
      vgaGreen           : out std_logic_vector(3 downto 0);
      vgaBlue            : out std_logic_vector(3 downto 0);
      scoreOnes          : out std_logic_vector(3 downto 0);
      scoreTens          : out std_logic_vector(3 downto 0);
      scoreHundreds      : out std_logic_vector(3 downto 0);
      scoreThousands     : out std_logic_vector(3 downto 0);
      paddleSpeed        : out std_logic_vector(NUM_H_BITS-1 downto 0));
  end component;

  component breakout_block_control
    generic (
      BLOCK_COLOR   : std_logic_vector(11 downto 0)           := "111111111111";
      BLOCK_START_X : std_logic_vector(NUM_H_BITS-1 downto 0) := (others => '0');
      BLOCK_START_Y : std_logic_vector(NUM_V_BITS-1 downto 0) := (others => '0');
      BLOCK_END_X   : std_logic_vector(NUM_H_BITS-1 downto 0) := (others => '0');
      BLOCK_END_Y   : std_logic_vector(NUM_V_BITS-1 downto 0) := (others => '0'));
    port (
      clk                   : in  std_logic;
      reset                 : in  std_logic;
      ballSpeedX            : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballSpeedY            : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      pixelPositionX        : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      pixelPositionY        : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      ballPositionCenterX   : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionCenterY   : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      blockVGA              : out std_logic_vector(11 downto 0);
      blockUpdateXDirection : out std_logic;
      blockUpdateYDirection : out std_logic);
  end component;

  component breakout_ball_control
    generic (
      BALL_COLOR               : std_logic_vector(11 downto 0)           := (others => '1'));
    port (
      clk                    : in  std_logic;
      reset                  : in  std_logic;
      pauseGame              : in  std_logic;
      gameLost               : out std_logic;
      blockUpdateXDirection  : in  blockUpdateDirectionArray;
      blockUpdateYDirection  : in  blockUpdateDirectionArray;
      paddleUpdateYDirection : in  std_logic;
      ballPositionStartX     : out std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionStartY     : out std_logic_vector(NUM_V_BITS-1 downto 0);
      ballPositionEndX       : out std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionEndY       : out std_logic_vector(NUM_V_BITS-1 downto 0);
      ballPositionCenterX       : out std_logic_vector(NUM_H_BITS-1 downto 0);
      ballPositionCenterY       : out std_logic_vector(NUM_V_BITS-1 downto 0);     
      ballWithinPaddleX      : in  std_logic;
      pixelPositionX         : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      pixelPositionY         : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      ballSpeedX             : in  std_logic_vector(NUM_H_BITS-1 downto 0);
      ballSpeedY             : in  std_logic_vector(NUM_V_BITS-1 downto 0);
      ballVGA                : out std_logic_vector(11 downto 0));
  end component;

  signal paddleUpdateYDirection : std_logic;
  signal ballPositionStartX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballPositionStartY : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal ballPositionEndX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballPositionEndY : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal ballPositionCenterX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballPositionCenterY : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal paddleVga : std_logic_vector(11 downto 0);
  signal blockVGA  : blockVgaArray;
  signal ballVGA   : std_logic_vector(11 downto 0);
  signal blockUpdateXDirection : blockUpdateDirectionArray;
  signal blockUpdateYDirection : blockUpdateDirectionArray;
  signal UpdateXDirection : std_logic;
  signal UpdateYDirection : std_logic;
  signal pauseGameButtonR1 : std_logic;
  signal pauseGame         : std_logic;
  signal gameLost : std_logic;
  signal ballSpeedX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballSpeedY : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal paddleSpeed : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal pixelPositionX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal pixelPositionY : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal ballWithinPaddleX : std_logic;

begin

  breakout_paddle : breakout_paddle_control
    generic map (
      PADDLE_COLOR   => "111111111111",
      PADDLE_START_X => PADDLE_START_X,
      PADDLE_START_Y => PADDLE_START_Y,
      PADDLE_END_X   => PADDLE_END_X,
      PADDLE_END_Y   => PADDLE_END_Y)
    port map (
      clk                    => clk,
      reset                  => reset,
      pauseGame              => pauseGame,
      gameLost               => gameLost,
      ballWithinPaddleX      => ballWithinPaddleX,
      pixelPositionY         => pixelPositionY,
      pixelPositionX         => pixelPositionX,
      ballPositionStartX     => ballPositionStartX,
      ballPositionStartY     => ballPositionStartY,
      ballPositionEndX       => ballPositionEndX,
      ballPositionEndY       => ballPositionEndY,
      movePaddleLeft         => movePaddleLeft,
      movePaddleRight        => movePaddleRight,
      paddleUpdateYDirection => paddleUpdateYDirection,
      paddleSpeed            => paddleSpeed,
      paddleVga              => paddleVga);

  block_generate_X : for x in 0 to 7 generate
    block_generate_Y : for y in 0 to 2 generate
      spawn_blocks : breakout_block_control
        generic map (
          BLOCK_COLOR   => "111111111111",
          BLOCK_START_X => conv_std_logic_vector(BLOCK_WIDTH * x, NUM_H_BITS),
          BLOCK_START_Y => conv_std_logic_vector(BLOCK_HEIGHT * y, NUM_V_BITS),
          BLOCK_END_X   => conv_std_logic_vector(BLOCK_WIDTH * x + BLOCK_WIDTH-1, NUM_H_BITS),
          BLOCK_END_Y   => conv_std_logic_vector(BLOCK_HEIGHT * y + BLOCK_HEIGHT-1, NUM_V_BITS))
        port map(
          clk                   => clk,
          reset                 => reset,
          ballSpeedX            => ballSpeedX,
          ballSpeedY            => ballSpeedY,
          pixelPositionX        => pixelPositionX,
          pixelPositionY        => pixelPositionY,
          ballPositionCenterX    => ballPositionCenterX,
          ballPositionCenterY    => ballPositionCenterY,
          blockVGA              => blockVGA(x, y),
          blockUpdateXDirection => blockUpdateXDirection(x, y),
          blockUpdateYDirection => blockUpdateYDirection(x, y));
    end generate block_generate_Y;
  end generate block_generate_X;

  ball_control : breakout_ball_control
    port map (
      clk                    => clk,
      reset                  => reset,
      pauseGame              => pauseGame,
      ballWithinPaddleX      => ballWithinPaddleX,
      gameLost               => gameLost,
      ballSpeedX             => ballSpeedX,
      ballSpeedY             => ballSpeedY,
      ballPositionStartX     => ballPositionStartX,
      ballPositionStartY     => ballPositionStartY,
      ballPositionEndX       => ballPositionEndX,
      ballPositionEndY       => ballPositionEndY,
      ballPositionCenterX    => ballPositionCenterX,
      ballPositionCenterY    => ballPositionCenterY,    
      pixelPositionY         => pixelPositionY,
      pixelPositionX         => pixelPositionX,
      blockUpdateXDirection  => blockUpdateXDirection,
      blockUpdateYDirection  => blockUpdateYDirection,
      paddleUpdateYDirection => paddleUpdateYDirection,
      ballVGA                => ballVGA);

  breakout_ctrl : breakout_control
    port map (
      clk                => clk,
      reset              => reset,
      programBallSpeedX  => programBallSpeedX,
      programBallSpeedY  => programBallSpeedY,
      ballSpeedX         => ballSpeedX,
      ballSpeedY         => ballSpeedY,
      programPaddleSpeed => programPaddleSpeed,
      paddleSpeed        => paddleSpeed,
      blockVGA           => blockVGA,
      paddleVGA          => paddleVGA,
      ballVGA            => ballVGA,
      vgaRed             => vgaRed,
      vgaBlue            => vgaBlue,
      vgaGreen           => vgaGreen,
      scoreOnes          => scoreOnes,
      scoreTens          => scoreTens,
      scoreHundreds      => scoreHundreds,
      scoreThousands     => scoreThousands);

  process (clk)
  begin
    if rising_edge(clk) then
      -- On reset, clear registers and drive the game state to pause to start
      if (reset = '1') then
        pauseGame         <= '1';
        pauseGameButtonR1 <= '0';
      else
        if (pauseGameButton = '1' and pauseGameButtonR1 = '0') then
          pauseGame <= not pauseGame;
        end if;
      end if;

      pauseGameButtonR1 <= pauseGameButton;
    end if;
  end process;

  u_vga_controller : vga_controller
    generic map (
      H_PIXELS       => H_PIXELS,
      H_FRONT_PORCH  => H_FRONT_PORCH,
      H_SYNC_PULSE   => H_SYNC_PULSE,
      H_BACK_PORCH   => H_BACK_PORCH,
      H_POLARITY     => H_POLARITY,
      H_PERIOD       => H_PERIOD,
      NUM_H_BITS     => NUM_H_BITS,
      --
      V_PIXELS       => V_PIXELS,
      V_FRONT_PORCH  => V_FRONT_PORCH,
      V_SYNC_PULSE   => V_SYNC_PULSE,
      V_BACK_PORCH   => V_BACK_PORCH,
      V_POLARITY     => V_POLARITY,
      V_PERIOD       => V_PERIOD,
      NUM_V_BITS     => NUM_V_BITS,
      --
      USE_CLK_ENABLE => '0')
    port map (
      clk            => clk,
      clkEnable      => '0',
      reset          => reset,
      vgaSyncH       => vgaSyncH,
      vgaSyncV       => vgaSyncV,
      pixelPositionX => pixelPositionX,
      pixelPositionY => pixelPositionY);

  led(0) <= pauseGame;
  led(1) <= gameLost;
  led(2) <= '0';
  led(3) <= '0';

end behavior;
