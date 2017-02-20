library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity BCD is
   port (
      seg_out		: out std_logic_vector(6 downto 0);
      enable0      : out std_logic;
      enable1      : out std_logic;
      enable2      : out std_logic;
      enable3      : out std_logic;
      bin          : in std_logic_vector(13 downto 0);
      clk 		: in std_logic;
      reset		: in std_logic);
end BCD;


architecture behavior of BCD is

   component Hex_to_7_Seg
   port (
      seven_seg 		: out std_logic_vector(6 downto 0);
      hex 			   : in std_logic_vector(3 downto 0));
   end component;
   
   component bin2bcdconv
   Port      ( BIN_CNT_IN : in std_logic_vector(13 downto 0);
              LSD_OUT : out std_logic_vector(3 downto 0);
              MSD_OUT : out std_logic_vector(3 downto 0);
             MMSD_OUT : out std_logic_vector(3 downto 0);
             MMMSD_OUT : out std_logic_vector(3 downto 0));
   end component;

   signal lsd, msd, mmsd, mmmsd : std_logic_vector(3 downto 0);
   
   signal Seg_0	: std_logic_vector(6 downto 0);
   signal Seg_1	: std_logic_vector(6 downto 0);
   signal Seg_2   : std_logic_vector(6 downto 0);
   signal Seg_3   : std_logic_vector(6 downto 0);

   -- Signals for Multiplexing the 7 Segment Display
   -- The BASYS 3 Board has a default input clock of 100MHz
   -- a 20-bit counter is required to count to 200000
   -- we will be counting to 200000 to achieve a 500Hz refresh rate
   -- This is computed by 100,000,000 / 500 = 200,000
   signal counter		: unsigned(20 downto 0) := to_unsigned(0, 21); -- counts every clock pulse
   constant maxcount	: integer := 200000; -- change this value to change your refresh rate
   signal toggle		: std_logic_vector(3 downto 0) := "0001"; -- used to control which display is active

   begin
         bcd1 : bin2bcdconv
            port map (bin, lsd, msd, mmsd, mmmsd);

         seg3 : Hex_to_7_Seg
            port map (Seg_3, mmmsd);            
         seg2 : Hex_to_7_Seg
            port map (Seg_2, mmsd);
         seg1 : Hex_to_7_Seg
            port map (Seg_1, msd);
         seg0 : Hex_to_7_Seg
            port map (Seg_0, lsd);
            
         enable0 <= not toggle(0);
         enable1 <= not toggle(1);
         enable2 <= not toggle(2);
         enable3 <= not toggle(3);
            
         -- Counter Process that counts every clock pulse
         counter_proc: process(clk)
         begin
            if(rising_edge(clk)) then
               if(reset = '1' or counter = maxcount) then
                  counter <= (others => '0');
               else
                  counter <= counter + 1;
               end if;
            end if;
         end process counter_proc;
         
         -- Process that checks if signal counter has reached a value
         -- of constant maxcount
         -- if so we invert the toggle signal so that whichever display
         -- is active becomes inactive and the inactive display is now active
         -- We want this process to be evaluated every single clock cycle
         toggle_count_proc: process(clk)
         begin
            if(rising_edge(clk)) then
               if(reset = '1') then
                  toggle <= toggle;
               elsif(counter = maxcount) then
                  if toggle /= "1000" then
                     toggle <= std_logic_vector(unsigned(toggle) sll 1);
                  elsif(toggle = "1000") then
                        toggle <= "0001";
                  end if;
               end if;
            end if;
         end process toggle_count_proc;
         
         -- Toggle the seven segment displays
         -- This process is evaluated when the toggle signal changes
         -- or either of the Seg_0 or Seg_1 signals change state
         toggle_proc: process(toggle, Seg_0, Seg_1, Seg_2)
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
