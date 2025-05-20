
-- Licznik synchroniczny zliczaj¹cy w górê i dó³ modulo n w kodzie binarnym	
-- Aby poprawnie dzia³a³ nale¿y odpowiednio ustawiæ wartoœæ "Modulo n" w programie g³ównym 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_bin is
    generic (
        n : integer := 4;  -- Domyœlne modulo n		 												<== Set Modulo n
        w : integer := 3   -- Liczba bitów (log2(n))
    );
    port (
        clk        : in std_logic;   -- sygna³ zegarowy
        clear      : in std_logic;   -- asynchroniczne zerowanie
        load       : in std_logic;   -- ³adowanie wartoœci
        ena        : in std_logic;   -- zezwolenie na zliczanie
        up         : in std_logic;   -- sygna³ zliczania w górê
        down       : in std_logic;   -- sygna³ zliczania w dó³
        data_in    : in std_logic_vector(w-1 downto 0); -- wpis synchroniczny (binarny)
        count      : out std_logic_vector(w-1 downto 0) -- aktualna wartoœæ licznika (binarny)
    );
end counter_bin;

architecture behavior of counter_bin is
    signal cnt : std_logic_vector(w-1 downto 0) := (others => '0'); -- aktualna wartoœæ licznika
begin
    process(clk, clear)
        variable cnt_int : integer range 0 to n-1;
    begin
        -- Asynchroniczne zerowanie
        if (clear = '1') then
            cnt <= (others => '0');

        -- Zdarzenie zbocza dodatniego sygna³u zegara
        elsif rising_edge(clk) then
            if (ena = '1') then
                -- Za³adowanie wartoœci
                if (load = '1') then
                    cnt <= data_in;
                else
                    -- Konwersja std_logic_vector na integer
                    cnt_int := to_integer(unsigned(cnt));

                    -- Zliczanie w górê
                    if (up = '1' and down = '0') then
                        cnt_int := (cnt_int + 1) mod n;

                    -- Zliczanie w dó³
                    elsif (down = '1' and up = '0') then
                        if (cnt_int = 0) then
                            cnt_int := n - 1; -- Obs³uga przepe³nienia w dó³
                        else
                            cnt_int := cnt_int - 1;
                        end if;

                    -- Ignorowanie, jeœli oba sygna³y s¹ aktywne lub ¿aden nie jest aktywny
                    end if;

                    -- Konwersja integer na std_logic_vector
                    cnt <= std_logic_vector(to_unsigned(cnt_int, w));
                end if;
            end if;
        end if;
    end process;

	--Wyprowadzenie wartoœci
    count <= cnt;
end behavior;
