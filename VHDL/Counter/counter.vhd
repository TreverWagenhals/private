----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:47:47 01/03/2017 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity counter is
    Port ( clk_i : in  STD_LOGIC;
           led1_o : out  STD_LOGIC;
           led2_o : out  STD_LOGIC;
           led3_o : out  STD_LOGIC;
           led4_o : out  STD_LOGIC;
           led5_o : out  STD_LOGIC);
end counter;

architecture Behavioral of counter is
signal clk_fast : std_logic;
signal cnt_r : std_logic_vector(22 downto 0) := (others=>'0');
signal led_counter : std_logic_vector(4 downto 0) := (others=>'0');
begin

DCM_SP_inst : DCM_SP
	generic map (
		CLKFX_DIVIDE => 14,
		CLKFX_MULTIPLY => 10
	)
	port map (
		CLKFX => clk_fast,
		CLKIN => clk_i,
		RST => '0'
	);

process(clk_fast) is 
begin
	if rising_edge(clk_fast) then
		if cnt_r = "11111111111111111111111" then
			led_counter <= led_counter + 1;
			cnt_r <= cnt_r + 1;
		elsif cnt_r /= "11111111111111111111111" then
			cnt_r <= cnt_r + 1;
		end if;
	end if;
end process;

led1_o <= led_counter(0);
led2_o <= led_counter(1);
led3_o <= led_counter(2);
led4_o <= led_counter(3);
led5_o <= led_counter(4);

end Behavioral;

