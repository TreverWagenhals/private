library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.math_real.all;

-- Package Declaration Section
package breakout_package is

  -- ONLY CHANGE THESE THREE VARIABLES
  -- Specify the desired VGA resolution and frequency and the rest of the needed configuration will be handled
  constant SET_RESOLUTION   : string := "1280x1024";
  constant FREQUENCY        : string := "100MHz";
  -- Specify the manufacturer for the MMCM/PLL instances to choose the correct one based on the environment
  constant MANUFACTURER     : string := "Xilinx";

  -- DONT CHANGE ANYTHING BELOW THIS LINE
  -- All of these constants should automatically be configured based on the  chosen 
  -- values for the resolution and frequency through these declared functions

  -- There are 8 blocks in each row of the array and 3 rows
  -- This type is used for making a 2D variables to store all of the updateDirection outputs for the blocks
  type blockUpdateDirectionArray is array(0 to 7, 0 to 2) of std_logic;
  type blockVgaArray is array(0 to 7, 0 to 2) of std_logic_vector(11 downto 0);

  function config_h_pixels (resolution      : string) return natural;
  function config_v_pixels (resolution      : string) return natural;
  function config_h_front_porch (resolution : string) return natural;
  function config_v_front_porch (resolution : string) return natural;
  function config_h_sync_pulse (resolution  : string) return natural;
  function config_v_sync_pulse (resolution  : string) return natural;
  function config_h_back_porch (resolution  : string) return natural;
  function config_v_back_porch (resolution  : string) return natural;
  function config_refresh_rate (resolution  : string) return natural;
  function config_h_polarity (resolution    : string) return std_logic;
  function config_v_polarity (resolution    : string) return std_logic;

  constant H_PIXELS                   : natural;
  constant V_PIXELS                   : natural;
  constant H_FRONT_PORCH              : natural;
  constant V_FRONT_PORCH              : natural;
  constant H_SYNC_PULSE               : natural;
  constant V_SYNC_PULSE               : natural;
  constant H_BACK_PORCH               : natural;
  constant V_BACK_PORCH               : natural;
  constant REFRESH_RATE               : natural;
  constant H_POLARITY                 : std_logic;
  constant V_POLARITY                 : std_logic;
  constant H_PERIOD                   : natural;
  constant V_PERIOD                   : natural;
  -- determine how many bits are needed to represent the largest value that we're going to count to for each counter
  constant NUM_H_BITS                 : natural;
  constant NUM_V_BITS                 : natural;
  constant BLOCK_WIDTH                : natural;
  constant BLOCK_HEIGHT               : natural;
  -- Paddle width is a function of the resolution. It will always start centered and be 1/4 of the entire horizontal width
  constant PADDLE_START_X             : std_logic_vector;
  constant PADDLE_END_X               : std_logic_vector;
  -- The paddle is always positioned 10 pixels above the bottom of the screen and is 10 pixels wide (Should this be changed?)
  constant PADDLE_START_Y             : std_logic_vector;
  constant PADDLE_END_Y               : std_logic_vector;
  constant PADDLE_WIDTH               : std_logic_vector;
  constant BALL_POSITION_CENTER_X     : std_logic_vector;
  constant BALL_POSITION_CENTER_Y     : std_logic_vector;
  constant BALL_PIXEL_WIDTH           : natural;
  constant BALL_PIXEL_HEIGHT          : natural;
  constant BALL_POSITION_START_X      : std_logic_vector;
  constant BALL_POSITION_END_X        : std_logic_vector;
  constant BALL_POSITION_START_Y      : std_logic_vector;
  constant BALL_POSITION_END_Y        : std_logic_vector;
  constant MOVE_X_AXIS_QUARTER_SECOND : std_logic_vector;
  constant MOVE_X_AXIS_HALF_SECOND    : std_logic_vector;
  constant MOVE_X_AXIS_1_SECOND       : std_logic_vector;
  constant MOVE_X_AXIS_2_SECOND       : std_logic_vector;
  constant MOVE_Y_AXIS_QUARTER_SECOND : std_logic_vector;
  constant MOVE_Y_AXIS_HALF_SECOND    : std_logic_vector;
  constant MOVE_Y_AXIS_1_SECOND       : std_logic_vector;
  constant MOVE_Y_AXIS_2_SECOND       : std_logic_vector;


