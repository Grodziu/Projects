library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TrafficLightController is
    Port (
        clk : in STD_LOGIC;         -- sygna� zegarowy
        reset : in STD_LOGIC;       -- reset systemu
        Red : out STD_LOGIC;        -- wyj�cie - czerwone �wiat�o
        Orange : out STD_LOGIC;     -- wyj�cie - pomara�czowe �wiat�o
        Green : out STD_LOGIC       -- wyj�cie - zielone �wiat�o
    );
end TrafficLightController;

architecture Behavioral of TrafficLightController is
    -- Stany automatu
    type State_Type is (STATE_RED, STATE_ORANGE_TO_GREEN, STATE_GREEN, STATE_ORANGE_TO_RED);
    signal current_state, next_state : State_Type;
    signal counter : INTEGER range 0 to 11 := 0; -- Licznik 5-sekundowych krok�w (12 krok�w = 60 sekund)

begin
    -- Proces zmiany stanu
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= STATE_RED; -- Stan pocz�tkowy
            counter <= 0;
        elsif rising_edge(clk) then
            if counter = 11 then
                counter <= 0; -- Reset licznika po pe�nym cyklu
            else
                counter <= counter + 1;
            end if;

            -- Przej�cie do nast�pnego stanu
            current_state <= next_state;
        end if;
    end process;

    -- Logika przej�� mi�dzy stanami
    process(current_state, counter)
    begin
        case current_state is
            when STATE_RED =>
                if counter = 3 then -- Czerwone �wieci przez 20 sekund (4 * 5s)
                    next_state <= STATE_ORANGE_TO_GREEN;
                else
                    next_state <= STATE_RED;
                end if;

            when STATE_ORANGE_TO_GREEN =>
                if counter = 4 then -- Pomara�czowe �wieci przez 5 sekund (1 * 5s)
                    next_state <= STATE_GREEN;
                else
                    next_state <= STATE_ORANGE_TO_GREEN;
                end if;

            when STATE_GREEN =>
                if counter = 9 then -- Zielone �wieci przez 30 sekund (6 * 5s)
                    next_state <= STATE_ORANGE_TO_RED;
                else
                    next_state <= STATE_GREEN;
                end if;

            when STATE_ORANGE_TO_RED =>
                if counter = 10 then -- Pomara�czowe �wieci przez 5 sekund (1 * 5s)
                    next_state <= STATE_RED;
                else
                    next_state <= STATE_ORANGE_TO_RED;
                end if;

            when others =>
                next_state <= STATE_RED; -- Bezpieczny stan domy�lny
        end case;
    end process;

    -- Logika wyj��
    process(current_state)
    begin
        -- Domy�lnie wy��cz wszystkie �wiat�a
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
                -- Wszystkie �wiat�a wy��czone w stanie domy�lnym
                Red <= '0';
                Orange <= '0';
                Green <= '0';
        end case;
    end process;

end Behavioral;
