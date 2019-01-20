library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity loadingBelt_tb is
end loadingBelt_tb;

architecture Behavioral of loadingBelt_tb is
COMPONENT loadingBelt IS
PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    START: IN STD_LOGIC;
    SW0: IN STD_LOGIC;
    SW1: IN STD_LOGIC;
    ENDSTOP: IN STD_LOGIC;
    LED: OUT STD_LOGIC;
    CINTA: OUT STD_LOGIC;
    BITROBOT: OUT STD_LOGIC
 
    );
    
END COMPONENT;

TYPE state_type IS (S0, S1, S2, S3, S4);
SIGNAL state, nextstate: state_type;
SIGNAL SW0, SW1, RESET,CLK, START, ENDSTOP: STD_LOGIC := '0';
SIGNAL LED, CINTA, BITROBOT: STD_LOGIC := '0';
SIGNAL TICKS : unsigned( 12 downto 0 ) := (others => '0'); --Signal for counting clock periods

begin

uut: loadingBelt
PORT MAP(
     CLK => CLK,
     RESET => RESET,
     START => START,
     LED => LED,
     SW0 => SW0,
     SW1 => SW1,
     ENDSTOP => ENDSTOP,
     CINTA => CINTA

); 

CLOCK: PROCESS
BEGIN
    CLK <= NOT CLK AFTER 5 ns;
    WAIT FOR 10 ns;
END PROCESS;

SYNC_PROC: PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF RESET = '1' THEN state <= S0;
            ELSE state <= nextstate;
            END IF;
        END IF;
END PROCESS;

NEXT_STATE_DECODE: PROCESS (state, SW0, SW1, START, ENDSTOP)    -- simula la evolucion de las entradas. No se pueden ver directamente como 
begin                                                        -- se hace con las salidas porque son SIGNAL dentro del codigo, y no se pueden meter dentro del
                                                        -- COMPONENT. Para simular su evolucion, esta en el testbench el mismo codigo que en el programa.    
    IF SW0 = '0' THEN nextstate <= S0;
    END IF;
    
    CASE (state) is

        WHEN S0 =>
            IF (SW0 = '1') THEN nextstate <= S1;
            END IF;

        WHEN S1 =>
            IF (rising_edge(START)) THEN
                IF (ENDSTOP = '0' AND nextstate = S1 ) 
                    THEN nextstate <= S2;
            END IF;
            END IF;

        WHEN S2 =>
            CINTA<= '1';
            IF (ENDSTOP = '1' AND nextstate = S2) THEN
                CASE SW1 IS
                    WHEN '1' => nextstate <= S3;
                    WHEN OTHERS => nextstate <= S1;
                END CASE;
            END IF;

        WHEN S3 =>  BITROBOT <= '1'; 
                    CINTA <= '0';
               
        
        WHEN S4 =>  CINTA <= '1'; 
                    IF ticks = 20000 THEN
                    nextstate <= S1;
                    
                    END IF;
           
    END CASE;

END PROCESS; 

INPUT: PROCESS
BEGIN

    SW0 <= '1' AFTER 50 ns;
    SW1 <= '1' AFTER 20 ns;
    START <= '1' AFTER 150 ns;
 
    WAIT UNTIL rising_edge(START);
    WAIT FOR 10 ns;
    START <= '0';   -- lo apagamos para simular que es un boton

    WAIT FOR 50 ns;     -- mientras esto ocurre la pieza actual se esta moviendo y tarda 50 ns desde que se pone endstop a 0 en llegar a este
    ENDSTOP <= '1';
    WAIT FOR 200 ns;

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

    