end package breakout_package;

-- Package Body Section
package body breakout_package is

  function config_h_pixels (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 640;
    elsif (resolution = "1280x960") then return 1280;
    elsif (resolution = "1680x1050") then return 1680;
    elsif (resolution = "1600x1200") then return 1600;
    elsif (resolution = "1280x1024") then return 1280;
    else return 1280;
    end if;
  end function config_h_pixels;

  function config_v_pixels (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 480;
    elsif (resolution = "1280x960") then return 960;
    elsif (resolution = "1680x1050") then return 1050;
    elsif (resolution = "1600x1200") then return 1200;
    elsif (resolution = "1280x1024") then return 1024;
    else return 1024;
    end if;
  end function config_v_pixels;

  function config_h_front_porch(resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 16;
    elsif (resolution = "1280x960") then return 80;
    elsif (resolution = "1680x1050") then return 104;
    elsif (resolution = "1600x1200") then return 64;
    elsif (resolution = "1280x1024") then return 48;
    else return 48;
    end if;
  end function config_h_front_porch;

  function config_v_front_porch(resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 10;
    elsif (resolution = "1280x960") then return 1;
    elsif (resolution = "1680x1050") then return 1;
    elsif (resolution = "1600x1200") then return 1;
    elsif (resolution = "1280x1024") then return 1;
    else return 1;
    end if;
  end function config_v_front_porch;

  function config_h_sync_pulse (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 96;
    elsif (resolution = "1280x960") then return 136;
    elsif (resolution = "1680x1050") then return 184;
    elsif (resolution = "1600x1200") then return 192;
    elsif (resolution = "1280x1024") then return 112;
    else return 112;
    end if;
  end function config_h_sync_pulse;

  function config_v_sync_pulse (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 2;
    elsif (resolution = "1280x960") then return 3;
    elsif (resolution = "1680x1050") then return 3;
    elsif (resolution = "1600x1200") then return 3;
    elsif (resolution = "1280x1024") then return 3;
    else return 3;
    end if;
  end function config_v_sync_pulse;

  function config_h_back_porch (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 48;
    elsif (resolution = "1280x960") then return 216;
    elsif (resolution = "1680x1050") then return 288;
    elsif (resolution = "1600x1200") then return 304;
    elsif (resolution = "1280x1024") then return 248;
    else return 248;
    end if;
  end function config_h_back_porch;

  function config_v_back_porch (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 33;
    elsif (resolution = "1280x960") then return 30;
    elsif (resolution = "1680x1050") then return 33;
    elsif (resolution = "1600x1200") then return 46;
    elsif (resolution = "1280x1024") then return 38;
    else return 38;
    end if;
  end function config_v_back_porch;

  function config_h_polarity (resolution : string) return std_logic is
  begin
    if (resolution = "640x480") then return '0';
    elsif (resolution = "1280x960") then return '0';
    elsif (resolution = "1680x1050") then return '0';
    elsif (resolution = "1600x1200") then return '1';
    elsif (resolution = "1280x1024") then return '1';
    else return '1';
    end if;
  end function config_h_polarity;

  function config_v_polarity (resolution : string) return std_logic is
  begin
    if (resolution = "640x480") then return '0';
    elsif (resolution = "1280x960") then return '1';
    elsif (resolution = "1680x1050") then return '1';
    elsif (resolution = "1600x1200") then return '1';
    elsif (resolution = "1280x1024") then return '1';
    else return '1';
    end if;
  end function config_v_polarity;

  function config_refresh_rate (resolution : string) return natural is
  begin
    if (resolution = "640x480") then return 60;
    elsif (resolution = "1280x960") then return 60;
    elsif (resolution = "1680x1050") then return 60;
    elsif (resolution = "1600x1200") then return 60;
    elsif (resolution = "1280x1024") then return 60;
    else return 60;
    end if;
  end function config_refresh_rate;

  constant H_PIXELS                   : natural                                 := config_h_pixels(SET_RESOLUTION);
  constant V_PIXELS                   : natural                                 := config_v_pixels(SET_RESOLUTION);
  constant H_FRONT_PORCH              : natural                                 := config_h_front_porch(SET_RESOLUTION);
  constant V_FRONT_PORCH              : natural                                 := config_v_front_porch(SET_RESOLUTION);
  constant H_SYNC_PULSE               : natural                                 := config_h_sync_pulse(SET_RESOLUTION);
  constant V_SYNC_PULSE               : natural                                 := config_v_sync_pulse(SET_RESOLUTION);
  constant H_BACK_PORCH               : natural                                 := config_h_back_porch(SET_RESOLUTION);
  constant V_BACK_PORCH               : natural                                 := config_v_back_porch(SET_RESOLUTION);
  constant REFRESH_RATE               : natural                                 := config_refresh_rate(SET_RESOLUTION);
  constant H_POLARITY                 : std_logic                               := config_h_polarity(SET_RESOLUTION);
  constant V_POLARITY                 : std_logic                               := config_v_polarity(SET_RESOLUTION);
  constant H_PERIOD                   : natural                                 := H_PIXELS + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;  --total number of pixel clocks in a row
  constant V_PERIOD                   : natural                                 := V_PIXELS + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;  --total number of rows in column  
  -- determine how many bits are needed to represent the largest value that we're going to count to for each counter
  constant NUM_H_BITS                 : natural                                 := natural(ceil(log2(real(H_PERIOD))));
  constant NUM_V_BITS                 : natural                                 := natural(ceil(log2(real(V_PERIOD))));
  -- Paddle width is a function of the resolution. It will always start centered and be 1/4 of the entire horizontal width
  constant PADDLE_START_X             : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/2 - (H_PIXELS/8), NUM_H_BITS);
  constant PADDLE_END_X               : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/2 + (H_PIXELS/8), NUM_H_BITS);
  -- The paddle is always positioned 10 pixels above the bottom of the screen and is 10 pixels wide
  constant PADDLE_START_Y             : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS - 40, NUM_V_BITS);
  constant PADDLE_END_Y               : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS - 30, NUM_V_BITS);
  constant PADDLE_WIDTH               : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(unsigned(PADDLE_END_X) - unsigned(PADDLE_START_X), NUM_H_BITS);
  constant BLOCK_WIDTH                : natural                                 := H_PIXELS/8;
  constant BLOCK_HEIGHT               : natural                                 := V_PIXELS/8;
  constant BALL_POSITION_CENTER_X     : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/2, NUM_H_BITS);
  constant BALL_POSITION_CENTER_Y     : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/2, NUM_V_BITS);
  constant BALL_PIXEL_WIDTH           : natural                                 := 11;
  constant BALL_PIXEL_HEIGHT          : natural                                 := 11;
  constant BALL_POSITION_START_X      : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/2 - (BALL_PIXEL_WIDTH-1)/2, NUM_H_BITS);
  constant BALL_POSITION_END_X        : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/2 + (BALL_PIXEL_WIDTH-1)/2, NUM_H_BITS);
  constant BALL_POSITION_START_Y      : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/2 - (BALL_PIXEL_HEIGHT-1)/2, NUM_V_BITS);
  constant BALL_POSITION_END_Y        : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/2 + (BALL_PIXEL_HEIGHT-1)/2, NUM_V_BITS);
  constant MOVE_X_AXIS_QUARTER_SECOND : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/REFRESH_RATE*4, NUM_H_BITS);
  constant MOVE_X_AXIS_HALF_SECOND    : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/REFRESH_RATE*2, NUM_H_BITS);
  constant MOVE_X_AXIS_1_SECOND       : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/REFRESH_RATE, NUM_H_BITS);
  constant MOVE_X_AXIS_2_SECOND       : std_logic_vector(NUM_H_BITS-1 downto 0) := conv_std_logic_vector(H_PIXELS/REFRESH_RATE/2, NUM_H_BITS);
  constant MOVE_Y_AXIS_QUARTER_SECOND : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/REFRESH_RATE*4, NUM_V_BITS);
  constant MOVE_Y_AXIS_HALF_SECOND    : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/REFRESH_RATE*2, NUM_V_BITS);
  constant MOVE_Y_AXIS_1_SECOND       : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/REFRESH_RATE, NUM_V_BITS);
  constant MOVE_Y_AXIS_2_SECOND       : std_logic_vector(NUM_V_BITS-1 downto 0) := conv_std_logic_vector(V_PIXELS/REFRESH_RATE/2, NUM_V_BITS);

end package body breakout_package;
