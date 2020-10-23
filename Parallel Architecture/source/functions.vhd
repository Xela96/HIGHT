library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

package functions is 
        
        function f0(Xmid : STD_LOGIC_VECTOR(7 downto 0))
                      return STD_LOGIC_VECTOR;
                      
        function f1(Xmid : STD_LOGIC_VECTOR(7 downto 0))
                      return STD_LOGIC_VECTOR;
                      
        function WhiteningKeyGeneration(masterkey : STD_LOGIC_VECTOR(keyLength-1 downto 0))
                                  return byte;
                                  
        function SubkeyGeneration(masterkey : STD_LOGIC_VECTOR(keyLength-1 downto 0))
                                              return byte;                                                    
        
        function initial_transformation(wkey : byte(wkBytes-1 downto 0); intxt : STD_LOGIC_VECTOR(messageLength-1 downto 0))
                                        return byte;
                                        
        function RoundFunction(skey : byte(skBytes-1 downto 0); Xmid : byte(7 downto 0))
                                                    return bidirectional_vector; 
                                                    
        function FinalTransformation(wkey : byte(wkBytes-1 downto 0); Xm : bidirectional_vector(32 downto 0, 7 downto 0))
                                                    return STD_LOGIC_VECTOR;                                                                                           
        
end package functions;

package body functions is

function f0(Xmid : STD_LOGIC_VECTOR(7 downto 0))
      return STD_LOGIC_VECTOR is
      variable tmp : STD_LOGIC_VECTOR(7 downto 0);
      begin
        tmp:=std_logic_vector(unsigned(Xmid) rol 1) XOR std_logic_vector(unsigned(Xmid) rol 2) XOR std_logic_vector(unsigned(Xmid) rol 7);
      return tmp;
      end function;
          
function f1(Xmid : STD_LOGIC_VECTOR(7 downto 0))
                    return STD_LOGIC_VECTOR is
                    variable tmp : STD_LOGIC_VECTOR(7 downto 0);
                    begin
                      tmp:=std_logic_vector(unsigned(Xmid) rol 3) XOR std_logic_vector(unsigned(Xmid) rol 4) XOR std_logic_vector(unsigned(Xmid) rol 6);
                    return tmp;
                    end function;   
                    
function WhiteningKeyGeneration(masterkey : STD_LOGIC_VECTOR(keyLength-1 downto 0))
            return byte is
            variable wk : byte(7 downto 0); 
            variable mkey : byte(15 downto 0);                                                   
            begin
            for i in 0 to keyBytes-1 loop
                mkey(i):= masterkey(8*i+7 downto 8*i);
            end loop;
          for i in 0 to 3 loop -- Set first 4 Whitening Key bytes
                  wk(i):=mkey(i+12);
                end loop;
                
                for i in 4 to 7 loop -- Set last 4 Whitening Key bytes
                  wk(i):=mkey(i-4);
                end loop;
                return wk;
            end function;               
                        
function SubkeyGeneration(masterkey : STD_LOGIC_VECTOR(keyLength-1 downto 0))
            return byte is
            variable sk : byte(127 downto 0);
            variable S : STD_LOGIC_VECTOR(133 downto 0);
            variable delta : delta_byte(127 downto 0);
            variable mkey : byte(15 downto 0);                                                             
                begin    
                for i in 0 to keyBytes-1 loop
                    mkey(i):= masterkey(8*i+7 downto 8*i);
                end loop;
        
                    S := (0 => '0',1 => '1',2 => '0',3 => '1',4 => '1',5 => '0',6 => '1', others => '0');
                    delta(0) := S(6) & S(5) & S(4) & S(3) & S(2) & S(1) & S(0); --delta(0) is fixed
                    
                    for i in 1 to keyLength-1 loop 
                        S(i+6) := S(i+2) XOR S(i-1);
                        delta(i) := S(i+6) & S(i+5) & S(i+4) & S(i+3) & S(i+2) & S(i+1) & S(i);
                    end loop;
                                            
                    for i in 0 to 7 loop
                     for j in 0 to 7 loop                                       
                    sk((16*i)+j) :=std_logic_vector(to_unsigned((to_integer(unsigned(mkey(( j-i )mod 8 ))) 
                                                                  + to_integer(unsigned(delta((16*i)+j)))),8));
                     sk((16*i)+j+8) :=std_logic_vector(to_unsigned((to_integer(unsigned(mkey((( j-i )mod 8)+8 ))) 
                                                                    + to_integer(unsigned(delta((16*i)+j+8 )))),8));   
                     end loop;
                    end loop;       
                return sk;
                end function;                    
                
