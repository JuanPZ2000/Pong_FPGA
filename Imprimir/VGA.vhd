-----------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-----------------------------------------------------------
ENTITY VGA IS
	PORT 	(		clk	:	IN		STD_LOGIC;
					sw		:	IN		STD_LOGIC_VECTOR(1 DOWNTO 0);
					rst	:	IN		STD_LOGIC;
					btn1,btn2,btn3	:	IN		STD_LOGIC;
					Hsync	:	OUT	STD_LOGIC;
					Vsync	:	OUT	STD_LOGIC;
					ssega1		:	OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
					ssega2		:	OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
					ssega3		:	OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
					ssega4		:	OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);
					R		:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
					G		:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
					B		:	OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
					);
END ENTITY VGA;
-----------------------------------------------------------
ARCHITECTURE rtl OF VGA IS
SIGNAL sem1,sem2,sem3,sem4:STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL fondo:STD_LOGIC_VECTOR(11 DOWNTO 0):="111100001111";
SIGNAL resto:STD_LOGIC_VECTOR(11 DOWNTO 0):="000011110000";
SIGNAL	Hpos_S	:	INTEGER:=0;
SIGNAL   R1,G1,B1		:		STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	contadormem	:	INTEGER:=319;
SIGNAL	anclax   :	INTEGER;
SIGNAL	anclay   :	INTEGER;
SIGNAL	anclayR1   :	INTEGER;
SIGNAL 	clk1,btn1d,btn2d,btn3d,mxt,btn1dxd,btn2dxd		: 	STD_LOGIC;
SIGNAL 	dataxd,dataxd1,dataxd2,dataxd3,dataxd4,dataxd5	: 	STD_LOGIC_VECTOR( 319 DOWNTO 0);
SIGNAL	Vpos_S,adr,conta	:	INTEGER:=0;
SIGNAL	escenario	:	STD_LOGIC:='0';
SIGNAL	Hpos_S2	:	INTEGER:=0;
SIGNAL	Vpos_S2,puntosV,puntosL	:	INTEGER:=0;
SIGNAL	gg	:	INTEGER:=0;
------------ HSYNC FP= 16, BP=48, SYNC= 96
------------ VSYNC FP=10, BP=33, SYNC=2
BEGIN

reloj:work.PLL
	PORT MAP(
		inclk0=>clk,
		c0	=> clk1);
fondo<="111100001111" WHEN sw="00" ELSE "000000000000" WHEN sw="01"ELSE "111111111111" WHEN sw="10"ELSE "111100000000" WHEN sw="11";
resto<="000011110000" WHEN sw="00" ELSE "111111111111" WHEN sw="01"ELSE "000000000000" WHEN sw="10"ELSE "000000001111" WHEN sw="11";
R1<=dataxd(contadormem)&dataxd(contadormem)&dataxd(contadormem)&dataxd(contadormem)WHEN conta mod 2=0 ELSE dataxd3(contadormem)&dataxd3(contadormem)&dataxd3(contadormem)&dataxd3(contadormem);
G1<=dataxd1(contadormem)&dataxd1(contadormem)&dataxd1(contadormem)&dataxd1(contadormem)WHEN conta mod 2=0 ELSE dataxd4(contadormem)&dataxd4(contadormem)&dataxd4(contadormem)&dataxd4(contadormem);
B1<=dataxd2(contadormem)&dataxd2(contadormem)&dataxd2(contadormem)&dataxd2(contadormem)WHEN conta mod 2=0 ELSE dataxd5(contadormem)&dataxd5(contadormem)&dataxd5(contadormem)&dataxd5(contadormem);

PROCESS(clk1,Hpos_S,Vpos_S,btn1d,btn2d,btn3d,anclayR1,anclax,anclay,gg,mxt,btn1d,btn2d) BEGIN

