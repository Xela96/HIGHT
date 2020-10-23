library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity RoundBlock is
    generic (clock_period : time := 20ns);
  Port ( X0 : in byte(7 downto 0);
         clock : in STD_LOGIC;
         X : out bidirectional_vector(32 downto 0, 7 downto 0);
         subkey : in byte(skBytes-1 downto 0) );
end RoundBlock;

architecture Behavioral of RoundBlock is
    
    signal skey : byte(skBytes-1 downto 0);
    signal Xmid : bidirectional_vector(32 downto 0, 7 downto 0);
            
    signal X0s : byte(7 downto 0);
        
function f0(Xm : STD_LOGIC_VECTOR(7 downto 0))
          return STD_LOGIC_VECTOR is
          variable tmp : STD_LOGIC_VECTOR(7 downto 0);
          begin
            tmp:=std_logic_vector(unsigned(Xm) rol 1) XOR std_logic_vector(unsigned(Xm) rol 2) XOR std_logic_vector(unsigned(Xm) rol 7);
          return tmp;
          end function;
          
function f1(Xm : STD_LOGIC_VECTOR(7 downto 0))
            return STD_LOGIC_VECTOR is
            variable tmp : STD_LOGIC_VECTOR(7 downto 0);
            begin
              tmp:=std_logic_vector(unsigned(Xm) rol 3) XOR std_logic_vector(unsigned(Xm) rol 4) XOR std_logic_vector(unsigned(Xm) rol 6);
            return tmp;
            end function;

begin

skey<=subkey;
X0s<=X0;

Round_Function: process

begin
  for i in 0 to 7 loop      
    Xmid(0,i)<=X0s(i);
  end loop;
    wait until rising_edge(clock);
      for i in 0 to 30 loop
                      
        Xmid(i+1,0)<=Xmid(i,7) XOR  std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xmid(i,6))))
                                                                + to_integer(unsigned(skey((4*i)+3)))),8));
    
        Xmid(i+1,2)<=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xmid(i,0)) XOR skey(4*i)))
                                                   + to_integer(unsigned(Xmid(i,1)))),8));
                                                                                 
        Xmid(i+1,4)<=Xmid(i,3) XOR std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xmid(i,2)))) 
                                                               + to_integer(unsigned(skey((4*i)+1)))),8));
                                                    
        Xmid(i+1,6)<=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xmid(i,4)) XOR skey((4*i)+2)))
                                                   + to_integer(unsigned(Xmid(i,5)))),8));
        
        Xmid(i+1,1)<= Xmid(i,0);             
        Xmid(i+1,3)<= Xmid(i,2);
        Xmid(i+1,5)<= Xmid(i,4);                                                                                                                                                            
        Xmid(i+1,7)<= Xmid(i,6); 
      end loop;       
        -- i=31
        Xmid(32,0)<= Xmid(31,0);
        Xmid(32,2)<= Xmid(31,2);
        Xmid(32,4)<= Xmid(31,4);
        Xmid(32,6)<= Xmid(31,6);
          
        Xmid(32,1)<=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xmid(31,0)) XOR skey(124)))
                                                  + to_integer(unsigned(Xmid(31,1)))),8));
                                                                
        Xmid(32,3)<= Xmid(31,3) XOR ( std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xmid(31,2))))
                                                                  + to_integer(unsigned(skey(125)))),8)) );
                                                                                                    
        Xmid(32,5)<= std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xmid(31,4)) XOR skey(126)))
                                                 + to_integer(unsigned(Xmid(31,5)))),8));
                                                                                                                                                          
        Xmid(32,7)<= Xmid(31,7) XOR ( std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xmid(31,6))))
                                                                  + to_integer(unsigned(skey(127)))),8)) );
wait for 1ns;
end process;

X<=Xmid;

end Behavioral;
