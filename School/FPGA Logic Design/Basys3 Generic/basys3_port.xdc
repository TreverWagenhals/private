## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal (Input 100 MHz)
set_property PACKAGE_PIN W5       [get_ports W5]							
set_property IOSTANDARD  LVCMOS33 [get_ports W5]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports W5]
 
# Allow pushbutton to be the input clock 
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk]
 
# Switches
set_property PACKAGE_PIN V17      [get_ports V17]					
set_property IOSTANDARD  LVCMOS33 [get_ports V17]
set_property PACKAGE_PIN V16      [get_ports V16]					
set_property IOSTANDARD  LVCMOS33 [get_ports V16]
set_property PACKAGE_PIN W16      [get_ports W16]					
set_property IOSTANDARD  LVCMOS33 [get_ports W16]
set_property PACKAGE_PIN W17      [get_ports W17]					
set_property IOSTANDARD  LVCMOS33 [get_ports W17]
   
set_property PACKAGE_PIN W15      [get_ports W15]					
set_property IOSTANDARD  LVCMOS33 [get_ports W15]
set_property PACKAGE_PIN V15      [get_ports V15]					
set_property IOSTANDARD  LVCMOS33 [get_ports V15]
set_property PACKAGE_PIN W14      [get_ports W14]					
set_property IOSTANDARD  LVCMOS33 [get_ports W14]
set_property PACKAGE_PIN W13      [get_ports W13]					
set_property IOSTANDARD  LVCMOS33 [get_ports W13]
   
set_property PACKAGE_PIN V2       [get_ports V2]					
set_property IOSTANDARD  LVCMOS33 [get_ports V2]
set_property PACKAGE_PIN T3       [get_ports T3]					
set_property IOSTANDARD  LVCMOS33 [get_ports T3]
set_property PACKAGE_PIN T2       [get_ports T2]					
set_property IOSTANDARD  LVCMOS33 [get_ports T2]
set_property PACKAGE_PIN R3       [get_ports R3]					
set_property IOSTANDARD  LVCMOS33 [get_ports R3]
   
set_property PACKAGE_PIN W2       [get_ports W2]					
set_property IOSTANDARD  LVCMOS33 [get_ports W2]
set_property PACKAGE_PIN U1       [get_ports U1]					
set_property IOSTANDARD  LVCMOS33 [get_ports U1]
set_property PACKAGE_PIN T1       [get_ports T1]					
set_property IOSTANDARD  LVCMOS33 [get_ports T1]
set_property PACKAGE_PIN R2       [get_ports R2]					
set_property IOSTANDARD  LVCMOS33 [get_ports R2]

# LEDs
set_property PACKAGE_PIN U16      [get_ports U16]					
set_property IOSTANDARD  LVCMOS33 [get_ports U16]
set_property PACKAGE_PIN E19      [get_ports E19]					
set_property IOSTANDARD  LVCMOS33 [get_ports E19]
set_property PACKAGE_PIN U19      [get_ports U19]					
set_property IOSTANDARD  LVCMOS33 [get_ports U19]
set_property PACKAGE_PIN V19      [get_ports V19]					
set_property IOSTANDARD  LVCMOS33 [get_ports V19]
set_property PACKAGE_PIN W18      [get_ports W18]					
set_property IOSTANDARD  LVCMOS33 [get_ports W18]
set_property PACKAGE_PIN U15      [get_ports U15]					
set_property IOSTANDARD  LVCMOS33 [get_ports U15]
set_property PACKAGE_PIN U14      [get_ports U14]					
set_property IOSTANDARD  LVCMOS33 [get_ports U14]
set_property PACKAGE_PIN V14      [get_ports V14]					
set_property IOSTANDARD  LVCMOS33 [get_ports V14]
set_property PACKAGE_PIN V13      [get_ports V13]					
set_property IOSTANDARD  LVCMOS33 [get_ports V13]
set_property PACKAGE_PIN V3       [get_ports V3]					
set_property IOSTANDARD  LVCMOS33 [get_ports V3]
set_property PACKAGE_PIN W3       [get_ports W3]					
set_property IOSTANDARD  LVCMOS33 [get_ports W3]
set_property PACKAGE_PIN U3       [get_ports U3]					
set_property IOSTANDARD  LVCMOS33 [get_ports U3]
set_property PACKAGE_PIN P3       [get_ports P3]					
set_property IOSTANDARD  LVCMOS33 [get_ports P3]
set_property PACKAGE_PIN N3       [get_ports N3]					
set_property IOSTANDARD  LVCMOS33 [get_ports N3]
set_property PACKAGE_PIN P1       [get_ports P1]					
set_property IOSTANDARD  LVCMOS33 [get_ports P1]
set_property PACKAGE_PIN L1       [get_ports L1]					
set_property IOSTANDARD  LVCMOS33 [get_ports L1]
	
