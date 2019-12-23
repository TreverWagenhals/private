library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity uart_tx is
  generic (
    CLKS_PER_BIT : integer := 868     -- CLKS_PER_BIT = clk frequency / baud rate ex. 100MHz / 115,200 = 868
    );
  port (
    clk                : in  std_logic;
    reset_n            : in  std_logic;
    uart_tx_data_valid : in  std_logic;
    uart_tx_data_byte  : in  std_logic_vector(7 downto 0);
    uart_tx_active     : out std_logic;
    uart_tx_serial     : out std_logic);
end uart_tx;
 
 
architecture rtl of uart_tx is
 
  type uart_tx_states is (IDLE, TX_START_BIT, TX_DATA_BITS, TX_STOP_BIT);
  signal uart_tx_state_machine : uart_tx_states;
 
  signal clk_counter      : integer range 0 to CLKS_PER_BIT-1;
  signal bit_index        : integer range 0 to 7;  -- 8 Bits Total
  signal uart_tx_data_reg : std_logic_vector(7 downto 0);
   
begin
  
  process (clk)
  begin
    if rising_edge(clk) then
        if (reset_n = '0') then
            uart_tx_state_machine  <= IDLE;
            uart_tx_serial         <= '1';
            uart_tx_active         <= '0';
            uart_tx_data_reg       <= (others => '0');
            clk_counter            <= 0;
            bit_index              <= 0;
        else         
             
          case uart_tx_state_machine is
     
            when IDLE =>
              uart_tx_active <= '0';
              uart_tx_serial <= '1';         -- Drive Line High for Idle
              clk_counter    <= 0;
              bit_index      <= 0;
     
              if (uart_tx_data_valid = '1') then
                uart_tx_data_reg <= uart_tx_data_byte;
                uart_tx_state_machine <= TX_START_BIT;
              else
                uart_tx_state_machine <= IDLE;
              end if;
     
               
            -- Send out Start Bit. Start bit = 0
            when TX_START_BIT =>
              uart_tx_active <= '1';
              uart_tx_serial <= '0';
     
              -- Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
              if clk_counter < CLKS_PER_BIT-1 then
                clk_counter <= clk_counter + 1;
                uart_tx_state_machine   <= TX_START_BIT;
              else
                clk_counter <= 0;
                uart_tx_state_machine   <= TX_DATA_BITS;
              end if;
     
               
            -- Wait g_CLKS_PER_BIT-1 clock cycles for data bits to finish          
            when TX_DATA_BITS =>
              uart_tx_serial <= uart_tx_data_reg(bit_index);
               
              if clk_counter < CLKS_PER_BIT-1 then
                clk_counter <= clk_counter + 1;
                uart_tx_state_machine   <= TX_DATA_BITS;
              else
                clk_counter <= 0;
                 
                -- Check if we have sent out all bits
                if bit_index < 7 then
                  bit_index <= bit_index + 1;
                  uart_tx_state_machine   <= TX_DATA_BITS;
                else
                  bit_index <= 0;
                  uart_tx_state_machine   <= TX_STOP_BIT;
                end if;
              end if;
     
     
            -- Send out Stop bit.  Stop bit = 1
            when TX_STOP_BIT =>
              uart_tx_serial <= '1';
     
              -- Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
              if clk_counter < CLKS_PER_BIT-1 then
                clk_counter <= clk_counter + 1;
                uart_tx_state_machine   <= TX_STOP_BIT;
              else
                clk_counter <= 0;
                uart_tx_state_machine   <= IDLE;
              end if;
                 
            when others =>
              uart_tx_state_machine <= IDLE;
     
          end case;
        end if;
    end if;
  end process;
  
end RTL;