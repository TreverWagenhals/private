library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity basys3_port_wrapper is
  port (
    clk   : in  std_logic;
    BTNL  : in  std_logic;
    BTNR  : in  std_logic;
    BTNU  : in  std_logic;
    BTND  : in  std_logic;
    BTNC  : in  std_logic;
    --
    SW0   : in  std_logic;
    SW1   : in  std_logic;
    SW2   : in  std_logic;
    SW3   : in  std_logic;
    SW4   : in  std_logic;
    SW5   : in  std_logic;
    SW6   : in  std_logic;
    SW7   : in  std_logic;
    SW8   : in  std_logic;
    SW9   : in  std_logic;
    SW10  : in  std_logic;
    SW11  : in  std_logic;
    SW12  : in  std_logic;
    SW13  : in  std_logic;
    SW14  : in  std_logic;
    SW15  : in  std_logic;
    --
    LD0   : out std_logic;
    LD1   : out std_logic;
    LD2   : out std_logic;
    LD3   : out std_logic;
    LD4   : out std_logic;
    LD5   : out std_logic;
    LD6   : out std_logic;
    LD7   : out std_logic;
    LD8   : out std_logic;
    LD9   : out std_logic;
    LD10  : out std_logic;
    LD11  : out std_logic;
    LD12  : out std_logic;
    LD13  : out std_logic;
    LD14  : out std_logic;
    LD15  : out std_logic;
    --
    AN0   : out std_logic;
    AN1   : out std_logic;
    AN2   : out std_logic;
    AN3   : out std_logic;
    CA    : out std_logic;
    CB    : out std_logic;
    CC    : out std_logic;
    CD    : out std_logic;
    CE    : out std_logic;
    CF    : out std_logic;
    CG    : out std_logic;
    DP    : out std_logic;
    --
    RED0  : out std_logic;
    RED1  : out std_logic;
    RED2  : out std_logic;
    RED3  : out std_logic;
    GRN0  : out std_logic;
    GRN1  : out std_logic;
    GRN2  : out std_logic;
    GRN3  : out std_logic;
    BLU0  : out std_logic;
    BLU1  : out std_logic;
    BLU2  : out std_logic;
    BLU3  : out std_logic;
    HSYNC : out std_logic;
    VSYNC : out std_logic);
end basys3_port_wrapper;

architecture behavior of basys3_port_wrapper is

  signal switch            : std_logic_vector(15 downto 0);
  signal led               : std_logic_vector(15 downto 0);
  signal illuminateSegment : std_logic_vector(6 downto 0);
  signal displaySegment    : std_logic_vector(3 downto 0);
  signal buttonUp          : std_logic;
  signal buttonDown        : std_logic;
  signal buttonLeft        : std_logic;
  signal buttonRight       : std_logic;
  signal buttonCenter      : std_logic;
  signal vgaRed            : std_logic_vector(3 downto 0);
  signal vgaBlue           : std_logic_vector(3 downto 0);
  signal vgaGreen          : std_logic_vector(3 downto 0);
  signal vgaSyncH          : std_logic;
  signal vgaSyncV          : std_logic;

  component basys3_top_wrapper
    port (
      clk               : in  std_logic;
      switch            : in  std_logic_vector(15 downto 0);
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
  end component;

begin

  switch(0)  <= SW0;
  switch(1)  <= SW1;
  switch(2)  <= SW2;
  switch(3)  <= SW3;
  switch(4)  <= SW4;
  switch(5)  <= SW5;
  switch(6)  <= SW6;
  switch(7)  <= SW7;
  switch(8)  <= SW8;
  switch(9)  <= SW9;
  switch(10) <= SW10;
  switch(11) <= SW11;
  switch(12) <= SW12;
  switch(13) <= SW13;
  switch(14) <= SW14;
  switch(15) <= SW15;

  LD0  <= led(0);
  LD1  <= led(1);
  LD2  <= led(2);
  LD3  <= led(3);
  LD4  <= led(4);
  LD5  <= led(5);
  LD6  <= led(6);
  LD7  <= led(7);
  LD8  <= led(8);
  LD9  <= led(9);
  LD10 <= led(10);
  LD11 <= led(11);
  LD12 <= led(12);
  LD13 <= led(13);
  LD14 <= led(14);
  LD15 <= led(15);

  buttonUp     <= BTNU;
  buttonDown   <= BTND;
  buttonRight  <= BTNR;
  buttonLeft   <= BTNL;
  buttonCenter <= BTNC;

  RED0  <= vgaRed(0);
  RED1  <= vgaRed(1);
  RED2  <= vgaRed(2);
  RED3  <= vgaRed(3);
  GRN0  <= vgaGreen(0);
  GRN1  <= vgaGreen(1);
  GRN2  <= vgaGreen(2);
  GRN3  <= vgaGreen(3);
  BLU0  <= vgaBlue(0);
  BLU1  <= vgaBlue(1);
  BLU2  <= vgaBlue(2);
  BLU3  <= vgaBlue(3);
  HSYNC <= vgaSyncH;
  VSYNC <= vgaSyncV;

  AN0 <= displaySegment(0);
  AN1 <= displaySegment(1);
  AN2 <= displaySegment(2);
  AN3 <= displaySegment(3);

  CA <= illuminateSegment(0);
  CB <= illuminateSegment(1);
  CC <= illuminateSegment(2);
  CD <= illuminateSegment(3);
  CE <= illuminateSegment(4);
  CF <= illuminateSegment(5);
  CG <= illuminateSegment(6);

  DP <= '0';



  u_basys3_top_wrapper : basys3_top_wrapper
    port map (
      clk               => clk,
      switch            => switch,
      led               => led,
      illuminateSegment => illuminateSegment,
      displaySegment    => displaySegment,
      buttonUp          => buttonUp,
      buttonDown        => buttonDown,
      buttonLeft        => buttonLeft,
      buttonRight       => buttonRight,
      buttonCenter      => buttonCenter,
      vgaRed            => vgaRed,
      vgaBlue           => vgaBlue,
      vgaGreen          => vgaGreen,
      vgaSyncH          => vgaSyncH,
      vgaSyncV          => vgaSyncV);

end behavior;