# 7 segment display
set_property PACKAGE_PIN W7       [get_ports W7]					
set_property IOSTANDARD  LVCMOS33 [get_ports W7]
set_property PACKAGE_PIN W6       [get_ports W6]					
set_property IOSTANDARD  LVCMOS33 [get_ports W6]
set_property PACKAGE_PIN U8       [get_ports U8]					
set_property IOSTANDARD  LVCMOS33 [get_ports U8]
set_property PACKAGE_PIN V8       [get_ports V8]					
set_property IOSTANDARD  LVCMOS33 [get_ports V8]
set_property PACKAGE_PIN U5       [get_ports U5]					
set_property IOSTANDARD  LVCMOS33 [get_ports U5]
set_property PACKAGE_PIN V5       [get_ports V5]					
set_property IOSTANDARD  LVCMOS33 [get_ports V5]
set_property PACKAGE_PIN U7       [get_ports U7]					
set_property IOSTANDARD  LVCMOS33 [get_ports U7]

set_property PACKAGE_PIN V7       [get_ports V7]							
set_property IOSTANDARD  LVCMOS33 [get_ports V7]

set_property PACKAGE_PIN U2       [get_ports U2]					
set_property IOSTANDARD  LVCMOS33 [get_ports U2]
set_property PACKAGE_PIN U4       [get_ports U4]					
set_property IOSTANDARD  LVCMOS33 [get_ports U4]
set_property PACKAGE_PIN V4       [get_ports V4]					
set_property IOSTANDARD  LVCMOS33 [get_ports V4]
set_property PACKAGE_PIN W4       [get_ports W4]					
set_property IOSTANDARD  LVCMOS33 [get_ports W4]


# Buttons
set_property PACKAGE_PIN U18      [get_ports U18]						
set_property IOSTANDARD  LVCMOS33 [get_ports U18]
set_property PACKAGE_PIN T18      [get_ports T18]						
set_property IOSTANDARD  LVCMOS33 [get_ports T18]
set_property PACKAGE_PIN W19      [get_ports W19]						
set_property IOSTANDARD  LVCMOS33 [get_ports W19]
set_property PACKAGE_PIN T17      [get_ports T17]						
set_property IOSTANDARD  LVCMOS33 [get_ports T17]
set_property PACKAGE_PIN U17      [get_ports U17]						
set_property IOSTANDARD  LVCMOS33 [get_ports U17]
 
# Pmod Header JA
# Sch name = JA1
set_property PACKAGE_PIN J1       [get_ports J1]					
set_property IOSTANDARD  LVCMOS33 [get_ports J1]
# Sch name = JA2
set_property PACKAGE_PIN L2       [get_ports L2]					
set_property IOSTANDARD  LVCMOS33 [get_ports L2]
# Sch name = JA3
set_property PACKAGE_PIN J2       [get_ports J2]					
set_property IOSTANDARD  LVCMOS33 [get_ports J2]
# Sch name = JA4
set_property PACKAGE_PIN G2       [get_ports G2]					
set_property IOSTANDARD  LVCMOS33 [get_ports G2]
# Sch name = JA7
set_property PACKAGE_PIN H1       [get_ports H1]					
set_property IOSTANDARD  LVCMOS33 [get_ports H1]
# Sch name = JA8
set_property PACKAGE_PIN K2       [get_ports K2]					
set_property IOSTANDARD  LVCMOS33 [get_ports K2]
# Sch name = JA9
set_property PACKAGE_PIN H2       [get_ports H2]					
set_property IOSTANDARD  LVCMOS33 [get_ports H2]
# Sch name = JA10
set_property PACKAGE_PIN G3       [get_ports G3]					
set_property IOSTANDARD  LVCMOS33 [get_ports G3]

