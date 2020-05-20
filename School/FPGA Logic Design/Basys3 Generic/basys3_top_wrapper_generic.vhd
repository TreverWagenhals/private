library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

Library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library work;

entity basys3_top_wrapper is
  port (
    clk               : in  std_logic;
    -- SWITCHES
    switch            : in  std_logic_vector(15 downto 0);
    -- LEDs
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


end basys3_top_wrapper;

architecture behavior of basys3_top_wrapper is

  signal debouncedButtonLeft     : std_logic;
  signal debouncedButtonRight    : std_logic;
  signal debouncedButtonCenter   : std_logic;  
  signal debouncedButtonUp       : std_logic;
  signal debouncedButtonDown     : std_logic;

  signal reset        : std_logic;
  signal reset_n      : std_logic;
 
  signal displaySegment0  : std_logic_vector(3 downto 0);  
  signal displaySegment1  : std_logic_vector(3 downto 0);  
  signal displaySegment2  : std_logic_vector(3 downto 0);  
  signal displaySegment3  : std_logic_vector(3 downto 0);   
     
  signal uart_rx_data_valid : std_logic;
  signal uart_rx_data_byte : std_logic_vector(7 downto 0);
  
  signal vauxChannelsN : std_logic_vector(15 downto 0);
  signal vauxChannelsP : std_logic_vector(15 downto 0);  
  
  signal outputADC : std_logic_vector(11 downto 0);

  signal count  : natural   := 0;
  signal strobe : std_logic := '0';
begin

  -- 1 Second Strobe
  process (clk)
  begin
    if rising_edge(clk) then
      if count = 100000000 then
        count  <= 0;
        strobe <= not strobe;
      else
        count <= count + 1;
      end if;
    end if;
  end process;

  -- DEBUG SIGNALS 
  led(15) <= strobe;
  led(14) <= debouncedButtonCenter;
  led(13) <= pmodJA1;
  -- LEDs not being used currently, tied off for now to prevent warnings
  led(11 downto 0) <= "101010101010";
  -- RESETS
  reset           <= debouncedButtonCenter;
  reset_n         <= not debouncedButtonCenter;
  
  -- Instance a module that handles receiving 4 4-bit values and converting them to their appropriate 7-seg value.
  -- The displayed segment is rapidly changed so that all segments appear to be illuminated
  u_basys3_seven_seg_wrapper : entity work.basys3_seven_seg_wrapper
    port map (
      clk               => clk,
      reset             => reset,
      displaySegment    => displaySegment,
      illuminateSegment => illuminateSegment,
      dataSegment0      => displaySegment0(3 downto 0),
      dataSegment1      => displaySegment1(3 downto 0),
      dataSegment2      => displaySegment2(3 downto 0),
      dataSegment3      => displaySegment3(3 downto 0)); 

  -- Instance a debouncer circuit for the left button on the Basys 3
  u_button_debouncer_left : entity work.button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonLeft,
      buttonDebounced => debouncedButtonLeft);

    -- Instance a debouncer circuit for the up button on the Basys 3
    u_button_debouncer_up : entity work.button_debouncer
        port map (
            clk             => clk,
            buttonInput     => buttonUp,
            buttonDebounced => debouncedButtonUp);

    -- Instance a debouncer circuit for the center button on the Basys 3
    u_button_debouncer_center : entity work.button_debouncer
        port map (
            clk             => clk,
            buttonInput     => buttonCenter,
            buttonDebounced => debouncedButtonCenter);

  -- Instance a debouncer circuit for the down button on the Basys 3
  u_button_debouncer_down : entity work.button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonDown,
      buttonDebounced => debouncedButtonDown);

  -- Instance a debouncer circuit for the right button on the Basys 3
  u_button_debouncer_right : entity work.button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonRight,
      buttonDebounced => debouncedButtonRight);
      
  -- Instance a UART RX module that is driven by the USB port on the Basys 3
  u_uart_rx : entity work.uart_rx
        generic map (
          CLKS_PER_BIT => 868)
        port map (
          clk                => clk,
          reset_n            => reset_n,
          uart_rx_serial     => uartRX,
          uart_rx_data_valid => uart_rx_data_valid,
          uart_rx_data_byte  => uart_rx_data_byte);
         
    -- Instance a UART TX module that is driven by the USB port on the Basys 3          
    u_uart_tx : entity work.uart_tx
    generic map (
        CLKS_PER_BIT => 868)
    port map (
        clk                => clk,
        reset_n            => reset_n,
        uart_tx_data_valid => uart_rx_data_valid,
        uart_tx_data_byte  => uart_rx_data_byte,
        uart_tx_active     => open,
        uart_tx_serial     => uartTX);
                  
