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

component pmod_connector_2x6
  port (
  pin1                : inout std_logic;
  pin1_tx_data        : in    std_logic;
  pin1_rx_data        : out   std_logic;
  pin1_rx_enable      : in    std_logic;
  --
  pin2                : inout std_logic;
  pin2_tx_data        : in    std_logic;
  pin2_rx_data        : out   std_logic;
  pin2_rx_enable      : in    std_logic;
  --
  pin3                : inout std_logic;
  pin3_tx_data        : in    std_logic;
  pin3_rx_data        : out   std_logic;
  pin3_rx_enable      : in    std_logic;
  --
  pin4                : inout std_logic;
  pin4_tx_data        : in    std_logic;
  pin4_rx_data        : out   std_logic;
  pin4_rx_enable      : in    std_logic;
  --
  pin7                : inout std_logic;
  pin7_tx_data        : in    std_logic;
  pin7_rx_data        : out   std_logic;
  pin7_rx_enable      : in    std_logic;
  --
  pin8                : inout std_logic;
  pin8_tx_data        : in    std_logic;
  pin8_rx_data        : out   std_logic;
  pin8_rx_enable      : in    std_logic;    
  --
  pin9                : inout std_logic;
  pin9_tx_data        : in    std_logic;
  pin9_rx_data        : out   std_logic;
  pin9_rx_enable      : in    std_logic;
  --
  pin10                : inout std_logic;
  pin10_tx_data        : in    std_logic;
  pin10_rx_data        : out   std_logic;
  pin10_rx_enable      : in    std_logic);
