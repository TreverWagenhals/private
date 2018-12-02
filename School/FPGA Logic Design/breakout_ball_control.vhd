library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

library work;
use work.breakout_package.all;

entity breakout_ball_control is
  generic (
    BALL_COLOR : std_logic_vector(11 downto 0) := (others => '1'));
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
    ballPositionCenterX    : out std_logic_vector(NUM_H_BITS-1 downto 0);
    ballPositionCenterY    : out std_logic_vector(NUM_V_BITS-1 downto 0);
    ballWithinPaddleX      : in  std_logic;
    pixelPositionX         : in  std_logic_vector(NUM_H_BITS-1 downto 0);
    pixelPositionY         : in  std_logic_vector(NUM_V_BITS-1 downto 0);
    ballSpeedX             : in  std_logic_vector(NUM_H_BITS-1 downto 0);
    ballSpeedY             : in  std_logic_vector(NUM_V_BITS-1 downto 0);
    ballVGA                : out std_logic_vector(11 downto 0));
end breakout_ball_control;

architecture behavior of breakout_ball_control is

  type stateMachine is (idle, updateBallDirection, updateBallPosition);

  signal ballState : stateMachine;

  -- Determines if the current VGA pixel is a ball pixel to display the correct VGA value
  signal validXPixel : std_logic;
  signal validYPixel : std_logic;
  signal displayBall : std_logic;

  -- Keep track of which directions the ball is moving
  signal movingRight : std_logic;
  signal movingDown  : std_logic;


  signal gameLostTemp : std_logic;


  signal ballStartX  : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballEndX    : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballStartY  : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal ballEndY    : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal ballCenterX : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal ballCenterY : std_logic_vector(NUM_V_BITS-1 downto 0);

  -- Keep track of the new positions of the ball's corners
  -- We need to keep track of each positions because each wall looks at a different side of the ball
  -- to determine if it was hit
  -- There is a sum and diff based on the direction the ball is moving
  signal newBallEndY                  : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallEndYSum               : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallEndYSumOverflow       : std_logic;
  signal newBallEndYSumFinal          : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallEndYDiff              : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallEndYDiffOverflow      : std_logic;
  signal newBallEndYDiffFinal         : std_logic_vector(NUM_V_BITS-1 downto 0);
  --
  signal newBallEndX                  : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallEndXSum               : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallEndXSumOverflow       : std_logic;
  signal newBallEndXSumFinal          : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallEndXDiff              : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallEndXDiffOverflow      : std_logic;
  signal newBallEndXDiffFinal         : std_logic_vector(NUM_H_BITS-1 downto 0);
  --
  signal newBallStartX                : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallStartXSum             : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallStartXSumOverflow     : std_logic;
  signal newBallStartXSumFinal        : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallStartXDiff            : std_logic_vector(NUM_H_BITS-1 downto 0);
  signal newBallStartXDiffOverflow    : std_logic;
  signal newBallStartXDiffFinal       : std_logic_vector(NUM_H_BITS-1 downto 0);
  --
  signal newBallStartY                : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallStartYSum             : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallStartYSumOverflow     : std_logic;
  signal newBallStartYSumFinal        : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallStartYDiff            : std_logic_vector(NUM_V_BITS-1 downto 0);
  signal newBallStartYDiffOverflow    : std_logic;
  signal newBallStartYDiffFinal       : std_logic_vector(NUM_V_BITS-1 downto 0);
  --
  signal updateYDirection             : std_logic;
  signal updateXDirection             : std_logic;
  signal blockUpdateXDirectionReduced : std_logic;
  signal blockUpdateYDirectionReduced : std_logic;

