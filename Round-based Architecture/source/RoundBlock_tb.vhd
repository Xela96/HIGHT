library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RoundBlock_tb is
end RoundBlock_tb;

architecture Behavioral of RoundBlock_tb is

component RoundBlock
  Port ( X0 : in STD_LOGIC_VECTOR(63 downto 0);
       clock : inout STD_LOGIC;
       X : out STD_LOGIC_VECTOR(2111 downto 0);
       subkey : in STD_LOGIC_VECTOR(1023 downto 0) );
end component;

signal X0s : STD_LOGIC_VECTOR(63 downto 0);
      signal wkey : STD_LOGIC_VECTOR(63 downto 0);
       signal Xs : STD_LOGIC_VECTOR(2111 downto 0);
       signal skey : STD_LOGIC_VECTOR(1023 downto 0);
       signal clk : STD_LOGIC;

begin

    uut: RoundBlock
         Port map (
                   X0 => X0s,
                   clock=>clk,
                   X => Xs,
                   subkey => skey
                   );

    proc: process
    begin 
 X0s <= x"0000001100220033";
 wkey <= x"ccddeeff00112233";  
 skey <= x"d1357c7961a18fda67d9bcf0c7e50f52ae8822552a436495ef018ca2bcdf15f07bb391347a755a93fb2b7aff0706f33ca5986d861f50a1b148555f62cfa7c7f6a9b0ad97d9451b36e41e023916b7f8e89fadb9bfbba15439fadc0ee2f915b5f448919180ced9de4eb5e32d3127032ade2c6a5599906d96d7c99cb0c8e7135b59";
 report "reached 1";
        wait for 300ns;
         report "reached 2";

                 if Xs(63 downto 0) = X"0000001100220033" then
                   report "Initial transformation correct";
               else
                   report "Initial transformation failed" severity error;
       end if;
        
                if Xs(127 downto 64) = X"00ce1138223f33e7" then
                    report "Round 1 passed";
                else
                    report "Round 1 failed" severity error;
        end if;
                
        if skey(191 downto 128) = X"cee138ef3fa3e78a" then
                    report "Round 2 passed";
                else
                    report "Round 2 failed" severity error;
        end if;
                
--        if skey(95 downto 64) = X"906d96d7" then
--                    report "Keys 8-11 passed";
--                else
--                    report "Keys 8-11 failed" severity error;
--        end if;    

                if Xs(71 downto 64) = X"e7" then
                    report "Byte 0 Ok";
                else
                    report "Byte 0 Wrong" severity error;
        end if;   
        
                        if Xs(79 downto 72) = X"33" then
            report "Byte 1 Ok";
        else
            report "Byte 1 Wrong" severity error;
end if;         

                if Xs(87 downto 80) = X"3f" then
                    report "Byte 2 Ok";
                else
                    report "Byte 2 Wrong" severity error;
        end if;         
        
                        if Xs(95 downto 88) = X"22" then
            report "Byte 3 Ok";
        else
            report "Byte 3 Wrong" severity error;
end if;    

                if Xs(103 downto 96) = X"38" then
                    report "Byte 4 Ok";
                else
                    report "Byte 4 Wrong" severity error;
        end if;    
        
                if Xs(111 downto 104) = X"11" then
            report "Byte 5 Ok";
        else
            report "Byte 5 Wrong" severity error;
end if;          

                if Xs(119 downto 112) = X"ce" then
                    report "Byte 6 Ok";
                else
                    report "Byte 6 Wrong" severity error;
        end if;      
        
                        if Xs(127 downto 120) = X"00" then
            report "Byte 7 Ok";
        else
            report "Byte 7 Wrong" severity error;
end if;                      
                             
        wait;
    end process;
    
end Behavioral;