IF(rising_edge(clk1))THEN

	--IF((Vpos_S>=45)AND(Hpos_S>=160))THEN
	--R<=dataxd(3 DOWNTO 0);
	--G<=dataxd1(3 DOWNTO 0);
	--B<=dataxd2(3 DOWNTO 0);
	--cont<=cont+1;
	--END IF;
	IF(mxt='1')THEN
	conta<=conta+1;
	END IF;
	IF(btn1d='1')THEN
	escenario<='1';
	END IF;
	IF(btn3d='1')THEN
	escenario<='0';
	END IF;
	IF(escenario='0')THEN
	if(((405)>=Vpos_S AND Vpos_S>=165)AND(640>=Hpos_S AND Hpos_S>=320))THEN
		R<=R1;
		G<=G1;
		B<=B1;
		ELSE
		R<="0000";
		G<="0000";
		B<="0000";
	END IF;
	END IF;
	IF(escenario='1')THEN

	IF(((anclay+10)>=Vpos_S AND Vpos_S>=anclay)AND(anclax+10>=Hpos_S AND Hpos_S>=anclax))THEN--5
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
	ELSIF(((95)>=Vpos_S AND Vpos_S>=55)AND(350>=Hpos_S AND Hpos_S>=330))THEN--primer digito
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
	IF(sem1(3 DOWNTO 0)="0000")THEN--cero
		IF(((90)>=Vpos_S AND Vpos_S>=60)AND(345>=Hpos_S AND Hpos_S>=335))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem1(3 DOWNTO 0)="0001")THEN--uno
		IF(((95)>=Vpos_S AND Vpos_S>=55)AND(345>=Hpos_S AND Hpos_S>=330))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem1(3 DOWNTO 0)="0010")THEN--dos
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(345>=Hpos_S AND Hpos_S>=330))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(350>=Hpos_S AND Hpos_S>=335))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	ELSIF(((95)>=Vpos_S AND Vpos_S>=55)AND(380>=Hpos_S AND Hpos_S>=360))THEN--segundo digito
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
		IF(sem2(3 DOWNTO 0)="0000")THEN--cero
			IF(((90)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=365))THEN
				R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
			END IF;
		END IF;
	IF(sem2(3 DOWNTO 0)="0001")THEN--un0
		IF(((95)>=Vpos_S AND Vpos_S>=55)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0010")THEN--dos
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(380>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0011")THEN--tres
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0100")THEN--cuatro
		IF(((70)>=Vpos_S AND Vpos_S>=55)AND(375>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((95)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0101")THEN--cinco
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(380>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0110")THEN--seis
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(380>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="0111")THEN--sIETE
		IF(((95)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="1000")THEN--OCHO
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem2(3 DOWNTO 0)="1001")THEN--NUEVE
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(375>=Hpos_S AND Hpos_S>=365))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((95)>=Vpos_S AND Vpos_S>=75)AND(375>=Hpos_S AND Hpos_S>=360))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	ELSIF(((95)>=Vpos_S AND Vpos_S>=55)AND(590>=Hpos_S AND Hpos_S>=570))THEN--tercer digito
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
		IF(sem3(3 DOWNTO 0)="0000")THEN--cero
			IF(((90)>=Vpos_S AND Vpos_S>=60)AND(585>=Hpos_S AND Hpos_S>=575))THEN
				R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
			END IF;
		END IF;
		IF(sem3(3 DOWNTO 0)="0001")THEN--uno
		IF(((95)>=Vpos_S AND Vpos_S>=55)AND(585>=Hpos_S AND Hpos_S>=570))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	ELSIF(((95)>=Vpos_S AND Vpos_S>=55)AND(620>=Hpos_S AND Hpos_S>=600))THEN--cuarto digito
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
		IF(sem4(3 DOWNTO 0)="0000")THEN--cero
			IF(((90)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=605))THEN
				R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
			END IF;
		END IF;
	IF(sem4(3 DOWNTO 0)="0001")THEN--uno
		IF(((95)>=Vpos_S AND Vpos_S>=55)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0010")THEN--dos
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(620>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0011")THEN--tres
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0100")THEN--cuatro
		IF(((70)>=Vpos_S AND Vpos_S>=55)AND(615>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((95)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0101")THEN--cinco
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(620>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0110")THEN--seis
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(620>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="0111")THEN--sIETE
		IF(((95)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="1000")THEN--OCHO
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
		IF(((90)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	IF(sem4(3 DOWNTO 0)="1001")THEN--NUEVE
		IF(((70)>=Vpos_S AND Vpos_S>=60)AND(615>=Hpos_S AND Hpos_S>=605))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	IF(((95)>=Vpos_S AND Vpos_S>=75)AND(615>=Hpos_S AND Hpos_S>=600))THEN
			R	<=	fondo(11 DOWNTO 8);
			G	<=	fondo(7 DOWNTO 4);
			B	<=	fondo(3 DOWNTO 0);
		END IF;
	END IF;
	ELSIF(Hpos_S=480)THEN
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
	ELSIF((anclayR1+60>=Vpos_S AND Vpos_S>=(anclayR1))AND(175>=Hpos_S AND Hpos_S>=160 ))THEN
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
	ELSIF((anclayR1+60>=Vpos_S AND Vpos_S>=(anclayR1))AND(800>=Hpos_S AND Hpos_S>=785))THEN
	R	<=	resto(11 DOWNTO 8);
	G	<=	resto(7 DOWNTO 4);
	B	<=	resto(3 DOWNTO 0);
	ELSE
	--if(gg=0)THEN
	R	<=	fondo(11 DOWNTO 8);
	G	<=	fondo(7 DOWNTO 4);
	B	<=	fondo(3 DOWNTO 0);
	--ELSE
	---R	<=	"0000";
	--G	<=	"0000";
	--B	<=	"0000";
	--END IF;
	END IF;
	--------------------------------------------------------------------------------------------------------------
	END IF;
	IF(HPos_S<800) THEN
	HPos_S<=Hpos_S+1;
	ELSE
	Hpos_S<=0;
			IF(VPos_S<525) THEN
				VPOs_S<=Vpos_S+1;
				IF(adr=240)THEN
				adr<=0;
				ELSE
				IF(((405)>=Vpos_S AND Vpos_S>=165))THEN
				adr<=adr+1;
				END IF;
				
				END IF;
			ELSE
				Vpos_S<=0;
			END IF;
	END IF;
	--------------------------------------------------------
	
	-------------------------------------------------------
	-- CONDICIONES PARA SENAL DE SINCRONIZACION EN H Y V
	IF(Hpos_S<112 AND hpos_S>16) THEN
		Hsync<= '0';
		ELSE
		Hsync<= '1';
	END IF;
			
	IF(Vpos_S>10 AND Vpos_S<12) THEN
		Vsync<= '0';
		ELSE
		Vsync<= '1';
	END IF;
				-- ENVIO DE COLORES EN NEGRO PARA H Y V 
	IF((Hpos_S<160 AND Hpos_S>0) OR (VPos_S<45 AND Vpos_S>0)) THEN
		R	<=	"0000";
		G	<=	"0000";
		B	<=	"0000";	

	END IF;
	--IF(VPos_S>165 AND VPos_S<405)THEN
	--adr<=adr+1;
	--ELSE
	--adr<=0;
	--END IF;
	IF((640>=Hpos_S AND Hpos_S>=320))THEN
	contadormem<=contadormem-1;
	ELSE
	contadormem<=319;
	END IF;
END IF;
END PROCESS;
--adr<=std_logic_vector(to_unsigned(cont,19));
deboun1:ENTITY work.debouncing
						PORT MAP( clk     => clk1,
									 ena	  => '1',
									 rst =>rst,
									 sw=>not(btn1),
									 debsw=>btn1d);
deboun2:ENTITY work.debouncing
						PORT MAP(  clk     => clk1,
									 ena	  => '1',
									 rst =>rst,
									 sw=>not(btn2),
									 debsw=>btn2d);
deboun3:ENTITY work.debouncing
						PORT MAP( clk     => clk1,
									 ena	  => '1',
									 rst =>rst,
									 sw=>not(btn3),
									 debsw=>btn3d);
raqueta1:ENTITY work.racketcontroller
						PORT MAP( clk     => clk1,
									 btn1	  => btn1d,
									 btn2 =>btn2d,
									 posi=>anclayR1);	
 
b0la:ENTITY work.ballcontroller
						PORT MAP( clk     => clk1,
										esc=>escenario,
									 rst =>rst,
									 racket=>anclayR1,
									 posix=>anclax,
									 posiy=>anclay,
									 puntosV=>puntosV,
									 puntosL=>puntosL);	
		sseg1a:ENTITY work.bin_to_sseg
						PORT MAP( bin     => sem1(3 DOWNTO 0),
									 sseg	  => ssega1);
		sseg2a:ENTITY work.bin_to_sseg
						PORT MAP( bin     => sem2(3 DOWNTO 0),
									 sseg	  => ssega2);
		sseg3a:ENTITY work.bin_to_sseg
						PORT MAP( bin     => sem3(3 DOWNTO 0),
									 sseg	  => ssega3);
		sseg4a:ENTITY work.bin_to_sseg
						PORT MAP( bin     => sem4(3 DOWNTO 0),
									 sseg	  => ssega4);		
		sem1<=STD_LOGIC_VECTOR(to_unsigned(puntosL,13)/10);
		sem2<=STD_LOGIC_VECTOR((to_unsigned(puntosL,13)mod 10)/1);
		sem3<=STD_LOGIC_VECTOR(((to_unsigned(puntosV,13)/10)));
		sem4<=STD_LOGIC_VECTOR(((to_unsigned(puntosV,13)mod 10)));		 
ramcho:ENTITY work.romRed
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd);		
ramcho1:ENTITY work.romGreen
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd1);		
ramcho2:ENTITY work.romBlue
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd2);
										
ramcho3:ENTITY work.romRed2
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd3);		
ramcho4:ENTITY work.romGreen2
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd4);		
ramcho5:ENTITY work.romBlue2
						PORT MAP( clk     =>clk ,
									 addr=>STD_LOGIC_VECTOR(to_unsigned(adr,8)),
										r_data=> dataxd5);
timerRY2: ENTITY work.univ_bin_counter
		GENERIC MAP(N=> 24)
		PORT MAP	(rst			=>	rst,
					 ena			=>	'1',
					 clk			=>	clk,
					 load			=> '0',
					 num_in		=>	"101111101011110000100000",
					 max			=>	"101111101011110000100000",
					 syn_clr		=>	'0',
					 up			=> '1',
					 max_tick	=>	mxt);
							
END ARCHITECTURE rtl;
-----------------------------------------------------------