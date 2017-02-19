library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity counter is 
   Port  (
         seg_out   : out std_logic_vector(6 downto 0);
         clk         : in std_logic;
         reset       : in std_logic;
         enable0     : out std_logic;
         enable1     : out std_logic;
         enable2     : out std_logic;
         enable3     : out std_logic);
end counter;

architecture behavior of counter is
   
   signal count_reg  : unsigned(3 downto 0) := (others => '0');
   signal counter    : unsigned(26 downto 0) := to_unsigned(0, 27);
   signal seven_seg    : std_logic_vector(6 downto 0);
   constant max_count : integer := 100000000;

   begin
      seg_out <= not seven_seg;
		enable0 <= '0';		  
		enable1 <= '1';				  
		enable2 <= '1';
		enable3 <= '1';
      
      counter_proc: process(clk)
      begin
         if(rising_edge(clk)) then
            if(reset = '1' or counter = max_count) then
               counter <= (others => '0');
               if(count_reg = 9 or reset = '1') then
                  count_reg <= (others => '0');
               else
                  count_reg <= count_reg + 1;
               end if;
            else
               counter <= counter + 1;
            end if;
         end if;
      end process counter_proc;
      
      seg_proc : process(count_reg)
      begin	
         case std_logic_vector(count_reg) is
            when x"0" => seven_seg <= "0111111";	-- 0
            when x"1" => seven_seg <= "0000110";	-- 1
            when x"2" => seven_seg <= "1011011";	-- 2
            when x"3" => seven_seg <= "1001111";	-- 3
            when x"4" => seven_seg <= "1100110";	-- 4
            when x"5" => seven_seg <= "1101101";	-- 5
            when x"6" => seven_seg <= "1111101";	-- 6
            when x"7" => seven_seg <= "0000111";	-- 7
            when x"8" => seven_seg <= "1111111";	-- 8
            when x"9" => seven_seg <= "1101111";	-- 9
            when others =>
               seven_seg <= (others => 'X');
         end case;
      end process seg_proc;			
end behavior;
   
   
   
   
   
   
   
