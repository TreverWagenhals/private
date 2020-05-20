library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

Library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library work;

entity basys3_xadc is
  port (
    clk               : in  std_logic;
    vauxChannelsP     : in  std_logic_vector(15 downto 0);
    vauxChannelsN     : in  std_logic_vector(15 downto 0);
    addressSelect     : in  std_logic_vector(3 downto 0);
    conversionSelect  : in  std_logic_vector(1 downto 0);
    readADC           : in  std_logic;
    outputADC         : out std_logic_vector(11 downto 0));
end basys3_xadc;

architecture behavior of basys3_xadc is

  signal readADC_R1        : std_logic;
  signal adcAddress        : std_logic_vector(6 downto 0);
  signal adcReading        : std_logic_vector(15 downto 0);
  signal adcReadingLatched : std_logic_vector(15 downto 0);
  signal decimalReadingExpanded  : std_logic_vector(33 downto 0); 
  
begin

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
            
      process (clk)
      begin
        if rising_edge(clk) then
        
            readADC_R1 <= readADC;
            
            -- Whenever the button is pressed, latch in the ADC value so it's not constantly updating
            if (readADC = '1' and readADC_R1 = '0') then
                adcReadingLatched <= adcReading;
            end if;
            
            -- Determine which address the XADC instance should be pointing to. 4 voltage sensors and a temperature sensor = 5 configurations
            case (addressSelect) is
                when "0000" => adcAddress <= b"001_0110"; -- Address 0x16 / 22 : Voltage sensor 6, value in volts = ADC / 4096
                when "0001" => adcAddress <= b"001_0110"; -- Address 0x17 / 23 : Voltage sensor 7, value in volts = ADC / 4096
                when "0010" => adcAddress <= b"001_1110"; -- Address 0x1E / 30 : Voltage sensor 14, value in volts = ADC / 4096
                when "0011" => adcAddress <= b"001_1111"; -- Address 0x1F / 31 : Voltage sensor 15, value in volts = ADC / 4096
                when "1111" => adcAddress <= b"000_0000"; -- Address 0x00 / 0  : Temperature sensor, value in degrees celcius = ((ADC x 503.975) / 4096) - 273.15
                when others => adcAddress <= b"000_0000"; -- Address 0x00 / 0  : Temperature sensor, value in degrees celcius = ((ADC x 503.975) / 4096) - 273.15
            end case;
            
            -- Determine what value should be displayed to the 7-seg based on the two switches
            case (conversionSelect) is
                -- Take the XADC reading and pass it directly to the 7-seg. Ignore the 4 LSBs since they're unused.
                -- Note that this is a RAW ADC code and does not represent the temperature value. This is just to show what the ADC value looks like
                when "000" => 
                    outputADC <= adcReadingLatched(15 downto 4);
                -- Take the XADC reading and convert to decimal using the given formula from Xilinx: 
                -- Temperature (C) = ((ADC Code * 503.975) / 4096) - 273.15
                -- Round 503.975 to 504 and 273.15 to 273 so that the math is integer based
                -- The LSB in this case will have a value of .123, so the displayed value may have rounding errors.
                when "001" => 
                    -- Look at the 12 bits of actual ADC data and then multiply by 504
                    -- 12 bits + 9 bits is only 21 bits and the register is 34 bits, so we need to 0 pad the top 13 bits 
                    decimalReadingExpanded   <= "0000000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(504, 9)); 
                    -- Ignore lowest 12 bits since that's the same as dividing by 4096, then subtract 273
                    outputADC    <= std_logic_vector(unsigned(decimalReadingExpanded(23 downto 12)) - to_unsigned(273, 9));    
                -- Take the XADC reading and convert the LSB to 0.125
                -- Temperature (C) = ((ADC Code * 503.975) / 4096) - 273.15
                -- Not sure if this is accurate at all since we're not doing subtraction here?
                when "010" =>
                    decimalReadingExpanded     <= "0000000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(505, 9)); 
                    -- Ignore the lower 9 bits since that's the same as dividing by 512
                    outputADC      <= decimalReadingExpanded(20 downto 9);                
                -- Multiply our ADC value value by 505 and divide by 512 to convert the LSB to 0.125C (.125/.123 = 1.01626, 512/505 = 1.01386)
                -- Temperature (C) = (((ADC Code * 503.975) / 4096) * 505/512) - (273.15 * 505/512)
                -- Temperature (C) = (((ADC Code * 503.975 * 505) / 4096 * 512)) - (269.415)
                -- Temperature (C) = (((ADC Code * 503.975 * 505) / 4096 * 512)) - (269.415)
                -- Temperature (C) = (((ADC Code * 503.975 * 505) / 4096 * 512)) - (269.415)           
                when "011" =>                 
                    -- 12 bits + 18 bits is only 30 bits and the register is 34 bits, so we need to 0 pad the top 4 bits
                    decimalReadingExpanded        <= "0000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(254_507, 18)); 
                    -- Ignore the lower 19 bits since dividing by 512 is dropping 8 bits, and dividing by 4096 is ignoring 11 bits
                    outputADC         <= std_logic_vector(unsigned(decimalReadingExpanded(29 downto 18)) - to_unsigned(269, 9));   
                -- Multiply our ADC value by 4163 and divide by 4096 to convert the LSB to 0.125C (125/123 = 1.01626, 4163/4096 = 1.0163574)                   
                when "100" => 
                    -- 12 bits + 13 bits is only 25 bits and the register is 34 bits, so we need to 0 pad the top 9 bits
                    decimalReadingExpanded     <= "000000000" & std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(4163, 13)); 
                    -- Ignoring the lower 12 bits is the same as dividing by 4096
                    outputADC      <= decimalReadingExpanded(24 downto 13);            
                -- Take the XADC reading and convert to decimal using the given formula from Xilinx: 
                -- Temperature (C) = ((ADC Code * 503.975) / 4096) - 273.15
                -- Since we are converting the LSB resolution to .125 from .123, we multiply each side by 4163 / 4096
                -- Temperature (C) * (4163/4096) = ((ADC Code * 503.975 * 4163) / 4096 * 4096) - (273.15 * 4163 / 4096)
                -- Temperature (C) = ((ADC Code *  2,098,047.925) / 2^24) - 277.618
                -- Round to 2,098,048 and 278 so that the math is integer based                                
                when others => 
                    decimalReadingExpanded        <= std_logic_vector(unsigned(adcReadingLatched(15 downto 4)) * to_unsigned(2_098_048, 22)); 
                    -- Ignore the lower 24 bits which is the same as dividing by 4096 * 4096 (2^24)
                    -- Since we're removing 24 bits of the 34 bits, we need to 0 pad it with 2 bits to get back to 12 bits
                    outputADC         <= "00" & std_logic_vector(unsigned(decimalReadingExpanded(33 downto 24)) - to_unsigned(278, 9));   
            end case; 
        end if;
      end process;          
end behavior;