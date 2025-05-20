library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLightController is
    Port (
        clk : in STD_LOGIC;         -- sygna³ zegarowy
        reset : in STD_LOGIC;       -- reset systemu
        Red : out STD_LOGIC;        -- wyjœcie - czerwone œwiat³o
        Orange : out STD_LOGIC;     -- wyjœcie - pomarañczowe œwiat³o
        Green : out STD_LOGIC       -- wyjœcie - zielone œwiat³o
    );
end TrafficLightController;

architecture Behavioral of TrafficLightController is
    -- Stany automatu
    type State_Type is (STATE_RED, STATE_ORANGE_TO_GREEN, STATE_GREEN, STATE_ORANGE_TO_RED);
    signal current_state, next_state : State_Type;
    signal counter : INTEGER range 0 to 11 := 0; -- Licznik 5-sekundowych kroków (12 kroków = 60 sekund)

begin
    -- Proces zmiany stanu
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= STATE_RED; -- Stan pocz¹tkowy
            counter <= 0;
        elsif rising_edge(clk) then
            if counter = 11 then
                counter <= 0; -- Reset licznika po pe³nym cyklu
            else
                counter <= counter + 1;
            end if;

            -- Przejœcie do nastêpnego stanu
            current_state <= next_state;
        end if;
    end process;

    -- Logika przejœæ miêdzy stanami
    process(current_state, counter)
    begin
        case current_state is
            when STATE_RED =>
                if counter = 3 then -- Czerwone œwieci przez 20 sekund (4 * 5s)
                    next_state <= STATE_ORANGE_TO_GREEN;
                else
                    next_state <= STATE_RED;
                end if;

            when STATE_ORANGE_TO_GREEN =>
                if counter = 4 then -- Pomarañczowe œwieci przez 5 sekund (1 * 5s)
                    next_state <= STATE_GREEN;
                else
                    next_state <= STATE_ORANGE_TO_GREEN;
                end if;

            when STATE_GREEN =>
                if counter = 9 then -- Zielone œwieci przez 30 sekund (6 * 5s)
                    next_state <= STATE_ORANGE_TO_RED;
                else
                    next_state <= STATE_GREEN;
                end if;

            when STATE_ORANGE_TO_RED =>
                if counter = 10 then -- Pomarañczowe œwieci przez 5 sekund (1 * 5s)
                    next_state <= STATE_RED;
                else
                    next_state <= STATE_ORANGE_TO_RED;
                end if;

            when others =>
                next_state <= STATE_RED; -- Bezpieczny stan domyœlny
        end case;
    end process;

    -- Logika wyjœæ
    process(current_state)
    begin
        -- Domyœlnie wy³¹cz wszystkie œwiat³a
        Red <= '0';
        Orange <= '0';
        Green <= '0';

        case current_state is
            when STATE_RED =>
                Red <= '1';
            when STATE_ORANGE_TO_GREEN =>
                Orange <= '1';
            when STATE_GREEN =>
                Green <= '1';
            when STATE_ORANGE_TO_RED =>
                Orange <= '1';
            when others =>
                -- Wszystkie œwiat³a wy³¹czone w stanie domyœlnym
                Red <= '0';
                Orange <= '0';
                Green <= '0';
        end case;
    end process;

end Behavioral;