function initial_transformation(wkey : byte(wkBytes-1 downto 0); intxt : STD_LOGIC_VECTOR(messageLength-1 downto 0))
            return byte is   
            variable Xm : byte(7 downto 0);
            variable txt : byte(messageBytes-1 downto 0);            
                begin
                for i in 0 to messageBytes-1 loop
                    txt(i):= intxt(8*i+7 downto 8*i);
                end loop;
                Xm(0):= std_logic_vector(to_unsigned((to_integer(unsigned(txt(0))) + to_integer(unsigned(wkey(0)))),8)); -- byte 0
                Xm(2):= txt(2) XOR wkey(1); -- byte 2
                Xm(4):= std_logic_vector(to_unsigned((to_integer(unsigned(txt(4))) + to_integer(unsigned(wkey(2)))),8)); -- byte 4
                Xm(6):= txt(6) XOR wkey(3); -- byte 6
                
                Xm(1):=txt(1); -- byte 1
                Xm(3):=txt(3); -- byte 3
                Xm(5):=txt(5); -- byte 5
                Xm(7):=txt(7); -- byte 7   
                    
                return Xm;
                end function;          
                          
function RoundFunction(skey : byte(skBytes-1 downto 0); Xmid : byte(7 downto 0))
            return bidirectional_vector is
            variable Xm : bidirectional_vector(32 downto 0, 7 downto 0); 
            begin               
            for i in 0 to 7 loop      
              Xm(0,i):=Xmid(i);
            end loop;                    
                for i in 0 to 30 loop --make sure all bytes done correctly                                                                
                    Xm(i+1,0):=Xm(i,7) XOR  std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xm(i,6)))) 
                                                                            + to_integer(unsigned(skey((4*i)+3)))),8)); --64-71
        
                    Xm(i+1,2):=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xm(i,0)) XOR skey(4*i))) 
                                                               + to_integer(unsigned(Xm(i,1)))),8)); --80-87                                                                                                                                                
                                                                                             
                    Xm(i+1,4):=Xm(i,3) XOR std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xm(i,2)))) 
                                                                           + to_integer(unsigned(skey((4*i)+1)))),8)); --96-103                               
                                                                
                    Xm(i+1,6):=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xm(i,4)) XOR skey((4*i)+2))) 
                                                               + to_integer(unsigned(Xm(i,5)))),8)); --112-119
                    
                    Xm(i+1,1):= Xm(i,0);             
                    Xm(i+1,3):= Xm(i,2);
                    Xm(i+1,5):= Xm(i,4);                                                                                                                                                            
                    Xm(i+1,7):= Xm(i,6);
                end loop;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                  
                  -- i=31
                  Xm(32,0):= Xm(31,0);
                  Xm(32,2):= Xm(31,2);
                  Xm(32,4):= Xm(31,4);
                  Xm(32,6):= Xm(31,6);
                  
                  Xm(32,1):=  std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xm(31,0)) XOR skey(124))) 
                                                            + to_integer(unsigned(Xm(31,1)))),8));
                                                                        
                  Xm(32,3):= Xm(31,3) XOR ( std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xm(31,2)))) 
                                                                            + to_integer(unsigned(skey(125)))),8)) );
                                                                                                            
                  Xm(32,5):= std_logic_vector(to_unsigned((to_integer(unsigned(f1(Xm(31,4)) XOR skey(126))) 
                                                           + to_integer(unsigned(Xm(31,5)))),8));  
                                                                                                                                                                  
                  Xm(32,7):= Xm(31,7) XOR ( std_logic_vector(to_unsigned((to_integer(unsigned(f0(Xm(31,6)))) 
                                                                            + to_integer(unsigned(skey(127)))),8)) );              
            return Xm;
            end function;
            
function FinalTransformation(wkey : byte(wkBytes-1 downto 0); Xm : bidirectional_vector(32 downto 0, 7 downto 0))
                      return STD_LOGIC_VECTOR is
                      variable ctext : byte(7 downto 0);
                      variable txt : STD_LOGIC_VECTOR(messageLength-1 downto 0);
                      begin
                      
                      ctext(1):=Xm(32,1); -- byte 1
                      ctext(3):=Xm(32,3); -- byte 3
                      ctext(5):=Xm(32,5); -- byte 5
                      ctext(7):=Xm(32,7); -- byte 7
                      
                      ctext(0):= std_logic_vector(to_unsigned((to_integer(unsigned(Xm(32,0))) + to_integer(unsigned(wkey(4)))),8)); -- byte 0
                      ctext(2):= Xm(32,2) XOR wkey(5); -- byte 2
                      ctext(4):= std_logic_vector(to_unsigned((to_integer(unsigned(Xm(32,4))) + to_integer(unsigned(wkey(6)))),8)); -- byte 4
                      ctext(6):= Xm(32,6) XOR wkey(7); -- byte 6    
                      for i in 0 to messageBytes-1 loop
                          txt(8*i+7 downto 8*i):= ctext(i);
                      end loop;          
                      return txt;
                      end function;  

end package body functions;