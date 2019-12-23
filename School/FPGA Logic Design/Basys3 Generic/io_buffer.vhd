library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
-- --------------------------------------------------------------------------------------------------------------------------------
-- If you want to use the IO as an output only, then you can tie rx_enable low to signify that you are always operating in tx mode
-- tx_data is the value you want to be sent on to the IO pin. Since we will never receive data in this configuration, rx_data is
-- left open as it has no function
-- --------------------------------------------------------------------------------------------------------------------------------
-- u_io_buffer : io_buffer
-- port map (
-- io             => io_pin,
-- tx_data        => tx_data,
-- rx_data        => open,
-- rx_enable      => '0');
    
-- --------------------------------------------------------------------------------------------------------------------------------
-- If you want to use the IO as an input only, then you can tie rx_enable high to signify that you are always operating in rx mode
-- rx_data is the value you want to be sent on to the IO pin. Since we will never send data in this configuration, tx_data is 
-- tied low (it could be tied high too, since it's just going to be optimized away anyway)
-- --------------------------------------------------------------------------------------------------------------------------------
-- u_io_buffer : io_buffer
-- port map (
-- io             => io_pin,
-- tx_data        => '0',
-- rx_data        => rx_data,
-- rx_enable      => '1');
    
-- --------------------------------------------------------------------------------------------------------------------------------
-- If you want to use the IO as an bi-directional, then you will use all ports. You will have toggle rx_enable high when you are 
-- expecting to read in data on the pin and it will be received through rx_data. You will Have to toggle rx_enable low when you 
-- are trying to transmit data on the pin, and tx_data is the data you want to send at this time
-- --------------------------------------------------------------------------------------------------------------------------------
-- u_io_buffer : io_buffer
-- port map (
-- io             => io_pin,
-- tx_data        => tx_data,
-- rx_data        => rx_data,
-- rx_enable      => rx_enable);
    
entity io_buffer is
  generic (
    FLOP_OUTPUT   : std_logic := '0');
  port (
    io            : inout std_logic;
    tx_data       : in    std_logic;
    rx_data       : out   std_logic;
    rx_enable     : in    std_logic);
end io_buffer;

architecture rtl of io_buffer is
    
begin
 
    -- Whenever rx_enable is set, io is configured to operate as an input. If it's configured to operate as an input, we don't want
    -- to drive it with a value. Instead, we tie it to 'Z'. rx_enable is low, we are using it to transmit data, and so we assign
    -- our tx_data to it.
    io      <= 'Z' when rx_enable = '1' else tx_data;
    
    -- Whenever rx_enable is set, we are receiving data from the io pin, and so we want to assign that data to the rx_data wire to 
    -- be consumed by internal logic. Otherwise, we assign a value of 'X'. Anything consuming rx_data should use rx_enable to qualify
    -- if the data is valid or not.
    rx_data <= io when rx_enable = '1' else 'X';
    
end rtl;