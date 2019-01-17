
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity loadingBelt is
--generic (ClockFrequency : INTEGER:= 50);
 Port (
    clk: IN STD_LOGIC;
    reset: IN STD_LOGIC;        -- boton de la placa
    start: IN STD_LOGIC;        -- boton de la placa
    SW0: IN STD_LOGIC;  -- switch to start the belt
    SW1: IN STD_LOGIC;  -- switch to choose the product
    endstop: IN STD_LOGIC;      -- entrada GPIO en caso de construir maqueta. Sino un switch
    bit_robot: OUT STD_LOGIC;    -- salida GPIO
    LED: OUT STD_LOGIC;         -- led de placa
    cinta: OUT STD_LOGIC        -- salida GPIO en caso de construir maqueta. Sino un LED
  );
end loadingBelt;

architecture Behavioral of loadingBelt is

TYPE state_type IS (S0, S1, S2, S3, S4);

SIGNAL state, nextstate: state_type;
SIGNAL ticks : unsigned( 12 downto 0 ) := (others => '0'); --Signal for counting clock periods

BEGIN

SYNC_PROC: PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN state <= S0;
            
            ELSE state <= nextstate;
            
            END IF;
        ticks <= ticks + 1;    
        END IF;
END PROCESS;


OUTPUT_DECODE: PROCESS (state)
BEGIN

 CASE (state) is
    WHEN S0 => LED <= '0';  -- FUTURE RED LED

    WHEN S1 => LED <= '1';  --  FUTURE BLINK LED FUNCTION/ PROCEDURE

    WHEN S2 => CINTA <= '1';

    WHEN S3 => bit_robot <='1';
               CINTA <= '0';
               
    WHEN S4 => CINTA <= '1';
    
 END CASE;

END PROCESS;

NEXT_STATE_DECODE: PROCESS (state, SW0, SW1, START, ENDSTOP)
BEGIN
    
    IF SW0 = '0' THEN nextstate <= S0;
    END IF;
    
    CASE (state) is

        WHEN S0 =>
            IF (SW0 = '1') THEN nextstate <= S1;
            END IF;

        WHEN S1 =>
            IF ( rising_edge(START)) THEN
                IF (ENDSTOP = '0' AND nextstate = S1 ) THEN -- start es con flanco de subida porque es un boton, no un pulsador.
                     nextstate <= S2;
            END IF;
            END IF;

        WHEN S2 =>
            IF (ENDSTOP = '1' AND nextstate = S2) THEN
                CASE SW1 IS
                    WHEN '1' => nextstate <= S3;    -- si SW1 esta en 1, la pieza se para y la recoge el robot (estado 3)
                    WHEN OTHERS => nextstate <= S4; -- si SW1 esta en 0, la pieza continua hasta que llega al final de la cinta y cae a una caja
                                                    -- para esto habria que suponer el tiempo que tarda en llegar al final (5 segundos (?)) y ...
                                                    -- ... esto seria es estado 4.
                END CASE;
            END IF; 

        WHEN S3 =>  
            
        WHEN S4 =>
            IF ticks = 20000 THEN
            nextstate <= S1;
            
            END IF;
     END CASE;

END PROCESS;
end Behavioral;
    