-- Instance a PMOD connector for the JA PMOD connector on the Basys 3
-- This circuit just acts as a configurable area to specify whether each pin
-- on the PMOD connector is an input, output, or inout. Each pin port then connects to
-- the appropriate bi-directional pin on the FPGA.                 
u_pmod_connector_2x6_ja : entity work.pmod_connector_2x6 
    port map (
        pin1                => pmodJA1,
        pin1_tx_data        => '0',
        pin1_rx_data        => open,
        pin1_rx_enable      => '0',
        pin2                => pmodJA2,
        pin2_tx_data        => '0',
        pin2_rx_data        => open,
        pin2_rx_enable      => '0',
        pin3                => pmodJA3,
        pin3_tx_data        => '0',
        pin3_rx_data        => open,
        pin3_rx_enable      => '0',
        pin4                => pmodJA4,
        pin4_tx_data        => '0',
        pin4_rx_data        => open,
        pin4_rx_enable      => '0',
        pin7                => pmodJA7,
        pin7_tx_data        => '0',
        pin7_rx_data        => open,
        pin7_rx_enable      => '0',
        pin8                => pmodJA8,
        pin8_tx_data        => '0',
        pin8_rx_data        => open,
        pin8_rx_enable      => '0',
        pin9                => pmodJA9,
        pin9_tx_data        => '0',
        pin9_rx_data        => open,
        pin9_rx_enable      => '0',
        pin10                => pmodJA10,
        pin10_tx_data        => '0',
        pin10_rx_data        => open,
        pin10_rx_enable      => '0');

-- Instance a PMOD connector for the JB PMOD connector on the Basys 3
-- This circuit just acts as a configurable area to specify whether each pin
-- on the PMOD connector is an input, output, or inout. Each pin port then connects to
-- the appropriate bi-directional pin on the FPGA.      
u_pmod_connector_2x6_jb : entity work.pmod_connector_2x6 
    port map (
        pin1                => pmodJB1,
        pin1_tx_data        => '0',
        pin1_rx_data        => open,
        pin1_rx_enable      => '0',
        pin2                => pmodJB2,
        pin2_tx_data        => '0',
        pin2_rx_data        => open,
        pin2_rx_enable      => '0',
        pin3                => pmodJB3,
        pin3_tx_data        => '0',
        pin3_rx_data        => open,
        pin3_rx_enable      => '0',
        pin4                => pmodJB4,
        pin4_tx_data        => '0',
        pin4_rx_data        => open,
        pin4_rx_enable      => '0',
        pin7                => pmodJB7,
        pin7_tx_data        => '0',
        pin7_rx_data        => open,
        pin7_rx_enable      => '0',
        pin8                => pmodJB8,
        pin8_tx_data        => '0',
        pin8_rx_data        => open,
        pin8_rx_enable      => '0',
        pin9                => pmodJB9,
        pin9_tx_data        => '0',
        pin9_rx_data        => open,
        pin9_rx_enable      => '0',
        pin10                => pmodJB10,
        pin10_tx_data        => '0',
        pin10_rx_data        => open,
        pin10_rx_enable      => '0');
                   