end component; 

  component button_debouncer
    generic (
      DEBOUNCE_CYCLES : natural := 1000000);
    port (
      clk             : in  std_logic;
      buttonInput     : in  std_logic;
      buttonDebounced : out std_logic);
  end component;

  component basys3_seven_seg_wrapper is
    port (
      clk               : in  std_logic;
      reset             : in  std_logic;
      -- Enable bit to determine which display is currently active
      displaySegment    : out std_logic_vector(3 downto 0);
      -- Output value of each segment for active screen
      illuminateSegment : out std_logic_vector(6 downto 0);
      -- Hexadecimal data to display to each seven-segment screen
      dataSegment0      : in  std_logic_vector(3 downto 0);
      dataSegment1      : in  std_logic_vector(3 downto 0);
      dataSegment2      : in  std_logic_vector(3 downto 0);
      dataSegment3      : in  std_logic_vector(3 downto 0));
  end component;
  
  component uart_rx
    generic (
      CLKS_PER_BIT  : integer := 868       -- CLKS_PER_BIT = clk frequency / baud rate ex. 100MHz / 115,200 = 868
      );
    port (
      clk                : in  std_logic;
      reset_n            : in  std_logic;
      uart_rx_serial     : in  std_logic;
      uart_rx_data_valid : out std_logic;
      uart_rx_data_byte  : out std_logic_vector(7 downto 0)
      );
  end component;
  
  component uart_tx
    generic (
      CLKS_PER_BIT  : integer := 868       -- CLKS_PER_BIT = clk frequency / baud rate ex. 100MHz / 115,200 = 868
      );
    port (
    clk                : in  std_logic;
    reset_n            : in  std_logic;
    uart_tx_data_valid : in  std_logic;
    uart_tx_data_byte  : in  std_logic_vector(7 downto 0);
    uart_tx_active     : out std_logic;
    uart_tx_serial     : out std_logic);
  end component;

  signal debouncedButtonLeft     : std_logic;
  signal debouncedButtonRight    : std_logic;
  signal debouncedButtonCenter   : std_logic;
  
  signal debouncedButtonUp       : std_logic;
  signal debouncedButtonUpR1     : std_logic;
  signal debouncedButtonDown     : std_logic;

  signal reset        : std_logic;
  signal reset_n      : std_logic;

  signal vauxChannelsP     : std_logic_vector(15 downto 0);
  signal vauxChannelsN     : std_logic_vector(15 downto 0);
  signal adcAddress        : std_logic_vector(6 downto 0);
  signal adcReading        : std_logic_vector(15 downto 0);
  signal adcReadingLatched : std_logic_vector(15 downto 0);
 
  
  signal displaySegment0  : std_logic_vector(3 downto 0);  
  signal displaySegment1  : std_logic_vector(3 downto 0);  
  signal displaySegment2  : std_logic_vector(3 downto 0);  
  signal displaySegment3  : std_logic_vector(3 downto 0);   
  
  signal decimalReadingExpanded  : std_logic_vector(33 downto 0); 
  signal decimalReadingReduced   : std_logic_vector(11 downto 0);
    
  signal uart_rx_data_valid : std_logic;
  signal uart_rx_data_byte : std_logic_vector(7 downto 0);

  signal count  : natural   := 0;
  signal strobe : std_logic := '0';

  constant adcResolution            : unsigned(6 downto 0) := to_unsigned(123, 7);
  constant adcResolutionDesired     : unsigned(6 downto 0) := to_unsigned(125, 7);
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
  
  process (clk)
  begin
    if rising_edge(clk) then
    
        -- Whenever the button is pressed, latch in the ADC value so it's not constantly updating
        if (debouncedButtonUp = '1' and debouncedButtonUpR1 = '0') then
            adcReadingLatched <= adcReading;
        end if;
        
        -- Determine which address the XADC instance should be pointing to. 4 voltage sensors and a temperature sensor = 5 configurations
        case (switch(15 downto 12)) is
            when "0000" => adcAddress <= b"001_0110"; -- Address 0x16 / 22 : Voltage sensor 6, value in volts = ADC / 4096
            when "0001" => adcAddress <= b"001_0110"; -- Address 0x17 / 23 : Voltage sensor 7, value in volts = ADC / 4096
            when "0010" => adcAddress <= b"001_1110"; -- Address 0x1E / 30 : Voltage sensor 14, value in volts = ADC / 4096
            when "0011" => adcAddress <= b"001_1111"; -- Address 0x1F / 31 : Voltage sensor 15, value in volts = ADC / 4096
            when "1111" => adcAddress <= b"000_0000"; -- Address 0x00 / 0  : Temperature sensor, value in degrees celcius = ((ADC x 503.975) / 4096) - 273.15
            when others => adcAddress <= b"000_0000"; -- Address 0x00 / 0  : Temperature sensor, value in degrees celcius = ((ADC x 503.975) / 4096) - 273.15
        end case;
        
        -- Determine what value should be displayed to the 7-seg based on the two switches
        case (switch(11 downto 9)) is
            -- Take the XADC reading and pass it directly to the 7-seg. Ignore the 4 LSBs since they're unused.
            when "000" => 
                displaySegment0 <= (others => '0');
                displaySegment1 <= adcReadingLatched(7 downto 4);
                displaySegment2 <= adcReadingLatched(11 downto 8);
                displaySegment3 <= adcReadingLatched(15 downto 12);                                        
            -- Take the XADC reading and convert to decimal using the given formula from Xilinx: 
            -- Temperature (C) = ((ADC Code * 503.975) / 4096) - 273.15
            -- Round 503.975 to 504 and 273.15 to 273 so that the math is integer based
            when "001" => 
                -- Look at the 12 bits of actual ADC data and then multiply by 504
                -- 12 bits + 9 bits is only 21 bits and the register is 34 bits, so we need to 0 pad the top 13 bits 
                decimalReadingExpanded   <= "0000000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(504, 9)); 
                -- Ignore lowest 12 bits since that's the same as dividing by 4096, then subtract 273
                decimalReadingReduced    <= std_logic_vector(unsigned(decimalReadingExpanded(23 downto 12)) - to_unsigned(273, 9));    
                --
                displaySegment0 <= (others => '0');
                displaySegment1 <= decimalReadingReduced(3 downto 0);
                displaySegment2 <= decimalReadingReduced(7 downto 4);
                displaySegment3 <= decimalReadingReduced(11 downto 8);    
            -- Take the XADC reading and convert the LSB to 0.125
            when "010" =>
                decimalReadingExpanded     <= "0000000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(505, 9)); 
                -- Ignore the lower 9 bits since that's the same as dividing by 512
                decimalReadingReduced      <= decimalReadingExpanded(20 downto 9);
                --            
                displaySegment0            <= (others => '0');
                displaySegment1            <= decimalReadingReduced(3 downto 0);
                displaySegment2            <= decimalReadingReduced(7 downto 4);
                displaySegment3            <= decimalReadingReduced(11 downto 8);    
            
            when "011" =>                 
                -- 12 bits + 18 bits is only 30 bits and the register is 34 bits, so we need to 0 pad the top 4 bits
                decimalReadingExpanded        <= "0000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(254_507, 18)); 
                decimalReadingReduced         <= std_logic_vector(unsigned(decimalReadingExpanded(29 downto 18)) - to_unsigned(269, 9));   
                -- 
                displaySegment0 <= (others => '0');
                displaySegment1 <= decimalReadingReduced(3 downto 0);
                displaySegment2 <= decimalReadingReduced(7 downto 4);
                displaySegment3 <= decimalReadingReduced(11 downto 8);
            -- Multiply our ADC value by 4163 and divide by 4096 to convert the LSB to 0.125C (125/123 = 1.01626, 4163/4096 = 1.0163574)                   
            when "100" => 
                -- 12 bits + 13 bits is only 25 bits and the register is 34 bits, so we need to 0 pad the top 9 bits
                decimalReadingExpanded     <= "000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(4163, 13)); 
                -- Ignoring the lower 12 bits is the same as dividing by 4096
                decimalReadingReduced      <= decimalReadingExpanded(24 downto 13);            
                displaySegment0            <= (others => '0');
                displaySegment1            <= decimalReadingReduced(3 downto 0);
                displaySegment2            <= decimalReadingReduced(7 downto 4);
                displaySegment3            <= decimalReadingReduced(11 downto 8);  
            -- Take the XADC reading and convert to decimal using the given formula from Xilinx: 
            -- Temperature (C) = ((ADC Code * 503.975) / 4096) - 273.15
            -- Since we are converting the LSB resolution to .125 from .123, we multiply each side by 4163 / 4096
            -- Temperature (C) * (4163/4096) = ((ADC Code * 503.975 * 4163) / 4096 * 4096) - (273.15 * 4163 / 4096)
            -- Temperature (C) = ((ADC Code *  2,098,047.925) / 2^24) - 277.618
            -- Round to 2,098,048 and 278 so that the math is integer based                                
            when others => 
                --
                decimalReadingExpanded        <= std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(2_098_048, 22)); 
                -- Ignore the lower 24 bits which is the same as dividing by 4096 * 4096 (2^24)
                -- Since we're removing 24 bits of the 34 bits, we need to 0 pad it with 2 bits to get back to 12 bits
                decimalReadingReduced         <= "00" & std_logic_vector(unsigned(decimalReadingExpanded(33 downto 24)) - to_unsigned(278, 9));   
                -- 
                displaySegment0            <= (others => '0');
                displaySegment1            <= decimalReadingReduced(3 downto 0);
                displaySegment2            <= decimalReadingReduced(7 downto 4);
                displaySegment3            <= decimalReadingReduced(11 downto 8);                                                                         
        end case; 
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
  u_basys3_seven_seg_wrapper : basys3_seven_seg_wrapper
    port map (
      clk               => clk,
      reset             => reset,
      displaySegment    => displaySegment,
      illuminateSegment => illuminateSegment,
      dataSegment0      => displaySegment0(3 downto 0),        -- Only bits 15:4 should be driven by the 12-bit ADC. We can ignore these on the display
      dataSegment1      => displaySegment1(3 downto 0),     -- Tie the lower 2 bits off since it's actually too much temperature resolution 
      dataSegment2      => displaySegment2(3 downto 0),
      dataSegment3      => displaySegment3(3 downto 0)); 

  -- Instance a debouncer circuit for the left button on the Basys 3
  u_button_debouncer_left : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonLeft,
      buttonDebounced => debouncedButtonLeft);

  -- Instance a debouncer circuit for the up button on the Basys 3
  u_button_debouncer_up : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonUp,
      buttonDebounced => debouncedButtonUp);

  -- Instance a debouncer circuit for the center button on the Basys 3
  u_button_debouncer_center : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonCenter,
      buttonDebounced => debouncedButtonCenter);

  -- Instance a debouncer circuit for the down button on the Basys 3
  u_button_debouncer_down : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonDown,
      buttonDebounced => debouncedButtonDown);

  -- Instance a debouncer circuit for the right button on the Basys 3
  u_button_debouncer_right : button_debouncer
    port map (
      clk             => clk,
      buttonInput     => buttonRight,
      buttonDebounced => debouncedButtonRight);
      
  -- Instance a UART RX module that is driven by the USB port on the Basys 3
  u_uart_rx : uart_rx
        generic map (
          CLKS_PER_BIT => 868)
        port map (
          clk                => clk,
          reset_n            => reset_n,
          uart_rx_serial     => uartRX,
          uart_rx_data_valid => uart_rx_data_valid,
          uart_rx_data_byte  => uart_rx_data_byte);
         
  -- Instance a UART TX module that is driven by the USB port on the Basys 3          
  u_uart_tx : uart_tx
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
u_pmod_connector_2x6_ja : pmod_connector_2x6 
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
u_pmod_connector_2x6_jb : pmod_connector_2x6 
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
u_pmod_connector_2x6_jc : pmod_connector_2x6 
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
u_pmod_connector_2x6_jxadc : pmod_connector_2x6 
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
              
