
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity loadingBelt is
 Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    START: IN STD_LOGIC;
    SW0: IN STD_LOGIC;  -- switch to start the belt
    SW1: IN STD_LOGIC;  -- switch to choose the product
    ENDSTOP: IN STD_LOGIC;
    BITROBOT: OUT STD_LOGIC;
    LED: OUT STD_LOGIC;
    CINTA: OUT STD_LOGIC
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
    WHEN S0 => LED <= '0';
    WHEN S1 => LED <= '1';
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
            IF ( START = '1' AND ENDSTOP = '0' AND nextstate = S1 ) 
                    THEN nextstate <= S2;
            END IF;

        WHEN S2 =>
            CINTA<= '1';
            IF (ENDSTOP = '1' AND nextstate = S2) THEN
--                CASE(SW1) IS
--                    WHEN => '1' nextstate <= S3;
--                    WHEN => '0' nextstate <= S1;
--                END CASE;
            nextstate <= S3;
            END IF;

        WHEN S3 =>  BITROBOT<='1';

    END CASE;

END PROCESS;
end Behavioral;
    