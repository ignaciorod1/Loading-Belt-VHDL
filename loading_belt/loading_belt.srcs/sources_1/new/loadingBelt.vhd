
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
    BITROBOT: OUT STD_LOGIC;
    LED: OUT STD_LOGIC;
    CINTA: OUT STD_LOGIC
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
begin
SYNC_PROC: PROCESS (CLK)
BEGIN
IF rising_edge(CLK) THEN
IF (RESET = '1') THEN state <= S0;
ELSE state <= nextstate;
END IF;
END IF;
END PROCESS;


OUTPUT_DECODE: PROCESS (state)
BEGIN
 CASE (state) is
WHEN S1 => LED <= '1';
WHEN S2 => CINTA <= '1';
WHEN S3 => BITROBOT <='1';
END CASE;
END PROCESS;

NEXT_STATE_DECODE: PROCESS (state, SW0, START, ENDSTOP, P1,P2)
BEGIN
nextstate <= S0;
CASE (state) is
WHEN S0 =>
IF (SW0 = '1') THEN nextstate <= S1;
END IF;
WHEN S1 =>
LED <= '1';
IF ( START = '1' AND ENDSTOP = '0' AND nextstate = S1 ) THEN nextstate <= S2;
END IF;
WHEN S2 =>
CINTA<= '1';
-- bifurcacion
IF ( P1 = '1' AND ENDSTOP = '1' AND nextstate = S2 AND  P2 = '0' ) THEN
        nextstate <= S3;

IF ( P1 = '0' AND ENDSTOP = '1' AND nextstate = S2 AND  P2 = '1' ) THEN
        nextstate <= S1;
END IF;
END IF;
WHEN S3 =>
BITROBOT<='1';

END CASE;
END PROCESS;
end Behavioral;
