library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use IEEE.math_real.all;

library work;
use work.breakout_package.all;


entity breakout_paddle_control is
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
    paddleUpdateYDirection : out std_logic;
    paddleSpeed            : in  std_logic_vector(NUM_H_BITS-1 downto 0);
    paddleVga              : out std_logic_vector(11 downto 0));
end breakout_paddle_control;


architecture behavior of breakout_paddle_control is

  type stateMachine is (idle, updateBallDirection, updatePaddlePosition);
  signal currentState : stateMachine;

  signal ballWithinPaddleXTemp : std_logic;
  signal ballWithinPaddleY     : std_logic;
  signal ballWithinPaddle      : std_logic;

  signal paddleXPixelStart : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal paddleXPixelEnd   : std_logic_vector(NUM_H_BITS-1 downto 0);

  signal pixelWithinPaddleX : std_logic;
  signal pixelWithinPaddleY : std_logic;
  signal pixelWithinPaddle  : std_logic;



begin

  -- Keep track of when the current pixel being looked at is one of the paddle pixels
  pixelWithinPaddleX <= '1' when unsigned(pixelPositionX) >= unsigned(paddleXPixelStart) and unsigned(pixelPositionX) <= unsigned(paddleXPixelEnd) else '0';
  pixelWithinPaddleY <= '1' when pixelPositionY >= PADDLE_START_Y and pixelPositionY <= PADDLE_END_Y                                               else '0';
  pixelWithinPaddle  <= pixelWithinPaddleX and pixelWithinPaddleY;

  ballWithinPaddleXTemp <= '1' when (unsigned(ballPositionStartX) >= unsigned(paddleXPixelStart) and unsigned(ballPositionStartX) <= unsigned(paddleXPixelEnd)) or
(unsigned(ballPositionEndX) >= unsigned(paddleXPixelStart) and unsigned(ballPositionEndX) <= unsigned(paddleXPixelEnd)) else '0';
  ballWithinPaddleY <= '1' when (unsigned(ballPositionStartY) >= unsigned(PADDLE_START_Y) and unsigned(ballPositionStartY) <= unsigned(PADDLE_END_Y)) or
(unsigned(ballPositionEndY) >= unsigned(PADDLE_START_Y) and unsigned(ballPositionEndY) <= unsigned(PADDLE_END_Y)) else '0';
  ballWithinPaddle <= ballWithinPaddleY and ballWithinPaddleXTemp;

  process (clk)
  begin

    if rising_edge(clk) then

      if (reset = '1') then
        currentState           <= idle;
        paddleUpdateYDirection <= '0';
        paddleXPixelStart      <= PADDLE_START_X;
        paddleXPixelEnd        <= PADDLE_END_X;
      else

        ballWithinPaddleX <= ballWithinPaddleXTemp;

        if pixelWithinPaddle = '1' then
          paddleVga <= PADDLE_COLOR;
        else
          paddleVga <= (others => '0');
        end if;

        case currentState is
          when idle =>

            -- Whenever we reach the last graphical pixel, it means the blanking period is about to start
            -- During this time, we want to update the ball for the next frame
            if (conv_integer(unsigned(pixelPositionY)) = V_PIXELS-1 and conv_integer(unsigned(pixelPositionX)) = H_PIXELS-1) then
              currentState <= updateBallDirection;
            end if;

          when updateBallDirection =>

            if (ballWithinPaddle = '1') then
              paddleUpdateYDirection <= '1';
            end if;

            currentState <= updatePaddlePosition;

          when updatePaddlePosition =>

            -- Wait until the last frame pixel to update the position of the ball. We also assert the 
            -- update signal until we have to turn it off to minimize timing considerations
            if (unsigned(pixelPositionY) = V_PERIOD-1 and unsigned(pixelPositionX) = H_PERIOD-1) then
                currentState <= idle;
                paddleUpdateYDirection <= '0';

                if (pauseGame = '0' and gameLost = '0') then
    
                  if movePaddleRight = '1' then
    
                    if (unsigned(paddleXPixelEnd) + unsigned(paddleSpeed) >= H_PIXELS) then
    
                      paddleXPixelStart <= H_PIXELS - unsigned(PADDLE_WIDTH);
                      paddleXPixelEnd   <= conv_std_logic_vector(H_PIXELS - 1, paddleXPixelEnd'length);
    
                    else
    
                      paddleXPixelStart <= unsigned(paddleXPixelStart) + unsigned(paddleSpeed);
                      paddleXPixelEnd   <= unsigned(paddleXPixelEnd) + unsigned(paddleSpeed);
    
                    end if;
    
                  elsif movePaddleLeft = '1' then
    
                    if (unsigned(paddleXPixelStart) - unsigned(paddleSpeed) > unsigned(paddleXPixelStart)) then
    
                      paddleXPixelStart <= (others => '0');
                      paddleXPixelEnd   <= PADDLE_WIDTH;
    
                    else
    
                      paddleXPixelStart <= unsigned(paddleXPixelStart) - unsigned(paddleSpeed);
                      paddleXPixelEnd   <= unsigned(paddleXPixelEnd) - unsigned(paddleSpeed);
    
                    end if;
    
                  end if;
                end if;
              end if;

        end case;
      end if;

    end if;




  end process;

end behavior;
