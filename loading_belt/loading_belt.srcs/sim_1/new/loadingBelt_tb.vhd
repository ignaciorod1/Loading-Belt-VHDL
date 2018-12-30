library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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

TYPE state_type IS (S0, S1, S2, S3);
SIGNAL state, nextstate: state_type;
SIGNAL SW0, SW1, RESET,CLK, START, ENDSTOP: STD_LOGIC := '0';
SIGNAL LED, CINTA, BITROBOT: STD_LOGIC ;

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

INPUT: PROCESS
BEGIN
    SW0 <= '1' AFTER 50 ns;
    WAIT FOR 100 ns;

    assert ((LED = '1') AND (state = S1))  -- expected output
            -- error will be reported if sum or carry is not 0
            report "test failed for state switch 0 -> 1" severity error;

    START <= '1' AFTER 150 ns;
    WAIT FOR 100 ns;

    assert ((CINTA = '1') AND (state = S2))
    report "test failed for the state switch 1 -> 2" severity error;
END PROCESS;

end Behavioral;

    
