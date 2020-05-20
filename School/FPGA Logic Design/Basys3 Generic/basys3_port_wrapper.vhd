library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity basys3_port_wrapper is
  port (
    CLK   : in  std_logic;
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
  
begin
  
  DP <= '0';

  u_basys3_top_wrapper : entity work.basys3_top_wrapper
    port map (
      clk               => CLK,
      --
      switch(0)         => SW0;
      switch(1)         => SW1;
      switch(2)         => SW2;
      switch(3)         => SW3;
      switch(4)         => SW4;
      switch(5)         => SW5;
      switch(6)         => SW6;
      switch(7)         => SW7;
      switch(8)         => SW8;
      switch(9)         => SW9;
      switch(10)        => SW10;
      switch(11)        => SW11;
      switch(12)        => SW12;
      switch(13)        => SW13;
      switch(14)        => SW14;
      switch(15)        => SW15;            
      led(0)            => LD0,
      led(1)            => LD1,
      led(2)            => LD2,
      led(3)            => LD3,
      led(4)            => LD4,
      led(5)            => LD5,
      led(6)            => LD6,
      led(7)            => LD7,
      led(8)            => LD8,
      led(9)            => LD9,
      led(10)           => LD10,
      led(11)           => LD11,
      led(12)           => LD12,
      led(13)           => LD13,
      led(14)           => LD14,
      led(15)           => LD15,      
      --  
      illuminateSegment(0) => CA,      
      illuminateSegment(1) => CB,      
      illuminateSegment(2) => CC,      
      illuminateSegment(3) => CD,      
      illuminateSegment(4) => CE,      
      illuminateSegment(5) => CF,      
      illuminateSegment(6) => CG,     
      displaySegment(0)    => AN0,
      displaySegment(1)    => AN1,
      displaySegment(2)    => AN2,
      displaySegment(3)    => AN3,      
      --
      buttonUp          => BTNU,
      buttonDown        => BTND,
      buttonLeft        => BTNR,
      buttonRight       => BTNL,
      buttonCenter      => BTNC,
      --
      uartRX            => RXD,
      uartTX            => TXD,
      --
      pmodJA1           => JA1,
      pmodJA2           => JA2,
      pmodJA3           => JA3,
      pmodJA4           => JA4,
      pmodJA7           => JA7,
      pmodJA8           => JA8,
      pmodJA9           => JA9,
      pmodJA10          => JA10,  
      --  
      pmodJB1           => JB1,
      pmodJB2           => JB2,
      pmodJB3           => JB3,
      pmodJB4           => JB4,
      pmodJB7           => JB7,
      pmodJB8           => JB8,
      pmodJB9           => JB9,
      pmodJB10          => JB10,    
      --
      pmodJC1           => JC1,
      pmodJC2           => JC2,
      pmodJC3           => JC3,
      pmodJC4           => JC4,
      pmodJC7           => JC7,
      pmodJC8           => JC8,
      pmodJC9           => JC9,
      pmodJC10          => JC10, 
      --      
      pmodJXADC1        => JXADC1,
      pmodJXADC2        => JXADC2,
      pmodJXADC3        => JXADC3,
      pmodJXADC4        => JXADC4,
      pmodJXADC7        => JXADC7,
      pmodJXADC8        => JXADC8,
      pmodJXADC9        => JXADC9,
      pmodJXADC10       => JXADC10, 
      --                     
      vgaRed(0)           => RED0,
      vgaRed(1)           => RED1,
      vgaRed(2)           => RED2,
      vgaRed(3)           => RED3,      
      vgaBlue(0)           => BLU0,
      vgaBlue(1)           => BLU1,
      vgaBlue(2)           => BLU2,
      vgaBlue(3)           => BLU3,      
      vgaGreen(0)          => GRN0,
      vgaGreen(1)          => GRN1,
      vgaGreen(2)          => GRN2,
      vgaGreen(3)          => GRN3,      
      vgaSyncH          => HSYNC,
      vgaSyncV          => VSYNC);

end behavior;
