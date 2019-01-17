-- Manager entity to handle all the programs

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity manager is
  PORT (
  	clk0: IN STD_LOGIC;
    reset: IN STD_LOGIC;        -- boton de la placa
    start: IN STD_LOGIC;        -- boton de la placa
    SW0: IN STD_LOGIC;  -- switch to start the belt
    SW1: IN STD_LOGIC;  -- switch to choose the product
    endstop: IN STD_LOGIC;      -- entrada GPIO en caso de construir maqueta. Sino un switch
    bit_robot: OUT STD_LOGIC;    -- salida GPIO
    LED: OUT STD_LOGIC;         -- led de placa
    servo: OUT STD_LOGIC        -- salida GPIO en caso de construir maqueta. Sino un LED

  	);
end manager;

architecture Behavioral of manager is

	COMPONENT loadingBelt
		PORT (
			clk: IN STD_LOGIC;
	    	reset: IN STD_LOGIC;       
	    	start: IN STD_LOGIC;       
	    	SW0: IN STD_LOGIC;  
	    	SW1: IN STD_LOGIC;
	   	 	endstop: IN STD_LOGIC;      
	   		bit_robot: OUT STD_LOGIC;    
	    	LED: OUT STD_LOGIC;         
	    	cinta : OUT STD_LOGIC       
			);
	END COMPONENT;

	COMPONENT PWM
		PORT (
			clk   : IN  STD_LOGIC;
        	reset : IN  STD_LOGIC;
        	move   : IN  STD_LOGIC;
        	servo : OUT STD_LOGIC
			);
	END COMPONENT;

	COMPONENT clk_div
		PORT (
			clk    : in  STD_LOGIC; -- input 100MHz clk0
        	reset  : in  STD_LOGIC;
        	clk_out: out STD_LOGIC
			);
		END COMPONENT;



SIGNAL clk_pwm : STD_LOGIC := '0';
SIGNAL move    : STD_LOGIC := '0';

begin
	
	loadingBelt_map : loadingBelt PORT MAP(
		clk 		=> clk0, 
		reset		=> reset,
		start 		=> start,
		SW0 		=> SW0,
		SW1 		=> SW1,
		endstop 	=> endstop,
		bit_robot 	=> bit_robot,
		LED 		=> LED,
		cinta 		=> move
		);

	clk_div_map : clk_div PORT MAP(
		clk			=> clk0,
		reset		=> reset,
		clk_out 	=> clk_pwm 
		);

	PWM_map : PWM PORT MAP(
		clk 		=> clk_pwm,
		reset		=> reset, 
		move		=> move, 
		servo		=> servo
		);

end Behavioral;
