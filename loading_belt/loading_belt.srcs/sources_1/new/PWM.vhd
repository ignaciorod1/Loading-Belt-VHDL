library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PWM is
    PORT (
        clk   : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        move   : IN  STD_LOGIC;
        servo : OUT STD_LOGIC
    );
end PWM;

architecture Behavioral of PWM is
    -- Counter, from 0 to 999 (50 KHz / 50 Hz - 1)
    signal cnt : integer range 0 to 1001 := 0;
    -- Temporal signal used to generate the PWM pulse
    signal pwmi: integer range 0 to 200 := 0;
begin
    -- if the belt is activated, the servo gets a 2ms duty cycle order which will move it clockwise (<1.5 ms (75 ticks) counterclockwise)
    movement: process (move) begin
    	if move = '1' then
    		pwmi <= 100;	-- (2ms * 999 ticks per period / 20ms per period)
    	else
    		pwmi <= 75;
    	end if;
    end process;
    -- Counter process, from 0 to 999
    counter: process (reset, clk) begin
        if (reset = '1') then
            cnt <= 0;
        elsif rising_edge(clk) then
            if (cnt = 1000) then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    -- Output signal for the servo
    servo <= '1' WHEN (cnt > 50) AND (cnt < 200) else 
    		 '0';
end Behavioral;