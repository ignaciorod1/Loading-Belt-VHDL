library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity manager_tb is
end manager_tb;

architecture Behavioral of manager_tb is
COMPONENT manager IS
PORT(
    clk0: IN STD_LOGIC;
    reset: IN STD_LOGIC;        -- boton de la placa
    start: IN STD_LOGIC;        -- boton de la placa
    SW0: IN STD_LOGIC;          -- switch to start the belt
    SW1: IN STD_LOGIC;          -- switch to choose the product
    endstop: IN STD_LOGIC;      -- entrada GPIO 
    bit_micro: IN STD_LOGIC;    -- entrada GPIO del micro a la FPGA para indicar que el trabajo del robot ha terminado
    bit_robot: OUT STD_LOGIC;   -- salida GPIO de la FPGA al micro para indicar inicio del trabajo del robot
    LED: OUT STD_LOGIC;         -- led de placa
    servo: OUT STD_LOGIC        -- salida GPIO 
);
    
END COMPONENT;

TYPE state_type IS (S0, S1, S2, S3, S4);
SIGNAL state, nextstate: state_type;
SIGNAL SW0, SW1, clk0, clk_servo, start: STD_LOGIC := '0';
SIGNAL LED, servo, bit_robot, bit_micro: STD_LOGIC := '0';
SIGNAL ticks : INTEGER RANGE 0 TO 30000  ; --Signal for counting clock periods
SIGNAL reset, endstop: STD_LOGIC := '1';
begin

uut: manager
PORT MAP(
     clk0 => clk0,
     reset => reset,
     start => start,
     LED => LED,
     SW0 => SW0,
     SW1 => SW1,
     endstop => endstop,
     bit_micro => bit_micro,
     bit_robot => bit_robot,
     servo => servo
); 

CLOCK: PROCESS
BEGIN
    clk0 <= NOT clk0 AFTER 5 ns;
    WAIT FOR 5 ns;
END PROCESS;

SYNC_PROC: PROCESS (clk0)
    BEGIN
        IF rising_edge(clk0) THEN
            IF reset = '0' THEN state <= S0;
            ELSE state <= nextstate;
            END IF;
        END IF;
END PROCESS;

NEXT_STATE_DECODE: PROCESS (state, SW0, SW1, start, endstop, bit_micro,ticks)    -- simula la evolucion de las entradas. No se pueden ver directamente como 
begin                                                        -- se hace con las salidas porque son SIGNAL dentro del codigo, y no se pueden meter dentro del
                                                        -- COMPONENT. Para simular su evolucion, esta en el testbench el mismo codigo que en el programa.    
    IF SW0 = '0' THEN nextstate <= S0;
    END IF;
    
    CASE (state) is

        WHEN S0 =>
        
            IF (SW0 = '1') THEN nextstate <= S1;
            END IF;

        WHEN S1 =>
        
            IF (rising_edge(start)) THEN
                IF (endstop = '1' AND nextstate = S1 ) 
                    THEN nextstate <= S2;
            END IF;
            END IF;

        WHEN S2 =>
        
            IF endstop = '0' THEN
                CASE SW1 IS
                    WHEN '1' => nextstate <= S3;
                    WHEN OTHERS => nextstate <= S4;
                END CASE;
            END IF;

        WHEN S3 =>              
        
            IF bit_micro= '1' THEN nextstate <= S0;
            --ELSE nextstate <= S3;
            END IF;
            
        WHEN S4 => 
        
            IF ticks = 20000 THEN nextstate <= S0;
            ELSE nextstate <= S4;
            END IF;
           
    END CASE;

END PROCESS; 

INPUT: PROCESS
BEGIN

    SW0 <= '1' AFTER 3 ms;
    SW1 <= '1' AFTER 2 ms;
    START <= '1' AFTER 15 ms;
 
    WAIT UNTIL rising_edge(START);
    WAIT FOR 5 ms;
    START <= '0';   -- lo apagamos para simular que es un boton

    WAIT FOR 40ms;     -- mientras esto ocurre la pieza actual se esta moviendo y tarda 50 ns desde que se pone endstop a 0 en llegar a este
    ENDSTOP <= '0';
    
    WAIT FOR 10 ms;
    bit_micro <= '1';
    
   WAIT FOR 25 ms;
   SW0 <= '1' AFTER 3 ms;
   SW1 <= '0' AFTER 2 ms;
   START <= '1' AFTER 15 ms;
   endSTOP <= '1';
   WAIT UNTIL rising_edge(START);
   WAIT FOR 5 ms;
   START <= '0';   -- lo apagamos para simular que es un boton
   
   WAIT FOR 20ms;     -- mientras esto ocurre la pieza actual se esta moviendo y tarda 50 ns desde que se pone endstop a 0 en llegar a este
   ENDSTOP <= '0';
   
   WAIT FOR 20 ms;
   TICKS <=  20000;
   
--    WAIT FOR 200 ns;

    --RESET <= '1'; -- simulamos un reset y ahora el codigo con la otra piez (SW1 = '0')

    -- ************** CODIGO PARA LAS ENTRADAS CON SW1 = 0 ************************
--    SW0 <= '1' AFTER 50 ns;
--    SW1 <= '0' AFTER 20 ns;
--    START <= '1' AFTER 150 ns;
    
--    WAIT UNTIL rising_edge(START);
--    WAIT FOR 10 ns;
--    START <= '0';
    
--    WAIT FOR 50 ns;
--    ENDSTOP <= '1';
--    WAIT FOR 200 ns;
    
--    RESET <= '1';


    --************** fin *********
    WAIT;

END PROCESS;

end Behavioral;

    