begin

  blockUpdateYDirectionReduced <= blockUpdateYDirection(0, 0) or blockUpdateYDirection(1, 0) or blockUpdateYDirection(2, 0) or blockUpdateYDirection(3, 0) or
                                  blockUpdateYDirection(4, 0) or blockUpdateYDirection(5, 0) or blockUpdateYDirection(6, 0) or blockUpdateYDirection(7, 0) or
                                  blockUpdateYDirection(0, 1) or blockUpdateYDirection(1, 1) or blockUpdateYDirection(2, 1) or blockUpdateYDirection(3, 1) or
                                  blockUpdateYDirection(4, 1) or blockUpdateYDirection(5, 1) or blockUpdateYDirection(6, 1) or blockUpdateYDirection(7, 1) or
                                  blockUpdateYDirection(0, 2) or blockUpdateYDirection(1, 2) or blockUpdateYDirection(2, 2) or blockUpdateYDirection(3, 2) or
                                  blockUpdateYDirection(4, 2) or blockUpdateYDirection(5, 2) or blockUpdateYDirection(6, 2) or blockUpdateYDirection(7, 2);

  blockUpdateXDirectionReduced <= blockUpdateXDirection(0, 0) or blockUpdateXDirection(1, 0) or blockUpdateXDirection(2, 0) or blockUpdateXDirection(3, 0) or
                                  blockUpdateXDirection(4, 0) or blockUpdateXDirection(5, 0) or blockUpdateXDirection(6, 0) or blockUpdateXDirection(7, 0) or
                                  blockUpdateXDirection(0, 1) or blockUpdateXDirection(1, 1) or blockUpdateXDirection(2, 1) or blockUpdateXDirection(3, 1) or
                                  blockUpdateXDirection(4, 1) or blockUpdateXDirection(5, 1) or blockUpdateXDirection(6, 1) or blockUpdateXDirection(7, 1) or
                                  blockUpdateXDirection(0, 2) or blockUpdateXDirection(1, 2) or blockUpdateXDirection(2, 2) or blockUpdateXDirection(3, 2) or
                                  blockUpdateXDirection(4, 2) or blockUpdateXDirection(5, 2) or blockUpdateXDirection(6, 2) or blockUpdateXDirection(7, 2);

  updateYDirection <= blockUpdateYDirectionReduced or paddleUpdateYDirection;
  updateXDirection <= blockUpdateXDirectionReduced;

  -- Determine if the current pixel being looked at is a valid ball pixel
  -- We need to determine this for the X axis and Y axis.
  -- The ball is currently designed as a square. Pixels are added to each side of the center pixel
  -- to make the ball larger than a single pixel.
  validXPixel <= '1' when unsigned(pixelPositionX) >= unsigned(ballStartX) and unsigned(pixelPositionX) <= unsigned(ballEndX) else '0';
  validYPixel <= '1' when unsigned(pixelPositionY) >= unsigned(ballStartY) and unsigned(pixelPositionY) <= unsigned(ballEndY) else '0';
  displayBall <= validXPixel and validYPixel;

  -- VHDL 1993 does not allow for outputs to be read, so temp signals are used within the logic.
  -- This assignment will allow for reading functionality and the output to remain a flop
  -- instead of combinational logic since the synthesizer will identify the flop
  gameLost            <= gameLostTemp;
  ballPositionStartX  <= ballStartX;
  ballPositionStartY  <= ballStartY;
  ballPositionEndX    <= ballEndX;
  ballPositionEndY    <= ballEndY;
  ballPositionCenterX <= ballCenterX;
  ballPositionCenterY <= ballCenterY;

  newBallEndYSum          <= unsigned(ballEndY) + unsigned(ballSpeedY);
  newBallEndYSumOverflow  <= '1'                 when unsigned(newBallEndYSum) < unsigned(ballEndY) or (unsigned(newBallEndYSum) > V_PIXELS-1) else '0';
  newBallEndYSumFinal     <= newBallEndYSum      when newBallEndYSumOverflow = '0'                                                             else conv_std_logic_vector(V_PIXELS-1, NUM_V_BITS);
  newBallEndYDiff         <= unsigned(ballEndY) - unsigned(ballSpeedY);
  newBallEndYDiffOverflow <= '1'                 when unsigned(newBallEndYDiff) > unsigned(ballEndY)                                           else '0';
  newBallEndYDiffFinal    <= newBallEndYdiff     when newBallEndYDiffOverflow = '0'                                                             else conv_std_logic_vector(BALL_PIXEL_HEIGHT-1, NUM_V_BITS);
  newBallEndY             <= newBallEndYSumFinal when movingDown = '1'                                                                         else newBallEndYDiffFinal;

  newBallEndXSum          <= unsigned(ballEndX) + unsigned(ballSpeedX);
  newBallEndXSumOverflow  <= '1'                 when unsigned(newBallEndXSum) < unsigned(ballEndX) or (unsigned(newBallEndXSum) > H_PIXELS-1) else '0';
  newBallEndXSumFinal     <= newBallEndXSum      when newBallEndXSumOverflow = '0'                                                             else conv_std_logic_vector(H_PIXELS-1, NUM_V_BITS);
  newBallEndXDiff         <= unsigned(ballEndX) - unsigned(ballSpeedX);
  newBallEndXDiffOverflow <= '1'                 when unsigned(newBallEndXDiff) > unsigned(ballEndX)                                           else '0';
  newBallEndXDiffFinal    <= newBallEndXdiff     when newBallEndXDiffOverflow = '0'                                                             else conv_std_logic_vector(BALL_PIXEL_WIDTH-1, NUM_H_BITS);
  newBallEndX             <= newBallEndXSumFinal when movingRight = '1'                                                                        else newBallEndXDiffFinal;

  newBallStartXSum          <= unsigned(ballStartX) + unsigned(ballSpeedX);
  newBallStartXSumOverflow  <= '1'                   when unsigned(newBallStartXSum) < unsigned(ballStartX) or unsigned(newBallStartXSum) > H_PIXELS-1    else '0';
  newBallStartXSumFinal     <= newBallStartXSum      when newBallStartXSumOverflow = '0'                     else conv_std_logic_vector(H_PIXELS-1 - (BALL_PIXEL_WIDTH-1), NUM_H_BITS);
  newBallStartXDiff         <= unsigned(ballStartX) - unsigned(ballSpeedX);
  newBallStartXDiffOverflow <= '1'                   when unsigned(newBallStartXDiff) > unsigned(ballStartX) else '0';
  newBallStartXDiffFinal    <= newBallStartXdiff     when newBallStartXDiffOverflow = '0'                     else (others => '0');
  newBallStartX             <= newBallStartXSumFinal when movingRight = '1'                                  else newBallStartXDiffFinal;

  newBallStartYSum          <= unsigned(ballStartY) + unsigned(ballSpeedY);
  newBallStartYSumOverflow  <= '1'                   when unsigned(newBallStartY) < unsigned(ballStartY) or unsigned(newBallStartYSum) > V_PIXELS-1    else '0';
  newBallStartYSumFinal     <= newBallStartYSum      when newBallStartYSumOverflow = '0'                     else conv_std_logic_vector(V_PIXELS-1 - (BALL_PIXEL_HEIGHT-1), NUM_V_BITS);
  newBallStartYDiff         <= unsigned(ballStartY) - unsigned(ballSpeedY);
  newBallStartYDiffOverflow <= '1'                   when unsigned(newBallStartYDiff) > unsigned(ballStartY) else '0';
  newBallStartYDiffFinal    <= newBallStartYdiff     when newBallStartYDiffOverflow = '0'                     else (others => '0');
  newBallStartY             <= newBallStartYSumFinal when movingDown = '1'                                   else newBallStartYDiffFinal;

  process (clk)
  begin
    if rising_edge(clk) then

      if (reset = '1') then

        ballStartY  <= BALL_POSITION_START_Y;
        ballStartX  <= BALL_POSITION_START_X;
        ballEndX    <= BALL_POSITION_END_X;
        ballEndY    <= BALL_POSITION_END_Y;
        ballCenterX <= BALL_POSITION_CENTER_X;
        ballCenterY <= BALL_POSITION_CENTER_Y;

        -- The ball always starts by moving downward and to the right
        movingRight <= '1';
        movingDown  <= '1';

        -- The lost state de-asserted on reset
        gameLostTemp <= '0';
      else

        -- Whenever the current pixel is a pixel of the ball, 
        if (displayBall = '1') then
          ballVGA <= BALL_COLOR;
        else
          ballVGA <= (others => '0');
        end if;

        case ballState is

          when idle =>

            -- two pixels before the end of the frame, we want to check if anything has signaled to update the ball
            -- We wait until two pixels before the frame to give one more cycle to actually update the position of
            -- the ball and a nice way of making sure that other blocks that generate update signals have time to
            -- propogate without having to worry about timing. 
            if (conv_integer(unsigned(pixelPositionY)) = V_PERIOD-1 and conv_integer(unsigned(pixelPositionX)) = H_PERIOD-3) then
              ballState <= updateBallDirection;
            end if;


          when updateBallDirection =>

            -- Something has signaled that the path of the ball should change within the X direction
            -- An outside block or paddle might signal to update the direction. The direction should also
            -- be updated if the ball is hitting the left or right walls as well.
            if updateXDirection = '1' or unsigned(ballStartX) = 0 or unsigned(ballEndX) = H_PIXELS-1 then
              movingRight <= not movingRight;
            end if;

            -- Something has signaled that the path of the ball should change within the Y direction
            -- An outside block or paddle has signaled to change Y direction.
            -- The ball should also switch directions when the top wall is hit
            -- The ball doesn't change directions when the bottom wall is hit since that is a lose condition
            if updateYDirection = '1' or unsigned(ballStartY) = 0 then
              movingDown <= not movingDown;
            end if;

            -- If the ball hits the last Y pixel, the game is over
            if unsigned(ballEndY) = V_PIXELS-1 then
              gameLostTemp <= '1';
            end if;

            ballState <= updateBallPosition;

          when updateBallPosition =>

            if (pauseGame = '0' and gameLostTemp = '0') then

              -- The ball is moving right, which means we want to ADD to the current ball position to move it further right
              if movingRight = '1' then

                ballEndX <= newBallEndX;

                -- On edge conditions, moving right can cause us to advance to a pixel value that is above the display pixels
                -- newBallEndX automatically calibrates to be the last pixel if this is the case, so we can just check to 
                -- see if that is true and determine the other ball positions values
                if (unsigned(newBallEndX) = H_PIXELS-1) then
                  ballStartX  <= conv_std_logic_vector(H_PIXELS-1 - (BALL_PIXEL_WIDTH-1), NUM_H_BITS);
                  ballCenterX <= conv_std_logic_vector(H_PIXELS-1 - ((BALL_PIXEL_WIDTH-1)/2), NUM_H_BITS);
                -- Moving right does not cause overflow, so the next position is correct
                else
                  ballStartX  <= newBallStartX;
                  ballCenterX <= unsigned(newBallStartX) + ((BALL_PIXEL_WIDTH-1)/2);
                end if;

              else

                ballStartX <= newBallStartX;

                if (unsigned(newBallStartX) = 0) then
                  ballEndX    <= conv_std_logic_vector(BALL_PIXEL_WIDTH - 1, NUM_H_BITS);
                  ballCenterX <= conv_std_logic_vector((BALL_PIXEL_WIDTH - 1) / 2, NUM_H_BITS);
                else
                  ballEndX    <= newBallEndX;
                  ballCenterX <= unsigned(newBallStartX) + ((BALL_PIXEL_WIDTH-1)/2);
                end if;

              end if;

              if movingDown = '1' then

                -- When moving the ball down, it's possible that the Y advancedment is so large that the center pixel
                -- of the ball is below the paddle, and thus never recognizes the hit. We need to check to see 
                -- if updating to the new position causes us to advance past the lowest paddle pixel
                -- while we are within the paddle's x axis. This signifies that the ball will move to a position past the paddle
                -- and should be corrected
                if unsigned(newBallEndY) >= unsigned(PADDLE_END_Y) and unsigned(ballEndY) < unsigned(PADDLE_START_Y) and ballWithinPaddleX = '1' then
                  ballEndY    <= PADDLE_START_Y;
                  ballStartY  <= unsigned(PADDLE_START_Y) - BALL_PIXEL_HEIGHT-1;
                  ballCenterY <= unsigned(PADDLE_START_Y) - ((BALL_PIXEL_HEIGHT-1)/2);
                -- On edge conditions, moving down can cause us to advance to a pixel value that is above the display pixels
                -- newBallEndY is calibrated to avoid overflow and is set to the very last pixel if this is the case
                -- So, if we check and the ball happens to be at this pixel, then we know the pixels of the ball
                elsif (unsigned(newBallEndY) = V_PIXELS-1) then
                  ballStartY  <= conv_std_logic_vector(V_PIXELS-1 - (BALL_PIXEL_WIDTH-1), NUM_V_BITS);
                  ballCenterY <= conv_std_logic_vector(V_PIXELS-1 - ((BALL_PIXEL_WIDTH-1)/2), NUM_V_BITS);
                  ballEndY    <= conv_std_logic_vector(V_PIXELS-1, NUM_V_BITS);
                else
                  ballStartY  <= newBallStartY;
                  ballEndY    <= newBallEndY;
                  ballCenterY <= unsigned(newBallStartY) + ((BALL_PIXEL_HEIGHT-1)/2);
                end if;

              else

                ballStartY <= newBallStartY;

                -- On edge conditions, newBallStartY is calibrated to be 0 if underflow was going to occur
                -- So, if the newBallStartY = 0, it means that the ball's position was calibrated to not go off screen
                -- The end and center positions are not calibrated though when moving up, so they need to be manually corrected here
                if (unsigned(newBallStartY) = 0) then
                  ballEndY    <= conv_std_logic_vector(BALL_PIXEL_HEIGHT-1, NUM_V_BITS);
                  ballCenterY <= conv_std_logic_vector(((BALL_PIXEL_HEIGHT-1)/2), NUM_V_BITS);
                -- All other times moving up is safe, so just move to the new ball positions
                else
                  ballEndY    <= newBallEndY;
                  ballCenterY <= unsigned(newBallStartY) + (BALL_PIXEL_HEIGHT-1)/2;
                end if;

              end if;
            end if;

            -- Advance to next state
            ballState <= idle;


        end case;
      end if;
    end if;
  end process;
end behavior;