# Pmod Header JB
# Sch name = JB1
set_property PACKAGE_PIN A14      [get_ports A14]					
set_property IOSTANDARD  LVCMOS33 [get_ports A14]
# Sch name = JB2
set_property PACKAGE_PIN A16      [get_ports A16]					
set_property IOSTANDARD  LVCMOS33 [get_ports A16]
# Sch name = JB3
set_property PACKAGE_PIN B15      [get_ports B15]					
set_property IOSTANDARD  LVCMOS33 [get_ports B15]
# Sch name = JB4
set_property PACKAGE_PIN B16      [get_ports B16]					
set_property IOSTANDARD  LVCMOS33 [get_ports B16]
# Sch name = JB7
set_property PACKAGE_PIN A15      [get_ports A15]					
set_property IOSTANDARD  LVCMOS33 [get_ports A15]
# Sch name = JB8
set_property PACKAGE_PIN A17      [get_ports A17]					
set_property IOSTANDARD  LVCMOS33 [get_ports A17]
# Sch name = JB9
set_property PACKAGE_PIN C15      [get_ports C15]					
set_property IOSTANDARD  LVCMOS33 [get_ports C15]
# Sch name = JB10 
set_property PACKAGE_PIN C16      [get_ports C16]					
set_property IOSTANDARD  LVCMOS33 [get_ports C16]
 
# Pmod Header JC
# Sch name = JC1
set_property PACKAGE_PIN K17      [get_ports K17]					
set_property IOSTANDARD  LVCMOS33 [get_ports K17]
# Sch name = JC2
set_property PACKAGE_PIN M18      [get_ports M18]					
set_property IOSTANDARD  LVCMOS33 [get_ports M18]
# Sch name = JC3
set_property PACKAGE_PIN N17      [get_ports N17]					
set_property IOSTANDARD  LVCMOS33 [get_ports N17]
# Sch name = JC4
set_property PACKAGE_PIN P18      [get_ports P18]					
set_property IOSTANDARD  LVCMOS33 [get_ports P18]
# Sch name = JC7
set_property PACKAGE_PIN L17      [get_ports L17]					
set_property IOSTANDARD  LVCMOS33 [get_ports L17]
# Sch name = JC8
set_property PACKAGE_PIN M19      [get_ports M19]					
set_property IOSTANDARD  LVCMOS33 [get_ports M19]
# Sch name = JC9
set_property PACKAGE_PIN P17      [get_ports P17]					
set_property IOSTANDARD  LVCMOS33 [get_ports P17]
# Sch name = JC10
set_property PACKAGE_PIN R18      [get_ports R18]					
set_property IOSTANDARD  LVCMOS33 [get_ports R18]


# Pmod Header JXADC
# Sch name = XA1_P
set_property PACKAGE_PIN J3       [get_ports J3]				
set_property IOSTANDARD  LVCMOS33 [get_ports J3]
# Sch name = XA2_P
set_property PACKAGE_PIN L3       [get_ports L3]				
set_property IOSTANDARD  LVCMOS33 [get_ports L3]
# Sch name = XA3_P
set_property PACKAGE_PIN M2       [get_ports M2]				
set_property IOSTANDARD  LVCMOS33 [get_ports M2]
# Sch name = XA4_P
set_property PACKAGE_PIN N2       [get_ports N2]				
set_property IOSTANDARD  LVCMOS33 [get_ports N2]
# Sch name = XA1_N
set_property PACKAGE_PIN K3       [get_ports K3]				
set_property IOSTANDARD  LVCMOS33 [get_ports K3]
# Sch name = XA2_N
set_property PACKAGE_PIN M3       [get_ports M3]				
set_property IOSTANDARD  LVCMOS33 [get_ports M3]
# Sch name = XA3_N
set_property PACKAGE_PIN M1       [get_ports M1]				
set_property IOSTANDARD  LVCMOS33 [get_ports M1]
# Sch name = XA4_N
set_property PACKAGE_PIN N1       [get_ports N1]				
set_property IOSTANDARD  LVCMOS33 [get_ports N1]

