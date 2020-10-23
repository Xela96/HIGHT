library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;

entity HIGHT is
  Port ( intext : in STD_LOGIC_VECTOR(messageLength-1 downto 0);
         clock : in STD_LOGIC;
         masterkey : in STD_LOGIC_VECTOR(keyLength-1 downto 0);
         outtext : out STD_LOGIC_VECTOR(messageLength-1 downto 0) );
end HIGHT;

architecture Behavioral of HIGHT is

--    component register_file
--        port(
--          Abus : out std_logic_vector(63 downto 0);
--          result : in std_logic_vector(63 downto 0);
--          writeEnable : in std_logic;
--          regAsel : in std_logic_vector(3 downto 0);
--          writeRegSel : in std_logic_vector(3 downto 0);
--          clock : in std_logic
--         );
--    end component;

    component KeySchedule
        Port( 
           masterkey : in STD_LOGIC_VECTOR(keyLength-1 downto 0);
           whitening_key : out byte(wkBytes-1 downto 0);
           subkey : out byte(skBytes-1 downto 0) );
    end component;
    
    component InitialTransformation
        Port ( plaintext : in STD_LOGIC_VECTOR(messageLength-1 downto 0);
               clock : in STD_LOGIC;
               whitening_key : in byte(wkBytes-1 downto 0);
               X0 : out byte(7 downto 0) );
    end component;    
    
    component RoundBlock
      Port ( X0 : in byte(7 downto 0);
             clock : in STD_LOGIC;
             X : out bidirectional_vector(32 downto 0, 7 downto 0);
             subkey : in byte(skBytes-1 downto 0) );
    end component;

    component FinalTransformation
      Port ( X : in bidirectional_vector(32 downto 0, 7 downto 0);
             clock : in STD_LOGIC;
             whitening_key : in byte(wkBytes-1 downto 0);
             ciphertext : out STD_LOGIC_VECTOR(messageLength-1 downto 0) ); 
    end component;
    
    -- Key signal declarations
    signal wkey : byte(wkBytes-1 downto 0);
    signal skey : byte(skBytes-1 downto 0);
    
    --Text signal declarations
    signal ptext : STD_LOGIC_VECTOR(messageLength-1 downto 0);
    signal ctext : STD_LOGIC_VECTOR(messageLength-1 downto 0);
    
    signal X0s : byte(7 downto 0);
    signal Xs : bidirectional_vector(32 downto 0, 7 downto 0);  
    
    --Register signals
    signal regAsel : STD_LOGIC_VECTOR (3 downto 0);

    signal WriteEnable: std_logic;
    signal abus_tmp,bbus_tmp,result_tmp:std_logic_vector(15 downto 0);
    signal ctrl_tmp: std_logic_vector(3 downto 0);
    signal writeRegSel_tmp: std_logic_vector(3 downto 0);    

begin

--   register1: register_file 
--   PORT MAP (
--            Abus => plaintext,
--            result => result_tmp,
--            writeEnable => writeEnable,
--            regAsel => regAsel,
--            writeRegSel => writeRegSel_tmp,
--            clock => clock
--        );

    uut: KeySchedule
         Port map (
                   masterkey => masterkey,
                   subkey => skey,
                   whitening_key => wkey
                   );
                   
    uut2: InitialTransformation
        Port map (
                  plaintext => intext,
                  clock => clock,
                  whitening_key => wkey,
                  X0 => X0s
                  );                   
                   
    uut3: RoundBlock
         Port map (
                  X0 => X0s,
                  clock => clock,
                  X => Xs,
                  subkey => skey
                  );    
                  
    uut4: FinalTransformation
           Port map (
                    X => Xs,
                    clock => clock,
                    whitening_key => wkey,
                    ciphertext => ctext
                    );                                     

system_result: process(ctext, wkey, skey)
begin
outtext <= ctext;
end process;

end Behavioral;