-- Instance a PMOD connector for the JC PMOD connector on the Basys 3
-- This circuit just acts as a configurable area to specify whether each pin
-- on the PMOD connector is an input, output, or inout. Each pin port then connects to
-- the appropriate bi-directional pin on the FPGA.                            
u_pmod_connector_2x6_jc : entity work.pmod_connector_2x6 
    port map (
        pin1                => pmodJC1,
        pin1_tx_data        => '0',
        pin1_rx_data        => open,
        pin1_rx_enable      => '0',
        pin2                => pmodJC2,
        pin2_tx_data        => '0',
        pin2_rx_data        => open,
        pin2_rx_enable      => '0',
        pin3                => pmodJC3,
        pin3_tx_data        => '0',
        pin3_rx_data        => open,
        pin3_rx_enable      => '0',
        pin4                => pmodJC4,
        pin4_tx_data        => '0',
        pin4_rx_data        => open,
        pin4_rx_enable      => '0',
        pin7                => pmodJC7,
        pin7_tx_data        => '0',
        pin7_rx_data        => open,
        pin7_rx_enable      => '0',
        pin8                => pmodJC8,
        pin8_tx_data        => '0',
        pin8_rx_data        => open,
        pin8_rx_enable      => '0',
        pin9                => pmodJC9,
        pin9_tx_data        => '0',
        pin9_rx_data        => open,
        pin9_rx_enable      => '0',
        pin10                => pmodJC10,
        pin10_tx_data        => '0',
        pin10_rx_data        => open,
        pin10_rx_enable      => '0'); 
                        
-- Instance a PMOD connector for the JXADC PMOD connector on the Basys 3
-- This circuit just acts as a configurable area to specify whether each pin
-- on the PMOD connector is an input, output, or inout. Each pin port then connects to
-- the appropriate bi-directional pin on the FPGA.                              
u_pmod_connector_2x6_jxadc : entity work.pmod_connector_2x6 
    port map (
        pin1                => pmodJXADC1,
        pin1_tx_data        => '0',
        pin1_rx_data        => vauxChannelsP(6),
        pin1_rx_enable      => '1',
        pin2                => pmodJXADC2,
        pin2_tx_data        => '0',
        pin2_rx_data        => vauxChannelsP(7),
        pin2_rx_enable      => '1',
        pin3                => pmodJXADC3,
        pin3_tx_data        => '0',
        pin3_rx_data        => vauxChannelsP(14),
        pin3_rx_enable      => '1',
        pin4                => pmodJXADC4,
        pin4_tx_data        => '0',
        pin4_rx_data        => vauxChannelsP(15),
        pin4_rx_enable      => '1',
        pin7                => pmodJXADC7,
        pin7_tx_data        => '0',
        pin7_rx_data        => vauxChannelsN(6),
        pin7_rx_enable      => '1',
        pin8                => pmodJXADC8,
        pin8_tx_data        => '0',
        pin8_rx_data        => vauxChannelsN(7),
        pin8_rx_enable      => '1',
        pin9                => pmodJXADC9,
        pin9_tx_data        => '0',
        pin9_rx_data        => vauxChannelsN(14),
        pin9_rx_enable      => '1',
        pin10                => pmodJXADC10,
        pin10_tx_data        => '0',
        pin10_rx_data        => vauxChannelsN(15),
        pin10_rx_enable      => '1');        
        
u_basys3_xadc : entity work.basys3_xadc         
          port map (
          clk               => clk,
          vauxChannelsP     => vauxChannelsP,
          vauxChannelsN     => vauxChannelsN,
          addressSelect     => switch(15 downto 12),
          conversionSelect  => switch(11 downto 10),
          readADC           => debouncedButtonCenter,
          outputADC         => outputADC);          
          
displaySegment0 <= (others => '0');
displaySegment0 <= outputADC(3 downto 0);
displaySegment0 <= outputADC(7 downto 4);
displaySegment0 <= outputADC(11 downto 8);    
                                                                                     
end behavior;