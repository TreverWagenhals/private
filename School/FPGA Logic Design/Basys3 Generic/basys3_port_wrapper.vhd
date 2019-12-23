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
    TXD   : out std_logic;
    RXD   : in  std_logic;
    --
    JA1   : inout std_logic;
    JA2   : inout std_logic;
    JA3   : inout std_logic;
    JA4   : inout std_logic;
    JA7   : inout std_logic;
    JA8   : inout std_logic;
    JA9   : inout std_logic;
    JA10  : inout std_logic;   
    --  
    JB1   : inout std_logic;
    JB2   : inout std_logic;
    JB3   : inout std_logic;
    JB4   : inout std_logic;
    JB7   : inout std_logic;
    JB8   : inout std_logic;
    JB9   : inout std_logic;
    JB10  : inout std_logic;     
    --
    JC1   : inout std_logic;
    JC2   : inout std_logic;
    JC3   : inout std_logic;
    JC4   : inout std_logic;
    JC7   : inout std_logic;
    JC8   : inout std_logic;
    JC9   : inout std_logic;
    JC10  : inout std_logic;     
    --
    JXADC1   : inout std_logic;
    JXADC2   : inout std_logic;
    JXADC3   : inout std_logic;
    JXADC4   : inout std_logic;
    JXADC7   : inout std_logic;
    JXADC8   : inout std_logic;
    JXADC9   : inout std_logic;
    JXADC10  : inout std_logic;                                 
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
  signal uartRX            : std_logic;
  signal uartTX            : std_logic;
  
  signal pmodJA1          : std_logic;
  signal pmodJA2          : std_logic;
  signal pmodJA3          : std_logic;
  signal pmodJA4          : std_logic;
  signal pmodJA7          : std_logic;
  signal pmodJA8          : std_logic;
  signal pmodJA9          : std_logic;
  signal pmodJA10         : std_logic;      
  
  signal pmodJB1          : std_logic;
  signal pmodJB2          : std_logic;
  signal pmodJB3          : std_logic;
  signal pmodJB4          : std_logic;
  signal pmodJB7          : std_logic;
  signal pmodJB8          : std_logic;
  signal pmodJB9          : std_logic;
  signal pmodJB10         : std_logic; 
  
  signal pmodJC1          : std_logic;
  signal pmodJC2          : std_logic;
  signal pmodJC3          : std_logic;
  signal pmodJC4          : std_logic;
  signal pmodJC7          : std_logic;
  signal pmodJC8          : std_logic;
  signal pmodJC9          : std_logic;
  signal pmodJC10         : std_logic;   
  
  signal pmodJXADC1          : std_logic;
  signal pmodJXADC2          : std_logic;
  signal pmodJXADC3          : std_logic;
  signal pmodJXADC4          : std_logic;
  signal pmodJXADC7          : std_logic;
  signal pmodJXADC8          : std_logic;
  signal pmodJXADC9          : std_logic;
  signal pmodJXADC10         : std_logic;             

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
      -- UART PINS
      uartRX            : in  std_logic;
      uartTX            : out std_logic;
      --
      pmodJA1           : inout std_logic;
      pmodJA2           : inout std_logic;
      pmodJA3           : inout std_logic;
      pmodJA4           : inout std_logic;
      pmodJA7           : inout std_logic;
      pmodJA8           : inout std_logic;
      pmodJA9           : inout std_logic;
      pmodJA10          : inout std_logic;      
      --
      pmodJB1           : inout std_logic;
      pmodJB2           : inout std_logic;
      pmodJB3           : inout std_logic;
      pmodJB4           : inout std_logic;
      pmodJB7           : inout std_logic;
      pmodJB8           : inout std_logic;
      pmodJB9           : inout std_logic;
      pmodJB10          : inout std_logic;      
      --
      pmodJC1           : inout std_logic;
      pmodJC2           : inout std_logic;
      pmodJC3           : inout std_logic;
      pmodJC4           : inout std_logic;
      pmodJC7           : inout std_logic;
      pmodJC8           : inout std_logic;
      pmodJC9           : inout std_logic;
      pmodJC10          : inout std_logic;  
      --
      pmodJXADC1           : inout std_logic;
      pmodJXADC2           : inout std_logic;
      pmodJXADC3           : inout std_logic;
      pmodJXADC4           : inout std_logic;
      pmodJXADC7           : inout std_logic;
      pmodJXADC8           : inout std_logic;
      pmodJXADC9           : inout std_logic;
      pmodJXADC10          : inout std_logic;                                
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
  
  TXD <= uartTX;
  uartRX <= RXD;
  
  ja1  <= pmodJA1;
  ja2  <= pmodJA2;
  ja3  <= pmodJA3;
  ja4  <= pmodJA4;
  ja7  <= pmodJA7;
  ja8  <= pmodJA8;
  ja9  <= pmodJA9;
  ja10 <= pmodJA10;   
  
  jb1  <= pmodJB1;
  jb2  <= pmodJB2;
  jb3  <= pmodJB3;
  jb4  <= pmodJB4;
  jb7  <= pmodJB7;
  jb8  <= pmodJB8;
  jb9  <= pmodJB9;
  jb10 <= pmodJB10;
  
  jc1  <= pmodJC1;
  jc2  <= pmodJC2;
  jc3  <= pmodJC3;
  jc4  <= pmodJC4;
  jc7  <= pmodJC7;
  jc8  <= pmodJC8;
  jc9  <= pmodJC9;
  jc10 <= pmodJC10;       
  
  jxadc1  <= pmodJXADC1;
  jxadc2  <= pmodJXADC2;
  jxadc3  <= pmodJXADC3;
  jxadc4  <= pmodJXADC4;
  jxadc7  <= pmodJXADC7;
  jxadc8  <= pmodJXADC8;
  jxadc9  <= pmodJXADC9;
  jxadc10 <= pmodJXADC10;                  

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
      uartRX            => uartRX,
      uartTX            => uartTX,
      --
      pmodJA1           => pmodJA1,
      pmodJA2           => pmodJA2,
      pmodJA3           => pmodJA3,
      pmodJA4           => pmodJA4,
      pmodJA7           => pmodJA7,
      pmodJA8           => pmodJA8,
      pmodJA9           => pmodJA9,
      pmodJA10          => pmodJA10,  
      --  
      pmodJB1           => pmodJB1,
      pmodJB2           => pmodJB2,
      pmodJB3           => pmodJB3,
      pmodJB4           => pmodJB4,
      pmodJB7           => pmodJB7,
      pmodJB8           => pmodJB8,
      pmodJB9           => pmodJB9,
      pmodJB10          => pmodJB10,    
      --
      pmodJC1           => pmodJC1,
      pmodJC2           => pmodJC2,
      pmodJC3           => pmodJC3,
      pmodJC4           => pmodJC4,
      pmodJC7           => pmodJC7,
      pmodJC8           => pmodJC8,
      pmodJC9           => pmodJC9,
      pmodJC10          => pmodJC10, 
      --      
      pmodJXADC1           => pmodJXADC1,
      pmodJXADC2           => pmodJXADC2,
      pmodJXADC3           => pmodJXADC3,
      pmodJXADC4           => pmodJXADC4,
      pmodJXADC7           => pmodJXADC7,
      pmodJXADC8           => pmodJXADC8,
      pmodJXADC9           => pmodJXADC9,
      pmodJXADC10          => pmodJXADC10, 
      --                               
      vgaRed            => vgaRed,
      vgaBlue           => vgaBlue,
      vgaGreen          => vgaGreen,
      vgaSyncH          => vgaSyncH,
      vgaSyncV          => vgaSyncV);

end behavior;
