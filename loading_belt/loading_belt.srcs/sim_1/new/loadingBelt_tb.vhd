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



end Behavioral;