# VGA Connector
set_property PACKAGE_PIN G19      [get_ports G19]				
set_property IOSTANDARD  LVCMOS33 [get_ports G19]
set_property PACKAGE_PIN H19      [get_ports H19]				
set_property IOSTANDARD  LVCMOS33 [get_ports H19]
set_property PACKAGE_PIN J19      [get_ports J19]				
set_property IOSTANDARD  LVCMOS33 [get_ports J19]
set_property PACKAGE_PIN N19      [get_ports N19]				
set_property IOSTANDARD  LVCMOS33 [get_ports N19]
set_property PACKAGE_PIN N18      [get_ports N18]				
set_property IOSTANDARD  LVCMOS33 [get_ports N18]
set_property PACKAGE_PIN L18      [get_ports L18]				
set_property IOSTANDARD  LVCMOS33 [get_ports L18]
set_property PACKAGE_PIN K18      [get_ports K18]				
set_property IOSTANDARD  LVCMOS33 [get_ports K18]
set_property PACKAGE_PIN J18      [get_ports J18]				
set_property IOSTANDARD  LVCMOS33 [get_ports J18]
set_property PACKAGE_PIN J17      [get_ports J17]				
set_property IOSTANDARD  LVCMOS33 [get_ports J17]
set_property PACKAGE_PIN H17      [get_ports H17]				
set_property IOSTANDARD  LVCMOS33 [get_ports H17]
set_property PACKAGE_PIN G17      [get_ports G17]				
set_property IOSTANDARD  LVCMOS33 [get_ports G17]
set_property PACKAGE_PIN D17      [get_ports D17]				
set_property IOSTANDARD  LVCMOS33 [get_ports D17]
set_property PACKAGE_PIN P19      [get_ports P19]						
set_property IOSTANDARD  LVCMOS33 [get_ports P19]
set_property PACKAGE_PIN R19      [get_ports R19]						
set_property IOSTANDARD  LVCMOS33 [get_ports R19]

# USB-RS232 Interface
# B18 = RX, A18=TX
set_property PACKAGE_PIN B18 [get_ports B18]	    					
set_property IOSTANDARD LVCMOS33 [get_ports B18]
set_property PACKAGE_PIN A18 [get_ports A18]	   		
set_property IOSTANDARD LVCMOS33 [get_ports A18]

# USB HID (PS/2)
#set_property PACKAGE_PIN C17      [get_ports C17]						
#set_property IOSTANDARD  LVCMOS33 [get_ports C17]
#set_property PULLUP      true     [get_ports C17]
#set_property PACKAGE_PIN B17      [get_ports B17]					
#set_property IOSTANDARD  LVCMOS33 [get_ports B17]	
#set_property PULLUP      true     [get_ports B17]

# Quad SPI Flash
# Note that CCLK_0 cannot be placed in 7 series devices. You can access it using the
# STARTUPE2 primitive.
#set_property PACKAGE_PIN D18      [get_ports D18]				
#set_property IOSTANDARD  LVCMOS33 [get_ports D18]
#set_property PACKAGE_PIN D19      [get_ports D19]				
#set_property IOSTANDARD  LVCMOS33 [get_ports D19]
#set_property PACKAGE_PIN G18      [get_ports G18]				
#set_property IOSTANDARD  LVCMOS33 [get_ports G18]
#set_property PACKAGE_PIN F18      [get_ports F18]				
#set_property IOSTANDARD  LVCMOS33 [get_ports F18]
#set_property PACKAGE_PIN K19      [get_ports K19]					
#set_property IOSTANDARD  LVCMOS33 [get_ports K19]