-- Instantiate the XADC primitive within the Series 7 Xilinx FPGA that the Basys 3 uses                    
U0 : XADC
    generic map (
        INIT_40 => X"0000", -- config reg 0
        INIT_41 => X"410F", -- config reg 1
        INIT_42 => X"0400", -- config reg 2
        INIT_48 => X"0100", -- Sequencer channel selection
        INIT_49 => X"00C0", -- Sequencer channel selection
        INIT_4A => X"0000", -- Sequencer Average selection
        INIT_4B => X"0000", -- Sequencer Average selection
        INIT_4C => X"0000", -- Sequencer Bipolar selection
        INIT_4D => X"0000", -- Sequencer Bipolar selection
        INIT_4E => X"0000", -- Sequencer Acq time selection
        INIT_4F => X"0000", -- Sequencer Acq time selection
        INIT_50 => X"B5ED", -- Temp alarm trigger
        INIT_51 => X"57E4", -- Vccint upper alarm limit
        INIT_52 => X"A147", -- Vccaux upper alarm limit
        INIT_53 => X"CA33",  -- Temp alarm OT upper
        INIT_54 => X"A93A", -- Temp alarm reset
        INIT_55 => X"52C6", -- Vccint lower alarm limit
        INIT_56 => X"9555", -- Vccaux lower alarm limit
        INIT_57 => X"AE4E",  -- Temp alarm OT reset
        INIT_58 => X"5999",  -- Vccbram upper alarm limit
        INIT_5C => X"5111",  -- Vccbram lower alarm limit
        SIM_DEVICE => "7SERIES",
        SIM_MONITOR_FILE => "design.txt")
    port map (
        -- ALARMS: 8-bit (each) output: ALM, OT
        ALM          => open,             -- 8-bit output: Output alarm for temp, Vccint, Vccaux and Vccbram
        OT           => open,             -- 1-bit output: Over-Temperature alarm

        -- STATUS: 1-bit (each) output: XADC status ports
        BUSY         => open,             -- 1-bit output: ADC busy output
        CHANNEL      => open,          -- 5-bit output: Channel selection outputs
        EOC          => open,             -- 1-bit output: End of Conversion
        EOS          => open,             -- 1-bit output: End of Sequence
        JTAGBUSY     => open,             -- 1-bit output: JTAG DRP transaction in progress output
        JTAGLOCKED   => open,             -- 1-bit output: JTAG requested DRP port lock
        JTAGMODIFIED => open,             -- 1-bit output: JTAG Write to the DRP has occurred
        MUXADDR      => open,          -- 5-bit output: External MUX channel decode

        -- Auxiliary Analog-Input Pairs: 16-bit (each) input: VAUXP[15:0], VAUXN[15:0]
        VAUXN        => vauxChannelsN,            -- 16-bit input: N-side auxiliary analog input
        VAUXP        => vauxChannelsP,            -- 16-bit input: P-side auxiliary analog input

        -- CONTROL and CLOCK: 1-bit (each) input: Reset, conversion start and clock inputs
        CONVST       => '0',              -- 1-bit input: Convert start input
        CONVSTCLK    => '0',              -- 1-bit input: Convert start input
        RESET        => '0',              -- 1-bit input: Active-high reset

        -- Dedicated Analog Input Pair: 1-bit (each) input: VP/VN
        VN           => '0', -- 1-bit input: N-side analog input
        VP           => '0', -- 1-bit input: P-side analog input

        -- Dynamic Reconfiguration Port (DRP)
        DO           => adcReading,
        DRDY         => open,
        DADDR        => adcAddress,                -- The address for reading AUX channel
        DCLK         => clk,
        DEN          => '1',
        DI           => (others => '0'),
        DWE          => '0');                                                                      

end behavior;