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
    CINTA: OUT STD_LOGIC
    );
    
END COMPONENT;

TYPE state_type IS (S0, S1, S2);
SIGNAL state, next_state: state_type;
SIGNAL SW0_TB, SW1_TB, RESET_TB,CLK_TB, START_TB, ENDSTOP_TB: STD_LOGIC := '0';
SIGNAL LED_TB, CINTA_TB: STD_LOGIC ;

begin

uut: loadingBelt
PORT MAP(
     CLK => CLK_TB,
     RESET => RESET_TB,
     START => START_TB,
     LED => LED_TB,
     SW0 => SW0_TB,
     SW1 => SW1_TB,
     ENDSTOP => ENDSTOP_TB,
     CINTA => CINTA_TB
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

    assert ((LED_TB = '1') AND (state = S1))  -- expected output
            -- error will be reported if sum or carry is not 0
            report "test failed for state switch 0 -> 1" severity error;

    START_TB <= '1' AFTER 150 ns;
    WAIT FOR 100 ns;

    assert ((CINTA_TB = '1') AND (state = S2))
    report "test failed for the state switch 1 -> 2" severity error;
END PROCESS;

end Behavioral;

    
