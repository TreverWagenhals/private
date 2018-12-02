library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.breakout_package.all;

entity xilinx_mmcm_vga_resolution_clk_gen is
  generic (
    CLK_PERIOD     : real   := 10.000;
    VGA_RESOLUTION : string := "1280x1024");
  port (
    systemClk    : in  std_logic;
    vgaClkLocked : out std_logic;
    vgaClk       : out std_logic);
end xilinx_mmcm_vga_resolution_clk_gen;

architecture behavior of xilinx_mmcm_vga_resolution_clk_gen is

signal vgaClkUnbuffered       : std_logic;
signal systemClkbuffered      : std_logic;
signal feedbackClkUnbuffered  : std_logic;
signal feedbackClkBuffered    : std_logic;

begin

  systemClkBuff : BUFG
    port map (
      I => systemClk,
      O => systemClkBuffered);

  vgaClkBuff : BUFG
    port map (
      I => vgaClkUnbuffered,
      O => vgaClk);
   
  feedbackClkBuff : BUFG
    port map (
      I => feedbackClkUnbuffered,
      O => feedbackClkBuffered);

  
  -- MMCME2_BASE: Base Mixed Mode Clock Manager
  -- 7 Series
  -- Xilinx HDL Libraries Guide, version 2012.2
  MMCME2_ADV_inst : MMCME2_ADV
    generic map (
      BANDWIDTH          => "OPTIMIZED",  -- Jitter programming (OPTIMIZED, HIGH, LOW)
      CLKOUT4_CASCADE    => false,
      COMPENSATION       => "ZHOLD",
      STARTUP_WAIT       => false,  -- Delays DONE until MMCM is locked (FALSE, TRUE)
      DIVCLK_DIVIDE      => 1,          -- Master division value (1-106)
      CLKFBOUT_MULT_F    => 9.125,  -- Multiply value for all CLKOUT (2.000-64.000).
      CLKFBOUT_PHASE     => 0.0,  -- Phase offset in degrees of CLKFB (-360.000-360.000).
      CLKIN1_PERIOD      => 10.000,  -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      -- CLKOUT0_DIVIDE - CLKOUT6_DIVIDE: Divide amount for each CLKOUT (1-128)
      CLKOUT0_DIVIDE_F   => 5.0,  -- Divide amount for CLKOUT0 (1.000-128.000).
      -- CLKOUT0_DUTY_CYCLE - CLKOUT6_DUTY_CYCLE: Duty cycle for each CLKOUT (0.01-0.99).
      CLKOUT0_DUTY_CYCLE => 0.5,
      -- CLKOUT0_PHASE - CLKOUT6_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
      CLKOUT0_PHASE      => 0.0
      )
    port map (
      CLKFBOUT     => feedbackClkUnbuffered,
      CLKFBOUTB    => open,
      CLKOUT0      => vgaClkUnbuffered,
      CLKOUT0B     => open,
      CLKOUT1      => open,
      CLKOUT1B     => open,
      CLKOUT2      => open,
      CLKOUT2B     => open,
      CLKOUT3      => open,
      CLKOUT3B     => open,
      CLKOUT4      => open,
      CLKOUT5      => open,
      CLKOUT6      => open,
      -- Input clock control
      CLKFBIN      => feedbackClkBuffered,
      CLKIN1       => systemClkBuffered,
      CLKIN2       => '0',
      -- Tied to always select the primary input clock
      CLKINSEL     => '1',
      -- Ports for dynamic reconfiguration
      DADDR        => (others => '0'),
      DCLK         => '0',
      DEN          => '0',
      DI           => (others => '0'),
      DO           => open,
      DRDY         => open,
      DWE          => '0',
      -- Ports for dynamic phase shift
      PSCLK        => '0',
      PSEN         => '0',
      PSINCDEC     => '0',
      PSDONE       => open,
      -- Other control and status signals
      LOCKED       => vgaClkLocked,
      CLKINSTOPPED => open,
      CLKFBSTOPPED => open,
      PWRDWN       => '0',
      RST          => '0');
end behavior;
