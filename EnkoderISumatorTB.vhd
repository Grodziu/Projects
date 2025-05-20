library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ZaliczenieTB is
end ZaliczenieTB;

architecture Simulation of ZaliczenieTB is	

    -- Enkoder priorytetowy
    signal x   : std_logic_vector(7 downto 1);
    signal enc : std_logic_vector(2 downto 0);	

    -- Sumator 4 bitowy
    signal a    : std_logic_vector(3 downto 0);	
    signal b    : std_logic_vector(3 downto 0);	
    signal cin  : std_logic;	
    signal sum  : std_logic_vector(3 downto 0);
    signal cout : std_logic;			  
	
begin
    
    uut: entity work.Zaliczenie1 port map (
        x   => x,
        enc => enc,
        a   => a,
        b   => b,
        cin => cin,
        sum => sum,
        cout => cout
    );

    -- Testy dla enkodera priorytetowego
	
    process
    begin
        x <= "0000001"; wait for 10 ns;
        x <= "0000010"; wait for 10 ns;
        x <= "0000100"; wait for 10 ns;
        x <= "0001000"; wait for 10 ns;
        x <= "0010000"; wait for 10 ns;
        x <= "0100000"; wait for 10 ns;
        x <= "1000000"; wait for 10 ns;	
        x <= "0000000"; wait for 10 ns;

        wait; 
    end process;  

    -- Testy dla sumatora 4-bitowego 
	
    process
    begin
    								
    a <= "0000"; b <= "0000"; cin <= '0'; wait for 10 ns;	--Zero bez przeniesienia
    a <= "0001"; b <= "0001"; cin <= '0'; wait for 10 ns;	--Dodanie malych liczb    
    a <= "0000"; b <= "0011"; cin <= '0'; wait for 10 ns;	--Dodanie z malym wynikiem 
	a <= "0011"; b <= "0011"; cin <= '0'; wait for 10 ns;	--Te same wartosci
    a <= "1111"; b <= "1111"; cin <= '0'; wait for 10 ns;	--Maksymalne wartosci bez przeniesienia    
    a <= "1001"; b <= "0101"; cin <= '0'; wait for 10 ns;	--Mieszane wartosci    
    a <= "0000"; b <= "0000"; cin <= '1'; wait for 10 ns;	--Zero z przeniesieniem    
    a <= "0001"; b <= "0010"; cin <= '1'; wait for 10 ns;	--Z malym przeniesieniem   
    a <= "1111"; b <= "1111"; cin <= '1'; wait for 10 ns;	--Graniczny z przeniesieniem    
    a <= "1001"; b <= "0101"; cin <= '1'; wait for 10 ns;	--Mieszane wartosci z przeniesieniem

        wait;
    end process;

end Simulation;
