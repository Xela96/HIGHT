library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity tb_lut_hight is
end tb_lut_hight;

architecture Behavioral of tb_lut_hight is

  CONSTANT clk_period : time := 73.75ns;

    component HIGHT_FSM
    Port( 
        txt_in: in STD_LOGIC_VECTOR (127 downto 0);
        mk: in STD_LOGIC_VECTOR (127 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        txt_out: out STD_LOGIC_VECTOR (127 downto 0) );
    end component;
    
    component stimgen
        generic (clock_period : time := clk_period);
      Port ( plaintext : out STD_LOGIC_VECTOR(127 downto 0);
             clock : inout STD_LOGIC;
             masterkey : out STD_LOGIC_VECTOR(127 downto 0);
             ciphertext : in STD_LOGIC_VECTOR(127 downto 0) );
    end component;
    
    signal ptext : STD_LOGIC_VECTOR(127 downto 0);
    signal clock : STD_LOGIC;
    signal rst : STD_LOGIC;
    signal mkey : STD_LOGIC_VECTOR(127 downto 0);
    signal ctext : STD_LOGIC_VECTOR(127 downto 0);

begin
    
    uut: HIGHT_FSM
         Port map (
                   txt_in => ptext,
                   mk => mkey,
                   clk => clock,
                   reset => rst,
                   txt_out => ctext
                   );
                   
    stimulus_generator: stimgen
                       Port map (
                                 plaintext => ptext,
                                 clock => clock,
                                 masterkey => mkey,
                                 ciphertext => ctext
                                 );                         
    
end Behavioral;
