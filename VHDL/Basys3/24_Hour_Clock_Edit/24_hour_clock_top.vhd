library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity clock is 
   Port  (
         clk         		: in std_logic;
         reset      		: in std_logic;
         minute_up  		: in std_logic;
         hour_up     		: in std_logic;
		 
         seg_out			: out std_logic_vector(6 downto 0);
		 enable_seg			: out bit_vector(3 downto 0);
         seconds	        : out std_logic_vector(5 downto 0));
end clock;

architecture behavior of clock is

   type seg_registers is array(0 to 3) of unsigned(3 downto 0);
   type seg_arr is array(0 to 3) of std_logic_vector(6 downto 0);

   component Hex_to_7_Seg
   port (
		reg 			: in unsigned(3 downto 0);
		seven_seg 		: out std_logic_vector(6 downto 0));
   end component;
   
   signal segments			  : seg_arr;
   signal seg_reg			  : seg_registers := (others => (others => '0'));
   
   constant max_count         	  : integer := 100000000;							-- 100Mhz for 1 second
   constant refresh_maxcount	  : integer := 200000; 							    -- change this value to change your refresh rate
   constant timer_change     	  : integer := 20000000;							-- Allow the manual changing of time to occur every .2 seconds
   
   signal counter            	  : unsigned(26 downto 0) := to_unsigned(0, 27);	-- Counter up to at least 100Mhz to make a 1 second count
   signal refresh_counter   	  : unsigned(17 downto 0) := to_unsigned(0, 18); 	-- counts every clock pulse
   signal counter_60s        	  : unsigned(5 downto 0) := to_unsigned(0, 6);
   signal toggle		          : bit_vector(3 downto 0) := "1110"; 		-- used to control which display is active
   
   begin
      -- Instantiate 4 instances of the Hex_to_7_Seg.vhd design file
      seg3 : Hex_to_7_Seg
		 port map (seg_reg(3), segments(3));
      seg2 : Hex_to_7_Seg
         port map (seg_reg(2), segments(2));
	  seg1 : Hex_to_7_Seg
         port map (seg_reg(1), segments(1));
      seg0 : Hex_to_7_Seg
         port map (seg_reg(0), segments(0));
        
	  for_loop: process(toggle)
	  begin
		  enable : for I in 0 to 3 loop
			 enable_seg(I) <= toggle(I);
		  end loop enable;
	  end process for_loop;
	  
      seconds <= std_logic_vector(counter_60s);
			  
	  change_time_proc : process(clk) 
	  variable mins : integer 0 to 59;
	  variable hour : integer 0 to 23;
	  begin
	  
         clk_event : if(rising_edge(clk)) then
            change_hr : if (hour_up = '1' and counter = timer_change) then
               counter <= (others => '0');
			   counter_60s <= (others => '0');
			   
			   if hour = 23 then
					hour := 0;
			   else
					hour := hour + 1;
			   end if;
           end if change_hr;
		   
		    if(counter = max_count or (minute_up = '1' and counter = timer_change)) then
               counter <= (others => '0');   
		   
				increment : if counter_60s = 59 or (minute_up = '1' and counter = timer_change) then       
				counter_60s <= (others => '0');
				
					if hour = 23 and mins = 59 then
						hour := 0;
						mins := 0;
					elsif min = 59 then
						hour := hour + 1;
						mins := 0;
					else
						mins := mins + 1;
					end if;
				else 
					counter_60s <= counter_60s + 1;
				end if increment;
			else
				counter <= counter + 1;
			end if;
		 end if clk_event;
		 
		 
      end process change_time_proc;

      toggle_count_proc: process(clk)
	  begin
			clk_event : if(rising_edge(clk)) then
				display : if(reset = '1') then
					toggle <= toggle;
					-- counter <= (others => '0');
					-- counter_60s <= (others => '0');
					-- seg_reg <= (others => (others => '0'));
				elsif(refresh_counter = refresh_maxcount) then
					toggle <= (toggle rol 1);
				end if display;
			end if clk_event;
	  end process toggle_count_proc;
      
      refresh_count_proc: process(clk)
      begin
			clk_event : if(rising_edge(clk)) then
				if refresh_counter = refresh_maxcount then
					refresh_counter <= (others => '0');
				else
					refresh_counter <= refresh_counter + 1;
				end if;
			end if clk_event;
      end process refresh_count_proc;
      
	  toggle_proc : process(toggle, seg_reg)
	  begin
			set_segment : case toggle is
				when "1110" => seg_out <= segments(0);
				when "1101" => seg_out <= segments(1);
				when "1011" => seg_out <= segments(2);
				when "0111" => seg_out <= segments(3);
				when others => seg_out <= "0001000";
			end case set_segment;
	  end process toggle_proc;		
end behavior;
   
   
   
   
   
   
   
