library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity clk_div is
    Port (
        clk    : in  STD_LOGIC; -- input 100MHz clk
        reset  : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end clk_div;
 
architecture Behavioral of clk_div is
    signal temporal: STD_LOGIC;
    signal counter : integer range 0 to 2000 := 0;
begin
    freq_divider: process (reset, clk) begin
        if (reset = '1') then
            temporal <= '0';
            counter  <= 0;
        elsif rising_edge(clk) then
            if (counter = 780) then
                temporal <= NOT(temporal);
                counter  <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
 
    clk_out <= temporal;
end Behavioral;