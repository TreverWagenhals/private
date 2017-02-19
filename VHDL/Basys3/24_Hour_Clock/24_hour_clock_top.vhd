library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity counter is 
   Port  (
         seg_out     : out std_logic_vector(6 downto 0);
         enable0     : out std_logic;
         enable1     : out std_logic;
         enable2     : out std_logic;
         enable3     : out std_logic;
         clk         : in std_logic;
         reset       : in std_logic;
         minute_up   : in std_logic;
         minute_down : in std_logic;
         hour_up     : in std_logic;
         hour_down   : in std_logic;
         count       : out std_logic_vector(5 downto 0));
end counter;

architecture behavior of counter is

   component Hex_to_7_Seg
   port (
      seven_seg 		: out std_logic_vector(6 downto 0);
      reg 			   : in std_logic_vector(3 downto 0));
   end component;
   
   signal Seg_0	: std_logic_vector(6 downto 0);
   signal Seg_1	: std_logic_vector(6 downto 0);
   signal Seg_2   : std_logic_vector(6 downto 0);
   signal Seg_3   : std_logic_vector(6 downto 0);
  
   signal count_reg_1s        : unsigned(3 downto 0) := "1001";
   signal count_reg_10s       : unsigned(3 downto 0) := "0101";
   signal count_reg_100s      : unsigned(3 downto 0) := "1001";
   signal count_reg_1000s     : unsigned(3 downto 0) := "0001";
   
   signal counter             : unsigned(26 downto 0) := to_unsigned(0, 27);
   constant max_count         : integer := 100000000;
   
   signal refresh_counter     : unsigned(17 downto 0) := to_unsigned(0, 18); -- counts every clock pulse
   constant refresh_maxcount	: integer := 200000; -- change this value to change your refresh rate
   constant timer_change      : integer := 20000000;
   signal counter_60s         : unsigned(5 downto 0) := to_unsigned(0,6);
   signal toggle		         : std_logic_vector(3 downto 0) := "0001"; -- used to control which display is active
   
   begin
   
      -- Instantiate 4 instances of the Hex_to_7_Seg.vhd design file
      seg3 : Hex_to_7_Seg
         port map (Seg_3, std_logic_vector(count_reg_1000s));
      seg2 : Hex_to_7_Seg
         port map (Seg_2, std_logic_vector(count_reg_100s));
	   seg1 : Hex_to_7_Seg
         port map (Seg_1, std_logic_vector(count_reg_10s));
      seg0 : Hex_to_7_Seg
         port map (Seg_0, std_logic_vector(count_reg_1s));
         
      enable0 <= not toggle(0);
      enable1 <= not toggle(1);
      enable2 <= not toggle(2);
      enable3 <= not toggle(3);
      count <= std_logic_vector(counter_60s);
      
      counter_proc: process(clk)
      begin
         if(rising_edge(clk)) then
            if (hour_up = '1' and counter = timer_change) then
               counter <= (others => '0');
               if (count_reg_1000s = 2 and count_reg_100s = 4) then
                  count_reg_1000s <= (others => '0');
                  count_reg_100s <= (others => '0');
               elsif (count_reg_1000s = 1 and count_reg_100s = 9) then
                  count_reg_1000s <= "0010";
                  count_reg_100s <= (others => '0');
               elsif (count_reg_1000s = 0 and count_reg_100s = 9) then
                  count_reg_1000s <= "0001";
                  count_reg_100s <= (others => '0');
               else
                  count_reg_100s <= count_reg_100s + 1;
               end if;
            end if;
                  
            if(counter = max_count or (minute_up = '1' and counter = timer_change)) then
               counter <= (others => '0');
               if counter_60s = 59 or (minute_up = '1' and counter = timer_change) then
                  counter_60s <= (others => '0');
                  
                  -- if 23:59, reset to 00:00
                  if (count_reg_1000s = 2 and count_reg_100s = 3 and count_reg_10s = 5 and count_reg_1s = 9) then
                     count_reg_1000s <= (others => '0');
                     count_reg_100s <= (others => '0');
                     count_reg_10s <= (others => '0');
                     count_reg_1s <= (others => '0');
                  -- if 19:59, reset to 20:00
                  elsif (count_reg_1000s = 1 and count_reg_100s = 9 and count_reg_10s = 5 and count_reg_1s = 9) then
                     count_reg_1000s <= "0010";
                     count_reg_100s <= (others => '0');
                     count_reg_10s <= (others => '0');
                     count_reg_1s <= (others => '0');     
                  -- if 09:59, reset to 10:00
                  elsif (count_reg_1000s = 0 and count_reg_100s = 9 and count_reg_10s = 5 and count_reg_1s = 9) then
                     count_reg_1000s <= "0001";
                     count_reg_100s <= (others => '0');
                     count_reg_10s <= (others => '0');
                     count_reg_1s <= (others => '0');         
                  -- if xx:59, reset to x(x+1):00
                  elsif(count_reg_10s = 5 and count_reg_1s = 9) then
                     count_reg_100s <= count_reg_100s + 1;
                     count_reg_10s <= (others => '0');
                     count_reg_1s <= (others => '0');
                  -- if xx:x9, reset to xx:(x+1)0
                  elsif(count_reg_1s = 9) then
                     count_reg_10s <= count_reg_10s + 1;
                     count_reg_1s <= (others => '0'); 
                  -- if xx:xx, reset to xx:x(x+1)
                  else
                     count_reg_1s <= count_reg_1s + 1;
                  end if;
                  
                  -- -- if 12:59, reset to 1:00
                  -- if (count_reg_1s = 9 and count_reg_10s = 5 and count_reg_100s = 2 and count_reg_1000s = 1) then
                     -- count_reg_1s <= (others => '0');
                     -- count_reg_10s <= (others => '0');
                     -- count_reg_100s <= "0001";
                     -- count_reg_1000s <= (others => '0');
                  -- -- if 09:59, reset to 10:00
                  -- elsif (count_reg_1s = 9 and count_reg_10s = 5 and count_reg_100s = 9 and count_reg_1000s = 0) then
                     -- count_reg_1s <= (others => '0');
                     -- count_reg_10s <= (others => '0');
                     -- count_reg_100s <= (others => '0');
                     -- count_reg_1000s <= "0001";         
                  -- -- if xx:59, reset to x(x+1):00
                  -- elsif (count_reg_1s = 9 and count_reg_10s = 5) then
                     -- count_reg_1s <= (others => '0');
                     -- count_reg_10s <= (others => '0');
                     -- count_reg_100s <= count_reg_100s + 1;
                  -- -- if xx:x9, change to xx:(x+1)0
                  -- elsif (count_reg_1s = 9) then
                     -- count_reg_1s <= (others => '0');
                     -- count_reg_10s <= count_reg_10s + 1;
                  -- -- if xx:xx, change to xx:x(x+1)
                  -- else
                     -- count_reg_1s <= count_reg_1s + 1;
                  -- end if;
               else
                  counter_60s <= counter_60s + 1;
               end if;         
            else
               counter <= counter + 1;
            end if;
         end if;
      end process counter_proc;

      toggle_count_proc: process(clk)
		begin
			if(rising_edge(clk)) then
				if(reset = '1') then
					toggle <= toggle;
				elsif(refresh_counter = refresh_maxcount) then
               if toggle /= "1000" then
                  toggle <= std_logic_vector(unsigned(toggle) sll 1);
               elsif(toggle = "1000") then
                     toggle <= "0001";
               end if;
			   end if;
			end if;
		end process toggle_count_proc;
      
      refresh_count_proc: process(clk)
      begin
         if(rising_edge(clk)) then
            if refresh_counter = refresh_maxcount then
               refresh_counter <= (others => '0');
            else
               refresh_counter <= refresh_counter + 1;
            end if;
         end if;
      end process refresh_count_proc;
      
		toggle_proc: process(toggle, Seg_0, Seg_1, Seg_2, Seg_3)
		begin
			if(toggle = "0001") then
				seg_out <= Seg_0;
			elsif(toggle = "0010") then
				seg_out <= Seg_1;
         elsif(toggle = "0100") then
            seg_out <= Seg_2;
         elsif(toggle = "1000") then
            seg_out <= Seg_3;
			end if;
		end process toggle_proc;		
end behavior;
   
   
   
   
   
   
   
