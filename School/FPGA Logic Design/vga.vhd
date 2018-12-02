library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.math_real.all;

entity vga_controller is
  -- Generics to control proper pixel values based on desired resolution
  -- Default values chosen for 640x480 display resolution
  generic (
    H_PIXELS       : natural;
    H_FRONT_PORCH  : natural;
    H_SYNC_PULSE   : natural;
    H_BACK_PORCH   : natural;
    H_POLARITY     : std_logic;
    H_PERIOD       : natural;
    NUM_H_BITS     : natural;
    --
    V_PIXELS       : natural;
    V_FRONT_PORCH  : natural;
    V_SYNC_PULSE   : natural;
    V_BACK_PORCH   : natural;
    V_POLARITY     : std_logic;
    V_PERIOD       : natural;
    NUM_V_BITS     : natural;
    --
    USE_CLK_ENABLE : std_logic);
  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    clkEnable      : in  std_logic;
    vgaSyncH       : out std_logic;
    vgaSyncV       : out std_logic;
    pixelPositionX : out std_logic_vector(NUM_H_BITS-1 downto 0);  -- horizontal pixel coordinate
    pixelPositionY : out std_logic_vector(NUM_V_BITS-1 downto 0));  -- vertical pixel coordinate

end vga_controller;

architecture behavior of vga_controller is

  -- Horizontal and Vertical counters
  signal horizontalCount : std_logic_vector(NUM_H_BITS-1 downto 0) := (others =>'0');
  signal verticalCount   : std_logic_vector(NUM_V_BITS-1 downto 0) := (others =>'0');

begin
    process (clk)
    begin
    if (rising_edge(clk)) then
        
        -- Increment horizontal count until end of period. If we reach the end of the period
        -- the counter resets and the vertical counter is now looked at. The same process applies to
        -- the vertical counter
        if (horizontalCount = (H_PERIOD - 1)) then
            horizontalCount <= (others =>'0');
       
            if (verticalCount = V_PERIOD - 1) then
                verticalCount <= (others =>'0');
            else
                verticalCount <= verticalCount + 1;
            end if;
        else
            horizontalCount <= horizontalCount + 1;
        end if;
         
        -- Whenever we are in a sync pulse period, assert the sync to the correct polarity 
        if (verticalCount >= (V_FRONT_PORCH + V_PIXELS - 1)) and (verticalCount < (V_FRONT_PORCH + V_PIXELS + V_SYNC_PULSE - 1)) then
            vgaSyncV <= V_POLARITY;
        else
            vgaSyncV <= not V_POLARITY;
        end if;
         
        -- Whenever we are in a sync pulse period, assert the sync to the correct polarity 
        if (horizontalCount >= (H_FRONT_PORCH + H_PIXELS - 1)) and (horizontalCount < (H_FRONT_PORCH + H_PIXELS + H_SYNC_PULSE - 1)) then
            vgaSyncH <= H_POLARITY;
        else
            vgaSyncH <= not H_POLARITY;
        end if;
       end if;
    end process;
         
    pixelPositionX <= horizontalCount;
    pixelPositionY <= verticalCount;

end behavior;
