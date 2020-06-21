library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity sync_cell is
  generic (
    NUMBER_OF_SYNC_FLOPS : integer := 3
    );
  port (
    clk                : in  std_logic;
    data               : in  std_logic;
    synced_data        : out std_logic);
end sync_cell;
 
architecture rtl of sync_cell is
 
    signal sync_pipeline : std_logic_vector(NUMBER_OF_SYNC_FLOPS-1 downto 0);
   
begin
  
  process (clk)
  begin
    if rising_edge (clk) then
        sync_pipeline(0)                               <= data;
        sync_pipeline(NUMBER_OF_SYNC_FLOPS-1 downto 1) <= sync_pipeline(NUMBER_OF_SYNC_FLOPS-2 downto 0);
    end if;
  end process;
  
  synced_data <= sync_pipeline(NUMBER_OF_SYNC_FLOPS-1);
  
end rtl;