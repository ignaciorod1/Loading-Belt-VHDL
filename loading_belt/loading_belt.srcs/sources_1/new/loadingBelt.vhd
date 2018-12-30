
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity loadingBelt is
 Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;        -- boton de la placa
    START: IN STD_LOGIC;        -- boton de la placa
    SW0: IN STD_LOGIC;  -- switch to start the belt
    SW1: IN STD_LOGIC;  -- switch to choose the product
    ENDSTOP: IN STD_LOGIC;      -- entrada GPIO en caso de construir maqueta. Sino un switch
    BITROBOT: OUT STD_LOGIC;    -- salida GPIO
    LED: OUT STD_LOGIC;         -- led de placa
    CINTA: OUT STD_LOGIC        -- salida GPIO en caso de construir maqueta. Sino un LED
  );
end loadingBelt;

architecture Behavioral of loadingBelt is

TYPE state_type IS (S0, S1, S2, S3);

SIGNAL state, nextstate: state_type;

BEGIN

SYNC_PROC: PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF RESET = '1' THEN state <= S0;
            ELSE state <= nextstate;
            END IF;
        END IF;
END PROCESS;


OUTPUT_DECODE: PROCESS (state)
BEGIN

 CASE (state) is
    WHEN S0 => LED <= '0';  -- FUTURE RED LED

    WHEN S1 => LED <= '1';  --  FUTURE BLINK LED FUNCTION/ PROCEDURE

    WHEN S2 => CINTA <= '1';

    WHEN S3 => BITROBOT <='1';

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
            LED <= '1';
            IF ( rising_edge(START)) THEN
                IF (ENDSTOP = '0' AND nextstate = S1 ) THEN -- start es con flanco de subida porque es un boton, no un pulsador.
                     nextstate <= S2;
            END IF;
            END IF;

        WHEN S2 =>
            CINTA <= '1';
            IF (ENDSTOP = '1' AND nextstate = S2) THEN
                CASE SW1 IS
                    WHEN '1' => nextstate <= S3;    -- si SW1 esta en 1, la pieza se para y la recoge el robot (estado 3)
                    WHEN OTHERS => nextstate <= S1; -- si SW1 esta en 0, la pieza continua hasta que llega al final de la cinta y cae a una caja
                                                    -- para esto habria que suponer el tiempo que tarda en llegar al final (5 segundos (?)) y ...
                                                    -- ... esto seria es estado 4.
                END CASE;
            END IF; 

        WHEN S3 =>  BITROBOT<='1';

    END CASE;

END PROCESS;
end Behavioral;
    