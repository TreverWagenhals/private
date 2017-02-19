library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Shift_Reg is
port (
	A 				: out std_logic;	
	B 				: out std_logic;	
	C 				: out std_logic;	
	D 				: out std_logic;	
	data_in 		: in std_logic;		
	reset 		: in std_logic;		
	clk 			: in std_logic);	
end Shift_Reg;


architecture behavior of Shift_Reg is

signal A_reg, B_reg	: std_logic := '0';
signal C_reg, D_reg	: std_logic := '0';

begin

	A <= A_reg;
	B <= B_reg;
	C <= C_reg;
	D <= D_reg;
   
	reg_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				A_reg <= '0';
				B_reg <= '0';
				C_reg <= '0';
				D_reg <= '0';
			else
				A_reg <= data_in;
				B_reg <= A_reg;
				C_reg <= B_reg;
				D_reg <= C_reg;
			end if;
		end if;
	end process reg_process;
end behavior;