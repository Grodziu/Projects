
-- Test bench - Licznika synchronicznego Modulo n w kodzie binarnym	 
-- Aby poprawnie dzia³a³ nale¿y odpowiednio ustawiæ wartoœæ "Modulo n" w Test Benchu (w dwóch miejscach)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture behavior of counter_tb is
    -- Komponent testowanego modu³u
    component counter_bin
        generic (
            n : integer := 4;  -- Modulo n	 													<== Set Modulo n
            w : integer := 3   -- Liczba bitów (log2(n))
        );
        port (
            clk        : in std_logic;    -- sygna³ zegarowy
            clear      : in std_logic;    -- asynchroniczne zerowanie
            load       : in std_logic;    -- ³adowanie wartoœci
            ena        : in std_logic;    -- zezwolenie na zliczanie
            up         : in std_logic;    -- zliczanie w górê
            down       : in std_logic;    -- zliczanie w dó³
            data_in    : in std_logic_vector(w-1 downto 0); -- wpis synchroniczny
            count      : out std_logic_vector(w-1 downto 0) -- aktualna wartoœæ licznika
        );
    end component;

    -- Sygna³y do po³¹czenia z testowanym modu³em
    signal clk        : std_logic := '0';
    signal clear      : std_logic := '0';
    signal load       : std_logic := '0';
    signal ena        : std_logic := '0';
    signal up         : std_logic := '0';
    signal down       : std_logic := '0';
    signal data_in    : std_logic_vector(2 downto 0) := (others => '0'); -- 3 bity
    signal count      : std_logic_vector(2 downto 0);

    constant clk_period : time := 10 ns; -- Okres zegara
begin
    -- Instancja testowanego modu³u
    uut: counter_bin
        generic map (
            n => 4, -- Modulo 																	<== Set Modulo n
            w => 3  -- Liczba bitów (log2(8) = 3)
        )
        port map (
            clk      => clk,
            clear    => clear,
            load     => load,
            ena      => ena,
            up       => up,
            down     => down,
            data_in  => data_in,
            count    => count
        );

    -- Generowanie sygna³u zegarowego
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proces testuj¹cy dzia³anie licznika
    stimulus_process: process
    begin
        -- Reset licznika
        clear <= '1';
        wait for clk_period;
        clear <= '0';  

        -- Test zliczania w górê
        ena <= '1';
        up <= '1';    -- Aktywacja zliczania w górê
        down <= '0';  -- Zliczanie w dó³ wy³¹czone
        wait for 8 * clk_period; -- Oczekiwanie na 8 taktów zegara

        -- Test asynchronicznego zerowania w trakcie dzia³ania
        clear <= '1';
        wait for 2 * clk_period; -- Zerowanie przez 2 okresy zegara
        clear <= '0';

        -- Test ponownego zliczania w dó³ po zerowaniu
        up <= '0';
        down <= '1';  -- Aktywacja zliczania w dó³
        wait for 6 * clk_period;

        -- Test za³adowania wartoœci w trakcie dzia³ania
        ena <= '1';
        up <= '0';
        down <= '0';  -- Wy³¹czenie zliczania
        load <= '1';
        data_in <= "011";  -- Wpis synchroniczny wartoœci za³adunku (w kodzie binarnym)
        wait for clk_period;
        load <= '0';

        -- Test zliczania w górê po za³adowaniu wartoœci
        up <= '1';    -- Aktywacja zliczania w górê
        wait for 4 * clk_period;

        -- Test sprzecznych sygna³ów (`up` i `down` aktywne jednoczeœnie)
        up <= '1';
        down <= '1';  -- Sprzeczne sygna³y
        wait for 4 * clk_period;

        -- Zakoñczenie symulacji
        ena <= '0'; -- Wy³¹czenie zliczania
        wait for 2 * clk_period;

        -- Symulacja zakoñczona
        wait;
    end process;
end behavior;
