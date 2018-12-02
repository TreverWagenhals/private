library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.breakout_package.all;


entity breakout_control is
  port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    programBallSpeedX  : in  std_logic_vector(1 downto 0);
    programBallSpeedY  : in  std_logic_vector(1 downto 0);
    programPaddleSpeed : in  std_logic_vector(1 downto 0);
    paddleVGA          : in  std_logic_vector(11 downto 0);
    ballVGA            : in  std_logic_vector(11 downto 0);
    blockVGA           : in  blockVgaArray;
    vgaRed             : out std_logic_vector(3 downto 0);
    vgaGreen           : out std_logic_vector(3 downto 0);
    vgaBlue            : out std_logic_vector(3 downto 0);
    scoreOnes          : out std_logic_vector(3 downto 0);
    scoreTens          : out std_logic_vector(3 downto 0);
    scoreHundreds      : out std_logic_vector(3 downto 0);
    scoreThousands     : out std_logic_vector(3 downto 0);
    ballSpeedX         : out std_logic_vector(NUM_H_BITS-1 downto 0);
    ballSpeedY         : out std_logic_vector(NUM_V_BITS-1 downto 0);
    paddleSpeed        : out std_logic_vector(NUM_H_BITS-1 downto 0));
end breakout_control;


architecture behavior of breakout_control is

  signal vga           : std_logic_vector(11 downto 0);
  signal finalBlockVGA : std_logic_vector(11 downto 0);
  
begin

  -- We want to OR reduce all of the block's together into a final blockVGA value
  -- This is fine to do because a block will send all 0's, representing black
  finalBlockVGA <= blockVGA(0, 0) or blockVGA(1, 0) or blockVGA(2, 0) or blockVGA(3, 0) or
                   blockVGA(4, 0) or blockVGA(5, 0) or blockVGA(6, 0) or blockVGA(7, 0) or
                   blockVGA(0, 1) or blockVGA(1, 1) or blockVGA(2, 1) or blockVGA(3, 1) or
                   blockVGA(4, 1) or blockVGA(5, 1) or blockVGA(6, 1) or blockVGA(7, 1) or
                   blockVGA(0, 2) or blockVGA(1, 2) or blockVGA(2, 2) or blockVGA(3, 2) or
                   blockVGA(4, 2) or blockVGA(5, 2) or blockVGA(6, 2) or blockVGA(7, 2);

  -- OR the ball, paddle, and blocks together to get the final vga value
  VGA <= paddleVGA or ballVGA or finalBlockVGA;

  scoreOnes      <= "0001";
  scoreTens      <= "0011";
  scoreHundreds  <= "0011";
  scoreThousands <= "0111";

  process (clk)
  begin
    if rising_edge(clk) then

      if (reset = '1') then
        vgaRed   <= (others => '0');
        vgaGreen <= (others => '0');
        vgaBlue  <= (others => '0');
      else

        vgaRed   <= vga(11 downto 8);
        vgaGreen <= vga(7 downto 4);
        vgaBlue  <= vga(3 downto 0);

        case programBallSpeedX is

          when "00" =>
            ballSpeedX <= MOVE_X_AXIS_QUARTER_SECOND;
          when "01" =>
            ballSpeedX <= MOVE_X_AXIS_HALF_SECOND;
          when "10" =>
            ballSpeedX <= MOVE_X_AXIS_1_SECOND;
          when "11" =>
            ballSpeedX <= MOVE_X_AXIS_2_SECOND;
          when others =>
            ballSpeedX <= (others => 'X');
        end case;

        case programBallSpeedY is

          when "00" =>
            ballSpeedY <= MOVE_Y_AXIS_QUARTER_SECOND;
          when "01" =>
            ballSpeedY <= MOVE_Y_AXIS_HALF_SECOND;
          when "10" =>
            ballSpeedY <= MOVE_Y_AXIS_1_SECOND;
          when "11" =>
            ballSpeedY <= MOVE_Y_AXIS_2_SECOND;
          when others =>
            ballSpeedY <= (others => 'X');
        end case;

        case programPaddleSpeed is

          when "00" =>
            paddleSpeed <= MOVE_X_AXIS_QUARTER_SECOND;
          when "01" =>
            paddleSpeed <= MOVE_X_AXIS_HALF_SECOND;
          when "10" =>
            paddleSpeed <= MOVE_X_AXIS_1_SECOND;
          when "11" =>
            paddleSpeed <= MOVE_X_AXIS_2_SECOND;
          when others =>
            paddleSpeed <= (others => 'X');
        end case;



      end if;
    end if;
  end process;

end behavior;
