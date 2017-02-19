library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.numeric_std.all;

entity counter is 
   Port  (
         seg_out   : out std_logic_vector(6 downto 0);
         enable0     : out std_logic;
         enable1     : out std_logic;
         enable2     : out std_logic;
         enable3     : out std_logic;
         clk         : in std_logic;
         reset       : in std_logic);
end counter;

architecture behavior of counter is

   component Hex_to_7_Seg
   port (
      seven_seg 		: out std_logic_vector( 6 downto 0);
      reg 			   : in std_logic_vector(3 downto 0));
   end component;
   
   signal Seg_0	: std_logic_vector(6 downto 0);
   signal Seg_1	: std_logic_vector(6 downto 0);
   signal Seg_2   : std_logic_vector(6 downto 0);
   signal Seg_3   : std_logic_vector(6 downto 0);
   
   signal count_reg_1s  : unsigned(3 downto 0) := (others => '0');
   signal count_reg_10s  : unsigned(3 downto 0) := (others => '0');
   signal count_reg_100s  : unsigned(3 downto 0) := (others => '0');
   signal count_reg_1000s  : unsigned(3 downto 0) := (others => '0');
   
   signal counter    : unsigned(26 downto 0) := to_unsigned(0, 27);
   signal seven_seg    : std_logic_vector(6 downto 0);
   constant max_count : integer := 100000000;
   
   signal refresh_counter : unsigned(17 downto 0) := to_unsigned(0, 18); -- counts every clock pulse
   constant refresh_maxcount	: integer := 200000; -- change this value to change your refresh rate
   signal toggle		: std_logic_vector(3 downto 0) := "0001"; -- used to control which display is active
   
   begin
   
      -- Instantiate 4 instances of the Hex_to_7_Seg.vhd design file
      seg3 : Hex_to_7_Seg
         port map (Seg_3, count_reg_1s);
      seg2 : Hex_to_7_Seg
         port map (Seg_2, count_reg_10s);
	   seg1 : Hex_to_7_Seg
         port map (Seg_1, count_reg_100s);
      seg0 : Hex_to_7_Seg
         port map (Seg_0, count_reg_1000s);
         
      enable0 <= not toggle(0);
      enable1 <= not toggle(1);
      enable2 <= not toggle(2);
      enable3 <= not toggle(3);
      
      counter_proc: process(clk)
      begin
         if(rising_edge(clk)) then
            if(counter = max_count) then
               counter <= (others => '0');
               if(count_reg_1s = 9 or reset = '1') then
                  count_reg_1s <= (others => '0');
                     if count_reg_10s = 9 then
                        count_reg_10s <= (others => '0');
                           if count_reg_100s = 9 then
                              count_reg_100s <= (others => '0');
                              if count_reg_1000s = 9 then
                                 count_reg_1000s <= (others => '0');
                              else count_reg_1000s <= count_reg_1000s + 1;
                              end if;
                           else
                              count_reg_100s <= count_reg_100s + 1;
                           end if;
                     else
                        count_reg_10s <= count_reg_10s + 1;
                     end if;
               else
                  count_reg_1s <= count_reg_1s + 1;
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
   
   
   
   
   
   
   
