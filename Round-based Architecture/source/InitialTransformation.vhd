library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity InitialTransformation is
  Port ( plaintext : in STD_LOGIC_VECTOR(messageLength-1 downto 0);
         clock : in STD_LOGIC;
         whitening_key : in byte(wkBytes-1 downto 0);
         X0 : out byte(7 downto 0) );
end InitialTransformation;

architecture Behavioral of InitialTransformation is

    type bidirectional_vector is array (integer range <>, integer range <>) of std_logic_vector(7 downto 0);
    
    signal ptext : byte(messageBytes-1 downto 0);
    signal wkey : byte(wkBytes-1 downto 0);
    signal Xmid : byte(messageBytes-1 downto 0); -- have everything in this signal

begin

wkey<=whitening_key;

Initial_Transformation: process
begin    
for i in 0 to messageBytes-1 loop
    ptext(i)<= plaintext(8*i+7 downto 8*i);
end loop;
    wait until rising_edge(clock); 
        Xmid(0)<= std_logic_vector(to_unsigned((to_integer(unsigned(ptext(0))) + to_integer(unsigned(wkey(0)))),8)); -- byte 0
        Xmid(2)<= ptext(2) XOR wkey(1); -- byte 2
        Xmid(4)<= std_logic_vector(to_unsigned((to_integer(unsigned(ptext(4))) + to_integer(unsigned(wkey(2)))),8)); -- byte 4
        Xmid(6)<= ptext(6) XOR wkey(3); -- byte 6
        
        Xmid(1)<=ptext(1); -- byte 1
        Xmid(3)<=ptext(3); -- byte 3
        Xmid(5)<=ptext(5); -- byte 5
        Xmid(7)<=ptext(7); -- byte 7        
wait for 10ns;
end process;

X0<=Xmid;

end Behavioral;
