library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLightController_tb is
-- Brak port�w w test benchu
end TrafficLightController_tb;

architecture Behavioral of TrafficLightController_tb is
    -- Deklaracja sygna��w do po��czenia z testowanym modu�em
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal Red : STD_LOGIC;
    signal Orange : STD_LOGIC;
    signal Green : STD_LOGIC;

    -- Sta�a do symulacji okresu zegara (5s symulowane jako 50 ns)
    constant CLK_PERIOD : time := 50 ns;

begin
    -- Instancja testowanego modu�u
    uut: entity work.TrafficLightController
        port map (
            clk => clk,
            reset => reset,
            Red => Red,
            Orange => Orange,
            Green => Green
        );

    -- Generowanie sygna�u zegarowego
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Proces testuj�cy
    stim_proc: process
    begin
        -- Zresetowanie systemu
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Symulacja pracy automatu przez dwa pe�ne cykle (2 * 12 krok�w)
        wait for 24 * CLK_PERIOD;											-- Tu zmieniamy moment testowego resetu

        -- Aktywacja resetu w trzecim cyklu
        report "Activating reset in the 3rd cycle";
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Symulacja pracy automatu przez kolejne 2 cykle
        wait for 24 * CLK_PERIOD;

        -- Zako�czenie symulacji
        report "End of simulation";
        wait;
    end process;

end Behavioral;
