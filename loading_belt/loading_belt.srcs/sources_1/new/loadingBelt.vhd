
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity loadingBelt is
 Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    START: IN STD_LOGIC;
    SW0: IN STD_LOGIC;
    P1: IN STD_LOGIC;
    P2: IN STD_LOGIC;
    ENSTOP: IN STD_LOGIC;
    BITROBOT: OUT STD_LOGIC
  );
end loadingBelt;

architecture Behavioral of loadingBelt is
TYPE estados IS (S0, S1, S2, S3);

SIGNAL state, nextstate: estados;
SIGNAL SW0_SIGNAL: STD_LOGIC;
SIGNAL BITROBOT_SIGNAL: STD_LOGIC;
SIGNAL ENDSTOP: STD_LOGIC;
SIGNAL P1_SIGNAL, P2_SIGNAL,START_SIGNAL: STD_LOGIC;
SIGNAL reset_signal: STD_LOGIC;


BEGIN
    SYNC_PROC: PROCESS (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF (RESET = '1') THEN state <= S0;
            ELSE IF (SW0 = '1') THEN state <= nextstate;
                                     nextstate <= S1;
            ELSE IF ( START = '1' AND ENDSTOP = '0' AND nextstate = S1 ) THEN
               state <= nextstate;
               nextstate <= S2;                   
            END IF;
        END IF;
--END PROCESS;
--END Behavioral;

