library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity FinalTransformation is
  Port ( X : in bidirectional_vector(32 downto 0, 7 downto 0);
         clock : in STD_LOGIC;
         whitening_key : in byte(wkBytes-1 downto 0);
         ciphertext : out STD_LOGIC_VECTOR(messageLength-1 downto 0) );
end FinalTransformation;

architecture Behavioral of FinalTransformation is

signal ctext : byte(messageBytes-1 downto 0);
signal Xmid : bidirectional_vector(32 downto 0, 7 downto 0); -- have everything in this signal
signal wkey : byte(wkBytes-1 downto 0);

begin

Xmid<=X; 
wkey<=whitening_key;

Final_Transformation: process
begin
    wait until rising_edge(clock); 
        ctext(1)<=Xmid(32,1); -- byte 1
        ctext(3)<=Xmid(32,3); -- byte 3
        ctext(5)<=Xmid(32,5); -- byte 5
        ctext(7)<=Xmid(32,7); -- byte 7
        
        ctext(0)<= std_logic_vector(to_unsigned((to_integer(unsigned(Xmid(32,0))) + to_integer(unsigned(wkey(4)))),8)); -- byte 0
        ctext(2)<= Xmid(32,2) XOR wkey(5); -- byte 2
        ctext(4)<= std_logic_vector(to_unsigned((to_integer(unsigned(Xmid(32,4))) + to_integer(unsigned(wkey(6)))),8)); -- byte 4
        ctext(6)<= Xmid(32,6) XOR wkey(7); -- byte 6    

        for i in 0 to messageBytes-1 loop
          ciphertext(8*i+7 downto 8*i)<= ctext(i);
        end loop;   
end process;

end Behavioral;
