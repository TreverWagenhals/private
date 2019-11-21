library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
entity uart_rx is
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
end uart_rx;
  
architecture rtl of uart_rx is
 
  type uart_rx_states is (IDLE, RX_START_BIT, RX_DATA_BITS, RX_STOP_BIT);
  
  signal uart_rx_state_machine  : uart_rx_states;
  
  signal synced_uart_rx_serial  : std_logic;   
  signal uart_rx_data_valid_reg : std_logic;
  signal uart_rx_data_byte_reg  : std_logic_vector(7 downto 0);
  
  signal clk_counter            : integer range 0 to CLKS_PER_BIT-1;
  signal bit_index              : integer range 0 to 7;
   
begin  
 
  process (clk)
  begin
    if rising_edge(clk) then
    
        if (reset_n = '0') then
            uart_rx_state_machine  <= IDLE;
            synced_uart_rx_serial  <= '1';
            uart_rx_data_valid_reg <= '0';
            uart_rx_data_byte_reg  <= (others => '0');
            clk_counter            <= 0;
            bit_index              <= 0;
        else
        
          case uart_rx_state_machine is
     
            when IDLE =>
            
              uart_rx_data_valid_reg <= '0';
              
              clk_counter            <= 0;
              bit_index              <= 0;
     
              -- Start bit detected
              if (synced_uart_rx_serial = '0') then      
                uart_rx_state_machine <= RX_START_BIT;
              else
                uart_rx_state_machine <= IDLE;
              end if;
     
            -- Check middle of start bit to make sure it's still low
            when RX_START_BIT =>
              if (clk_counter = (CLKS_PER_BIT-1) / 2) then
                if (synced_uart_rx_serial = '0') then
                  clk_counter <= 0;  -- reset counter since we found the middle
                  uart_rx_state_machine <= RX_DATA_BITS;
                else
                  uart_rx_state_machine <= IDLE;
                end if;
              else
                clk_counter <= clk_counter + 1;
                uart_rx_state_machine <= RX_START_BIT;
              end if;
     
            -- Wait CLKS_PER_BIT-1 clock cycles to sample serial data
            when RX_DATA_BITS =>
              if (clk_counter < CLKS_PER_BIT-1) then
                clk_counter <= clk_counter + 1;
                uart_rx_state_machine <= RX_DATA_BITS;
              else
                clk_counter                      <= 0;
                uart_rx_data_byte_reg(bit_index) <= synced_uart_rx_serial;
                 
                -- Check if we have sent out all bits
                if bit_index < 7 then
                  bit_index             <= bit_index + 1;
                  uart_rx_state_machine <= RX_DATA_BITS;
                else
                  bit_index <= 0;
                  uart_rx_state_machine <= RX_STOP_BIT;
                end if;
              end if;
     
            -- Receive Stop bit.  Stop bit = 1
            when RX_STOP_BIT =>
              -- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
              if clk_counter < CLKS_PER_BIT-1 then
                clk_counter <= clk_counter + 1;
                uart_rx_state_machine <= RX_STOP_BIT;
              else
                uart_rx_data_valid_reg <= '1';
                clk_counter <= 0;
                uart_rx_state_machine   <= IDLE;
              end if;
     
            when others =>
              uart_rx_state_machine  <= IDLE;
     
          end case;
        end if;
    end if;
  end process;
 
  uart_rx_data_valid <= uart_rx_data_valid_reg;
  uart_rx_data_byte  <= uart_rx_data_byte_reg(6 downto 0) & "1";
   
end rtl;