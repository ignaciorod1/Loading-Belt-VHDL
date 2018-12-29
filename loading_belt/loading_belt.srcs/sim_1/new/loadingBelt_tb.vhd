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
    LED: OUT STD_LOGIC
    );
    
END COMPONENT;

TYPE state_type IS (S0, S1);
SIGNAL state, next_state: state_type;
SIGNAL SW0_TB,RESET_TB,CLK_TB, START_TB: STD_LOGIC := '0';
SIGNAL LED_TB: STD_LOGIC ;

begin

uut: state1
PORT MAP(
     CLK => CLK_TB,
     RESET => RESET_TB,
     START => START_TB,
     LED => LED_TB,
     SW0 => SW0_TB
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
END PROCESS;

RESET: PROCESS
BEGIN
    RESET_TB <= NOT RESET_TB AFTER 300 ns;
    WAIT FOR 100 ns;
END PROCESS;

PROCESS(CLK_TB , RESET_TB)
BEGIN
    IF RESET_TB = '1' THEN state <= S0;
    ELSIF  rising_edge(CLK_TB) THEN state <= next_state;
    END IF;
END PROCESS;

S0_1: PROCESS(state, SW0_TB)
BEGIN
    IF state = S0 THEN
        IF SW0_TB = '1' THEN next_state <= S1;
        ELSE next_state <= S0;
        END IF;
    END IF;
   
END PROCESS;
    
OUTPUT: PROCESS(state, next_state, SW0_TB)
BEGIN
    IF state = S0 THEN LED_TB <= '0';
    ELSIF state <= S1 THEN LED_TB <= '1';
    END IF;
END PROCESS; 





end Behavioral;
