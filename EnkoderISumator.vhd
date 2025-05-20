library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Zaliczenie1 is
    port( 
        -- Deklaracja sygnalow enkoder priorytetowego
        x   : in  std_logic_vector(7 downto 1);	 -- Sygnal wejsciowy enkodera
        enc : out std_logic_vector(2 downto 0);  -- Zakodowane wyjscie
        -- Deklaracja sygnalow sumatora
        a	 : in  std_logic_vector(3 downto 0); -- Pierwszy sygnal sumy
		b	 : in  std_logic_vector(3 downto 0); -- Drugi sygnal sumy
		cin  : in  std_logic; 					 -- Przeniesienie wejsciowe
        sum  : out std_logic_vector(3 downto 0); -- Wynik sumy
        cout : out std_logic  					 -- Przeniesienie wyjsciowe
    );
end Zaliczenie1;

architecture Zaliczenie of Zaliczenie1 is
    signal carry : std_logic_vector(4 downto 0); -- Dodatkowy sygnal dla przeniesienia
begin		 
	
    -- Logika sumatora 4-bitowego
    carry(0) <= cin; -- Przeniesienie wejsciowe
    gen_sum: for i in 0 to 3 generate
        sum(i) <= a(i) xor b(i) xor carry(i);
        carry(i + 1) <= (a(i) and b(i)) or (a(i) and carry(i)) or (b(i) and carry(i));
    end generate;
    cout <= carry(4); -- Przeniesienie wyjsciowe
	
    -- Logika enkodera priorytetowego
    process(x)
    begin
        if    (x(7) = '1') then
            enc <= "111";
        elsif (x(6) = '1') then
            enc <= "110";
        elsif (x(5) = '1') then
            enc <= "101";
        elsif (x(4) = '1') then
            enc <= "100";
        elsif (x(3) = '1') then
            enc <= "011";
        elsif (x(2) = '1') then
            enc <= "010";
        elsif (x(1) = '1') then
            enc <= "001";
        else
            enc <= "000"; 
        end if;

    end process;
end Zaliczenie;
