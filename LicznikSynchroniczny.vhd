
-- Licznik synchroniczny zliczaj�cy w g�r� i d� modulo n w kodzie binarnym	
-- Aby poprawnie dzia�a� nale�y odpowiednio ustawi� warto�� "Modulo n" w programie g��wnym 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_bin is
    generic (
        n : integer := 4;  -- Domy�lne modulo n		 												<== Set Modulo n
        w : integer := 3   -- Liczba bit�w (log2(n))
    );
    port (
        clk        : in std_logic;   -- sygna� zegarowy
        clear      : in std_logic;   -- asynchroniczne zerowanie
        load       : in std_logic;   -- �adowanie warto�ci
        ena        : in std_logic;   -- zezwolenie na zliczanie
        up         : in std_logic;   -- sygna� zliczania w g�r�
        down       : in std_logic;   -- sygna� zliczania w d�
        data_in    : in std_logic_vector(w-1 downto 0); -- wpis synchroniczny (binarny)
        count      : out std_logic_vector(w-1 downto 0) -- aktualna warto�� licznika (binarny)
    );
end counter_bin;

architecture behavior of counter_bin is
    signal cnt : std_logic_vector(w-1 downto 0) := (others => '0'); -- aktualna warto�� licznika
begin
    process(clk, clear)
        variable cnt_int : integer range 0 to n-1;
    begin
        -- Asynchroniczne zerowanie
        if (clear = '1') then
            cnt <= (others => '0');

        -- Zdarzenie zbocza dodatniego sygna�u zegara
        elsif rising_edge(clk) then
            if (ena = '1') then
                -- Za�adowanie warto�ci
                if (load = '1') then
                    cnt <= data_in;
                else
                    -- Konwersja std_logic_vector na integer
                    cnt_int := to_integer(unsigned(cnt));

                    -- Zliczanie w g�r�
                    if (up = '1' and down = '0') then
                        cnt_int := (cnt_int + 1) mod n;

                    -- Zliczanie w d�
                    elsif (down = '1' and up = '0') then
                        if (cnt_int = 0) then
                            cnt_int := n - 1; -- Obs�uga przepe�nienia w d�
                        else
                            cnt_int := cnt_int - 1;
                        end if;

                    -- Ignorowanie, je�li oba sygna�y s� aktywne lub �aden nie jest aktywny
                    end if;

                    -- Konwersja integer na std_logic_vector
                    cnt <= std_logic_vector(to_unsigned(cnt_int, w));
                end if;
            end if;
        end if;
    end process;

	--Wyprowadzenie warto�ci
    count <= cnt;
end behavior;
