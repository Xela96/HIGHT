library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity stimgen is

    generic (clock_period : time);
  Port ( plaintext : out STD_LOGIC_VECTOR(messageLength-1 downto 0);
         clock : inout STD_LOGIC;
         masterkey : out STD_LOGIC_VECTOR(keyLength-1 downto 0);
         ciphertext : in STD_LOGIC_VECTOR(messageLength-1 downto 0) );
end stimgen;

architecture Behavioral of stimgen is
 
  signal DONE : boolean := false;
  signal FAILED: boolean := false;

begin
    
   -- Clock generator
   Clock1: process
       variable clktmp : std_logic := '1';
   begin       
       while DONE /= true and FAILED /= true loop
           wait for CLOCK_PERIOD/2;
           clktmp := not clktmp;
           Clock <= clktmp;
       end loop;        
       wait;        
end process;
        
    
    -- Apply stimulus signals and check result 
    CheckResult: process
    begin
        wait for CLOCK_PERIOD; 
        
            plaintext <= x"0000000000000000";            
            masterkey <= x"00112233445566778899aabbccddeeff";
            wait for 750ns;
            plaintext <= x"0011223344556677";
            masterkey <= x"ffeeddccbbaa99887766554433221100";
            wait; 
               wait;
              DONE <= true;                             
           end process;

end Behavioral;
