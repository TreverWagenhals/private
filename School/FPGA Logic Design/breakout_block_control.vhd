library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.breakout_package.all;

entity breakout_block_control is
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
end breakout_block_control;


architecture behavior of breakout_block_control is

  type stateMachine is (idle, syncPixel, blockRemoved);

  signal currentState : stateMachine;

  signal displayBlock : std_logic;
  signal blockPixel   : std_logic;

  signal validXPosition : std_logic;
  signal ValidYPosition : std_logic;

  signal ballWithinBlockX : std_logic;
  signal ballWithinBlockY : std_logic;
  signal ballWithinBlock  : std_logic;

  signal leftSideHit   : std_logic;
  signal rightSideHit  : std_logic;
  signal bottomSideHit : std_logic;
  signal topSideHit    : std_logic;

  signal VGA : std_logic_vector(11 downto 0);

  signal updateXDirection : std_logic;
  signal updateYDirection : std_logic;
  signal updateDirection  : std_logic;

begin

  process (clk)
  begin

    if rising_edge(clk) then

      if (reset = '1') then
        currentState     <= idle;
        displayBlock     <= '1';
        updateXDirection <= '0';
        updateYDirection <= '0';
      else

        blockVGA <= VGA;

        case currentState is
          when idle =>

            -- whenever we get to the last graphical pixel, we should move to the next state
            -- During the blanking period state, we want to signal if the block has been hit
            if unsigned(pixelPositionX) = H_PIXELS-1 and unsigned(pixelPositionY) = V_PIXELS-1 then
                currentState <= syncPixel;
                updateXDirection <= leftSideHit or rightSideHit;
                updateYDirection <= topSideHit or bottomSideHit;
            end if;

          when syncPixel =>

            -- whenever we get to the last blanking pixel, we're going to decide whether the block has been removed or not
            -- if it's removed, we go to the removed state, otherwise we go idle for the next frame
            if unsigned(pixelPositionX) = H_PERIOD-1 and unsigned(pixelPositionY) = V_PERIOD-1 then

                -- We are in a sync period, which means this is the time to update the data for the next frame
                -- If the ball was within the block last frame, we are going to remove it
                if updateYDirection = '1' or updateXDirection = '1' then
                    currentState <= blockRemoved;
                else
                    currentState <= idle;
                end if;
                
                -- de-assert these now as the ball should have already checked them
                updateXDirection <= '0';
                updateYDirection <= '0';
            
            end if;
            
            

          when blockRemoved =>
            displayBlock          <= '0';
            currentState          <= blockRemoved;

        end case;
      end if;

    end if;

  end process;

  -- Determine if the current pixel's value is placed somewhere within the block by comparing the X and Y boundaries
  validXPosition <= '1' when unsigned(BLOCK_START_X) <= unsigned(pixelPositionX) and unsigned(BLOCK_END_X) >= unsigned(pixelPositionX) else '0';
  validYPosition <= '1' when unsigned(BLOCK_START_Y) <= unsigned(pixelPositionY) and unsigned(BLOCK_END_Y) >= unsigned(pixelPositionY) else '0';
  -- The pixel is only considered a block pixel when the position within the X and Y axis are correct
  blockPixel     <= validXPosition and validYPosition;

  -- The output VGA color. This is only valid while displayBlock is valid to mark that the block has not been hit yet
  -- Also, the VGA color is only valid while the pixel being read is a pixel within the current block
  VGA <= BLOCK_COLOR when displayBlock = '1' and blockPixel = '1' else (others => '0');
  
  

  ballWithinBlockX <= '1' when unsigned(ballPositionCenterX) >= unsigned(BLOCK_START_X) and unsigned(ballPositionCenterX) <= unsigned(BLOCK_END_X) else '0';
  ballWithinBlockY <= '1' when unsigned(ballPositionCenterY) >= unsigned(BLOCK_START_Y) and unsigned(ballPositionCenterY) <= unsigned(BLOCK_END_Y) else '0';

  -- When the ball is past the start of the BLOCK_START_X and before BLOCK_START_X + ballSpeedX, a hit on the left side can occur (as long as the ball is within the block for the Y axis too)
  leftSideHit  <= '1' when unsigned(ballPositionCenterX) >= unsigned(BLOCK_START_X) and unsigned(ballPositionCenterX) <= unsigned(BLOCK_START_X) + unsigned(ballSpeedX) and ballWithinBlockY = '1' else '0';
  -- Same as left side, except we want to check if the ball is between BLOCK_END_X - ballSpeedX and BLOCK_END_X
  rightSideHit <= '1' when unsigned(ballPositionCenterX) >= unsigned(BLOCK_END_X) - unsigned(ballSpeedX) and unsigned(ballPositionCenterX) <= unsigned(BLOCK_END_X) and ballWithinBlockY = '1'   else '0';

  -- The top is hit when the ball's position is past the starting Y position. It also should be before the block's start position + ball speed so the entrance of the ball
  -- into the block isn't ignored. Also need to check if it's located in the correct X position to truly be a hit
  topSideHit    <= '1' when unsigned(ballPositionCenterY) >= unsigned(BLOCK_START_Y) and unsigned(ballPositionCenterY) <= unsigned(BLOCK_START_Y) + unsigned(ballSpeedY) and ballWithinBlockX = '1' else '0';
  -- The same concept as the top, except we want to be below BLOCK_END_Y but above BLOCK_END_Y + ballSpeedY
  bottomSideHit <= '1' when unsigned(ballPositionCenterY) >= unsigned(BLOCK_END_Y) - unsigned(ballSpeedY) and unsigned(ballPositionCenterY) <= unsigned(BLOCK_END_Y) and ballWithinBlockX = '1'   else '0';
  
  
  blockUpdateXDirection <= updateXDirection;
  blockUpdateYDirection <= updateYDirection;

end behavior;
