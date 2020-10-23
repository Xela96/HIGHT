library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity KeySchedule is
    Port ( masterkey : in STD_LOGIC_VECTOR(keyLength-1 downto 0);
           whitening_key : out byte(wkBytes-1 downto 0);
           subkey : out byte(skBytes-1 downto 0) );
end KeySchedule;

architecture Behavioral of KeySchedule is

signal skey : byte(skBytes-1 downto 0);
signal mkey : byte(keyBytes-1 downto 0);

signal delta : delta_byte(127 downto 0);
signal S: STD_ULOGIC_VECTOR (133 downto 0);
signal wkey : byte(wkBytes-1 downto 0);

begin

--mkey<=masterkey;
    wkey_generation: process(mkey, masterkey) --Generation of Whitening Keys uses bytes from Masterkey
        begin
        for i in 0 to keyBytes-1 loop
            mkey(i)<= masterkey(8*i+7 downto 8*i);
        end loop;
          for i in 0 to 3 loop -- Set first 4 Whitening Key bytes
                wkey(i)<=mkey(i+12);
              end loop;
              
              for i in 4 to wkBytes-1 loop -- Set last 4 Whitening Key bytes
                wkey(i)<=mkey(i-4);
              end loop;
        end process;

whitening_key<=wkey;  
    
constant_generation: process -- generates 128 7-bit constants (delta)
            begin    
    
                S <= (0 => '0',1 => '1',2 => '0',3 => '1',4 => '1',5 => '0',6 => '1', others => '0');
                delta(0) <= S(6) & S(5) & S(4) & S(3) & S(2) & S(1) & S(0); --delta(0) is fixed
                
                for i in 1 to 127 loop 
                    S(i+6) <= S(i+2) XOR S(i-1);
                    delta(i) <= S(i+6) & S(i+5) & S(i+4) & S(i+3) & S(i+2) & S(i+1) & S(i);
                end loop;
                wait for 1ns;
            end process;

        subkey_generation: process
            begin -- Process generates the subkeys
                
                for i in 0 to 7 loop
                 for j in 0 to 7 loop                                       
                    skey((16*i)+j) <=std_logic_vector(to_unsigned((to_integer(unsigned(mkey(( j-i )mod 8 ))) 
                                                                 + to_integer(unsigned(delta((16*i)+j)))),8));
                    skey((16*i)+j+8) <=std_logic_vector(to_unsigned((to_integer(unsigned(mkey((( j-i )mod 8)+8 ))) 
                                                                   + to_integer(unsigned(delta((16*i)+j+8 )))),8));  
                 end loop;
                end loop;
            wait for 10ns;
            end process;
    
            subkey<=skey;    

end Behavioral;
