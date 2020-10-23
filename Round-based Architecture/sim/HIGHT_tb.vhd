library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity HIGHT_tb is
end HIGHT_tb;

architecture Behavioral of HIGHT_tb is

  CONSTANT clk_period : time := 73.75ns;

component HIGHT
  Port ( intext : in STD_LOGIC_VECTOR(messageLength-1 downto 0);
         clock : in STD_LOGIC;
         masterkey : in STD_LOGIC_VECTOR(keyLength-1 downto 0);
         outtext : out STD_LOGIC_VECTOR(messageLength-1 downto 0) );
end component;

component stimgen
    generic (clock_period : time := clk_period);
  Port ( plaintext : out STD_LOGIC_VECTOR(messageLength-1 downto 0);
         clock : inout STD_LOGIC;
         masterkey : out STD_LOGIC_VECTOR(keyLength-1 downto 0);
         ciphertext : in STD_LOGIC_VECTOR(messageLength-1 downto 0) );
end component;

    signal mkey : STD_LOGIC_VECTOR(keyLength-1 downto 0);
    
    signal ptext : STD_LOGIC_VECTOR(messageLength-1 downto 0);
    signal ctext : STD_LOGIC_VECTOR(messageLength-1 downto 0);
    
    --clock signals
    signal clk : STD_LOGIC := '0';

begin

    uut: HIGHT
         Port map (
                   intext => ptext,
                   clock => clk,
                   masterkey => mkey,
                   outtext => ctext
                   );
                   
    stimulus_generator: stimgen
                        Port map (
                                  plaintext => ptext,
                                  clock => clk,
                                  masterkey => mkey,
                                  ciphertext => ctext
                                  );                                          

end Behavioral;
