library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KeySchedule_tb is
end KeySchedule_tb;

architecture Behavioral of KeySchedule_tb is

    component KeySchedule
    Port( 
         masterkey : in STD_LOGIC_VECTOR(127 downto 0);
         whitening_key : out STD_LOGIC_VECTOR(63 downto 0);
         subkey : out STD_LOGIC_VECTOR(1023 downto 0) );
    end component;
    
    signal wkey : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    
    signal mkey : STD_LOGIC_VECTOR(127 downto 0):=(others => '0');
    signal skey : STD_LOGIC_VECTOR(1023 downto 0):=(others => '0');

begin
    
    uut: KeySchedule
         Port map (
                   masterkey => mkey,
                   subkey => skey,
                   whitening_key => wkey
                   );
    proc: process
    begin              
        mkey <= x"00112233445566778899aabbccddeeff";  
        wait for 350ns;    
        
        if skey(31 downto 0) = X"e7135b59" then
                    report "Keys 0-3 passed";
                else
                    report "Keys 0-3 failed" severity error;
        end if;
                
        if skey(63 downto 32) = X"c99cb0c8" then
                    report "Keys 4-7 passed";
                else
                    report "Keys 4-7 failed" severity error;
        end if;
                
        if skey(95 downto 64) = X"906d96d7" then
                    report "Keys 8-11 passed";
                else
                    report "Keys 8-11 failed" severity error;
        end if;                 


        if skey(127 downto 96) = X"2c6a5599" then
                    report "Keys 12-15 passed";
                else
                    report "Keys 12-15 failed" severity error;
        end if;
        
        if skey(159 downto 128) = X"27032ade" then
                    report "Keys 16-19 passed";
                else
                    report "Keys 16-19 failed" severity error;
        end if;    
        
        if skey(191 downto 160) = X"b5e32d31" then
                    report "Keys 20-23 passed";
                else
                    report "Keys 20-23 failed" severity error;
        end if;
        
        if skey(223 downto 192) = X"ced9de4e" then
                    report "Keys 24-27 passed";
                else
                    report "Keys 24-27 failed" severity error;
        end if;  
        
        if skey(255 downto 224) = X"48919180" then
                    report "Keys 28-31 passed";
                else
                    report "Keys 28-31 failed" severity error;
        end if;  
        
        if skey(287 downto 256) = X"f915b5f4" then
                    report "Keys 32-35 passed";
                else
                    report "Keys 32-35 failed" severity error;
        end if;  
        
        if skey(319 downto 288) = X"fadc0ee2" then
                    report "Keys 36-39 passed";
                else
                    report "Keys 36-39 failed" severity error;
        end if;  
        
        if skey(351 downto 320) = X"bba15439" then
                    report "Keys 40-43 passed";
                else
                    report "Keys 40-43 failed" severity error;
        end if;   
        
        if skey(383 downto 352) = X"9fadb9bf" then
                    report "Keys 44-47 passed";
                else
                    report "Keys 44-47 failed" severity error;
        end if;    
        
        if skey(415 downto 384) = X"16b7f8e8" then
                    report "Keys 48-51 passed";
                else
                    report "Keys 48-51 failed" severity error;
        end if;  
        
        if skey(447 downto 416) = X"e41e0239" then
                    report "Keys 52-55 passed";
                else
                    report "Keys 52-55 failed" severity error;
        end if;  
        
        if skey(479 downto 448) = X"d9451b36" then
                    report "Keys 56-59 passed";
                else
                    report "Keys 56-59 failed" severity error;
        end if;      
        
        if skey(511 downto 480) = X"a9b0ad97" then
                    report "Keys 60-63 passed";
                else
                    report "Keys 60-63 failed" severity error;
        end if;  
        
        if skey(543 downto 512) = X"cfa7c7f6" then
                    report "Keys 64-67 passed";
                else
                    report "Keys 64-67 failed" severity error;
        end if; 
        
        if skey(575 downto 544) = X"48555f62" then
                    report "Keys 68-71 passed";
                else
                    report "Keys 68-71 failed" severity error;
        end if; 
        
        if skey(607 downto 576) = X"1f50a1b1" then
                    report "Keys 72-75 passed";
                else
                    report "Keys 72-75 failed" severity error;
        end if;    
        
        if skey(639 downto 608) = X"a5986d86" then
                    report "Keys 76-79 passed";
                else
                    report "Keys 76-79 failed" severity error;
        end if;   
        
        if skey(671 downto 640) = X"0706f33c" then
                    report "Keys 80-83 passed";
                else
                    report "Keys 80-83 failed" severity error;
        end if;       
        
        if skey(703 downto 672) = X"fb2b7aff" then
                    report "Keys 84-87 passed";
                else
                    report "Keys 84-87 failed" severity error;
        end if;   
        
        if skey(735 downto 704) = X"7a755a93" then
                    report "Keys 88-91 passed";
                else
                    report "Keys 88-91 failed" severity error;
        end if;   
        
        if skey(767 downto 736) = X"7bb39134" then
                    report "Keys 92-95 passed";
                else
                    report "Keys 92-95 failed" severity error;
        end if;     
        
        if skey(799 downto 768) = X"bcdf15f0" then
                    report "Keys 96-99 passed";
                else
                    report "Keys 96-99 failed" severity error;
        end if;   
        
        if skey(831 downto 800) = X"ef018ca2" then
                    report "Keys 100-103 passed";
                else
                    report "Keys 100-103 failed" severity error;
        end if; 
        
        if skey(863 downto 832) = X"2a436495" then
                    report "Keys 104-107 passed";
                else
                    report "Keys 104-107 failed" severity error;
        end if;  
        
        if skey(895 downto 864) = X"ae882255" then
                    report "Keys 108-111 passed";
                else
                    report "Keys 108-111 failed" severity error;
        end if;   
        
        if skey(927 downto 896) = X"c7e50f52" then
                    report "Keys 112-115 passed";
                else
                    report "Keys 112-115 failed" severity error;
        end if; 
        
        if skey(959 downto 928) = X"67d9bcf0" then
                    report "Keys 116-119 passed";
                else
                    report "Keys 116-119 failed" severity error;
        end if;     
        
        if skey(991 downto 960) = X"61a18fda" then
                    report "Keys 120-123 passed";
                else
                    report "Keys 120-123 failed" severity error;
        end if; 
        
        if skey(1023 downto 992) = X"d1357c79" then
                    report "Keys 124-127 passed";
                else
                    report "Keys 124-127 failed" severity error;
        end if;                                                                                                                                                                                 
                             
        wait;
    end process;
    
end Behavioral;
