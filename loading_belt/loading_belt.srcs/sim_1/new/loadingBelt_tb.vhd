library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity loadingBelt_tb is
end loadingBelt_tb;

architecture Behavioral of loadingBelt_tb is
COMPONENT state1 IS
PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    START: IN STD_LOGIC;
    SW0: IN STD_LOGIC;
    ENDSTOP: IN STD_LOGIC;
    LED: OUT STD_LOGIC
    );
    
END COMPONENT;

TYPE state_type IS (S0, S1, S2);
SIGNAL state, next_state: state_type;
SIGNAL SW0_TB,RESET_TB,CLK_TB, START_TB, ENDSTOP_TB: STD_LOGIC := '0';
SIGNAL LED_TB: STD_LOGIC ;

begin

uut: state1
PORT MAP(
     CLK => CLK_TB,
     RESET => RESET_TB,
     START => START_TB,
     LED => LED_TB,
     SW0 => SW0_TB,
     ENDSTOP => ENDSTOP_TB
); 

CLOCK: PROCESS
BEGIN
    CLK_TB <= NOT CLK_TB AFTER 5 ns;
    WAIT FOR 10 ns;
END PROCESS; 

INPUT: PROCESS
BEGIN
    SW0_TB <= '1' AFTER 50 ns;
    WAIT FOR 100 ns;
    START_TB <= '1' AFTER 150 ns;
    WAIT FOR 100 ps;
END PROCESS;

RESET: PROCESS
BEGIN
    RESET_TB <= NOT RESET_TB AFTER 300 ns;
    WAIT FOR 10 ns;
END PROCESS;

PROCESS(CLK_TB , RESET_TB)
BEGIN
    IF RESET_TB = '1' THEN state <= S0;
    ELSIF  rising_edge(CLK_TB) THEN state <= next_state;
    END IF;
END PROCESS;

STATE_CHANGE: PROCESS(state, SW0_TB, START_TB, ENDSTOP_TB)
BEGIN

    CASE (state) is
        WHEN S0 =>
            IF (SW0_TB = '1') THEN next_state <= S1;
            ELSE next_state <= S0;
            END IF;

        WHEN S1 =>
            IF rising_edge(START_TB) AND ENDSTOP_TB = '0' THEN next_state <= S2;
            END IF;

        WHEN S2 =>
            next_state <= S2;   -- cambiar
    END CASE;
   
END PROCESS;

OUTPUT: PROCESS(state, next_state, SW0_TB)
BEGIN
    CASE(state) is
        WHEN S0 => LED_TB <= '0';
        WHEN S1 => LED_TB <= '1';
        WHEN S2 => LED_TB <= '0';   -- eliminar 
    END CASE;

END PROCESS; 





end Behavioral;

    
