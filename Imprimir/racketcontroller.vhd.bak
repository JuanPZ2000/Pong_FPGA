LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-----------------------------------------------------------
ENTITY racketcontroller IS
	PORT 	(		btn1,btn2		:	IN		STD_LOGIC;
					clk				;	IN		STD_LOGIC;
					posi				:	OUT	INTEGER
					);
END ENTITY racketcontroller;
-----------------------------------------------------------
ARCHITECTURE rtl OF racketcontroller IS
SIGNAL	anclayR1   :	INTEGER:=275;
------------ HSYNC FP= 16, BP=48, SYNC= 96
------------ VSYNC FP=10, BP=33, SYNC=2
BEGIN


posi<=anclayR1;

PROCESS(clk,btn1,btn2) BEGIN

IF(rising_edge(clk))THEN	
	IF(btn2='1')THEN
	anclayR1<=anclayR1+10;
	END IF;
	IF(btn1='1')THEN
	anclayR1<=anclayR1-10;
	END IF;
END PROCESS;
	 
END ARCHITECTURE rtl;
-----------------------------------------------------------