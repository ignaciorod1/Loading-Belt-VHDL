
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
SIGNAL state0, state1, state2, state3: estados;
--deberiamos declarar BITROBOT como SEÑAL?
begin
 

end Behavioral;
