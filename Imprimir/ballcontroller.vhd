LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-----------------------------------------------------------
ENTITY ballcontroller IS

	PORT 	(		esc										:	IN		STD_LOGIC;
					clk										:	IN		STD_LOGIC;
					rst										:	IN		STD_LOGIC;
					racket         						:	IN		INTEGER;
					posix,posiy,puntosL,puntosV		:	OUT	INTEGER
					
					);
END ENTITY ballcontroller;
-----------------------------------------------------------
ARCHITECTURE rtl OF ballcontroller IS
SIGNAL	anclax   :	INTEGER:=475;
SIGNAL	anclay   :	INTEGER:=280;
SIGNAL	aux   :	INTEGER:=1;
SIGNAL	auy   :	INTEGER:=0;
SIGNAL	resta,puntosLS,puntosVS   :	INTEGER:=0;
SIGNAL	mxt,escenario   :	STD_LOGIC;
SIGNAL	tiempo   :INTEGER:=130944;

------------ HSYNC FP= 16, BP=48, SYNC= 96
------------ VSYNC FP=10, BP=33, SYNC=2
BEGIN
posix<=anclax;
posiy<=anclay;
resta<=anclay-racket;
puntosL<=puntosLS;
puntosV<=puntosVS;
escenario<=esc;
PROCESS(clk,mxt,anclax,racket,anclay,aux,auy) BEGIN

IF(rising_edge(clk))THEN	
	IF(mxt='1')THEN
	anclax<=anclax+aux;
	anclay<=anclay+auy;
	END IF;
	IF((anclax=775) AND (resta=25))THEN
	aux<=-1;
	auy<=0;
	END IF;
	IF((anclax=775) AND (resta>25)AND (resta<60))THEN
	aux<=-1;
	auy<=1;
	END IF;
	IF((anclax=775) AND (resta<25) AND (resta>-10))THEN
	aux<=-1;
	auy<=-1;
	END IF;
	IF((anclax=175) AND (resta=25))THEN
	aux<=1;
	auy<=0;
	END IF;
	IF((anclax=175) AND (resta>25)AND (resta<60))THEN
	aux<=1;
	auy<=1;
	END IF;
	IF((anclax=175) AND (resta<25)AND (resta>-10))THEN
	aux<=1;
	auy<=-1;
	END IF;
	IF(anclay=45 AND aux=1)THEN
	aux<=1;
	auy<=1;
	END IF;
	IF(anclay=45 AND aux=-1)THEN
	aux<=-1;
	auy<=1;
	END IF;
	IF(anclay=515 AND aux=1)THEN
	aux<=1;
	auy<=-1;
	END IF;
	IF(anclay=515 AND aux=-1)THEN
	aux<=-1;
	auy<=-1;
	END IF;
	IF(anclax=160)THEN
		puntosVS<=puntosVS+1;
		tiempo<=tiempo-2500;
		anclax<=475;
		anclay<=280;
		aux<=1;
		auy<=0;
	END IF;
	IF((puntosLS=13)OR(puntosVS=13))THEN
	puntosLS<=0;
	puntosVS<=0;
	tiempo<=130944;
	END IF;
	IF(anclax=790)THEN
		puntosLS<=puntosLS+1;
		tiempo<=tiempo-2500;
		anclax<=475;
		anclay<=280;
		aux<=-1;
		auy<=0;
	END IF;
	END IF;
	
END PROCESS;
timerRY1: ENTITY work.univ_bin_counter
		GENERIC MAP(N=> 19)
		PORT MAP	(rst			=>	rst OR not(escenario),
					 ena			=>	'1',
					 clk			=>	clk,
					 load			=> '0',
					 num_in		=>	"0000000000000000000",
					 max			=>	STD_LOGIC_VECTOR(to_unsigned(tiempo,19)),
					 syn_clr		=>	'0',
					 up			=> '1',
					 max_tick	=>	mxt);
	 
END ARCHITECTURE rtl;
-----------------------------------------------------------