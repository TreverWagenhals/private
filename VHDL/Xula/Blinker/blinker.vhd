----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:14:05 01/01/2017 
-- Design Name: 
-- Module Name:    blinker - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity blinker is
    Port ( clk_i : in  STD_LOGIC;
           blinker_o : out  STD_LOGIC);
end blinker;

architecture Behavioral of blinker is
signal clk_fast : std_logic;
signal cnt_r : std_logic_vector(22 downto 0) := (others=>'0');
begin

DCM_SP_inst : DCM_SP
	generic map (
		CLKFX_DIVIDE => 4,
		CLKFX_MULTIPLY => 6
	)
	port map (
		CLKFX => clk_fast,
		CLKIN => clk_i,
		RST => '0'
	);

process(clk_fast) is 
begin
	if rising_edge(clk_fast) then
		cnt_r <= cnt_r + 1;
	end if;
end process;

blinker_o <= cnt_r(22);

end Behavioral;

