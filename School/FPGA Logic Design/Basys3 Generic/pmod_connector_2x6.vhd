library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
-- A PMOD 2x6 port is a 12 pin connector with 8 IO pins, 2 ground pins, and 2 voltage pins
-- The pinout setup is as shown below
--  |--------------------------------------------------------|
--  |  PIN6 (VCC) |  PIN5 (GND) | PIN4  | PIN3 | PIN2 | PIN1 |
--  |--------------------------------------------------------|
--  | PIN12 (VCC) | PIN11 (GND) | PIN10 | PIN9 | PIN8 | PIN7 |
--  |--------------------------------------------------------|

-- Ground pins and voltage pins do not need to be represented in an internal HDL file such as this, 
-- which is why there are only ports associated with each of the data pins (pin1-4 and pin7-10)

-- The PMOD connector was designed and specified by Digilent to allow a standard way to interface devices to a system
-- The PMOD connector can be used for I2C, UART, SPI, or general IO pins.
-- More information about the specification can be found at https://reference.digilentinc.com/_media/reference/pmod/pmod-interface-specification-1_1_0.pdf

-- PMOD connector's data pins are bi-directional pins, which means it can be configured to operate in either direction.
-- These pins can also operate in a shared mode, where it operates as both an input and an output (such as I2C)

-- This module can be used to instantiate an easily configurable PMOD interface. By using this module, you know that your module interfaces
-- directly with IO pins. That means you just have to design the PMOD controller logic and hook up it's IO to this module, which connects to
-- the inout IO pins. Hooking it up this ways allows for you to easily configure the direction of the PMOD pins without having to change top
-- level wrappers every single time you use a new PMOD device and still give you easy flexibility of the direction of each pin.
-- This module does not use an primitives, so it should work fine for any FPGA it is used in and have no issues being synthesized.

-- If you want to use the pin as an output only, then you can tie rx_enable low to signify that you are always operating in tx mode.
-- tx_data is the value you want to be sent on the IO pin. Since we will never receive data in this configuration, rx_data is
-- left open as it has no function
--
-- pin_               => pin
-- pin_tx_data        => pin_tx_data
-- pin_rx_data        => open
-- pin_rx_enable      => '0'

-- If you want to use the pin as an input only, then you can tie rx_enable high to signify that you are always operating in rx mode
-- rx_data is the value you want to be sent on to the IO pin. Since we will never send data in this configuration, tx_data is 
-- tied low (it could be tied high too, since it's just going to be optimized away anyway)
--
-- pin                => pin
-- pin_tx_data        => '0'
-- pin_rx_data        => pin_rx_data
-- pin_rx_enable      => '1'

-- If you want to use the pin as bi-directional, then you will use all ports. You will have to toggle rx_enable high when you are 
-- expecting to read in data on the pin and it will be received through rx_data. You will have to toggle rx_enable low when you 
-- are trying to transmit data on the pin, and tx_data is the data you want to send at this time
--
-- pin            => pin,
-- tx_data        => pin_tx_data,
-- rx_data        => pin_rx_data,
-- rx_enable      => pin_rx_enable

entity pmod_connector_2x6 is
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
end pmod_connector_2x6; 
 
architecture rtl of pmod_connector_2x6 is

component pmod_connector_1x6
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
    pin4_rx_enable      : in    std_logic);
end component;
 
begin

u_pmod_connector_1x6_top : pmod_connector_1x6 
port map (
    pin1                => pin1,
    pin1_tx_data        => pin1_tx_data,
    pin1_rx_data        => pin1_rx_data,
    pin1_rx_enable      => pin1_rx_enable,
    pin2                => pin2,
    pin2_tx_data        => pin2_tx_data,
    pin2_rx_data        => pin2_rx_data,
    pin2_rx_enable      => pin2_rx_enable,
    pin3                => pin3,
    pin3_tx_data        => pin3_tx_data,
    pin3_rx_data        => pin3_rx_data,
    pin3_rx_enable      => pin3_rx_enable,
    pin4                => pin4,
    pin4_tx_data        => pin4_tx_data,
    pin4_rx_data        => pin4_rx_data,
    pin4_rx_enable      => pin4_rx_enable);
    
u_pmod_connector_1x6_bottom : pmod_connector_1x6 
port map (
    pin1                => pin7,
    pin1_tx_data        => pin7_tx_data,
    pin1_rx_data        => pin7_rx_data,
    pin1_rx_enable      => pin7_rx_enable,
    pin2                => pin8,
    pin2_tx_data        => pin8_tx_data,
    pin2_rx_data        => pin8_rx_data,
    pin2_rx_enable      => pin8_rx_enable,
    pin3                => pin9,
    pin3_tx_data        => pin9_tx_data,
    pin3_rx_data        => pin9_rx_data,
    pin3_rx_enable      => pin9_rx_enable,
    pin4                => pin10,
    pin4_tx_data        => pin10_tx_data,
    pin4_rx_data        => pin10_rx_data,
    pin4_rx_enable      => pin10_rx_enable);
 
end rtl;