library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;
use work.functions.all;

entity HIGHT_FSM is
port (
    txt_in: in STD_LOGIC_VECTOR(parallelMessageLength-1 downto 0);
    mk: in STD_LOGIC_VECTOR(keyLength-1 downto 0);
    clk: in std_logic;
    reset: in std_logic;
    txt_out: out STD_LOGIC_VECTOR(parallelMessageLength-1 downto 0) );
end HIGHT_FSM;

-------------------------------- Architecture: ---------------------------------
architecture Behavioral of HIGHT_FSM is
------------------------------- Type Definition --------------------------------
type states is (KEY_SCHEDULE, INITIAL, ROUND, FINAL, OUTPUT);
----------------------------- Signals Declaration ------------------------------
signal STATE: states;
signal wk: byte (wkBytes-1 downto 0);
signal sk: byte (skBytes-1 downto 0);
signal txt: STD_LOGIC_VECTOR (parallelMessageLength-1 downto 0);
signal it, it2: byte (7 downto 0);
signal Xmid, Xmid2: bidirectional_vector(32 downto 0, 7 downto 0);

-------------------------------- Logic of FSM ---------------------------------
begin
    process (clk, reset)
        begin
            if reset = '1' then
                STATE <= KEY_SCHEDULE;
            elsif clk'event and clk='1' then
                case STATE is
                    when KEY_SCHEDULE =>
                        wk<=WhiteningKeyGeneration(mk);
                        sk<=SubkeyGeneration(mk);
                        STATE <= INITIAL;
                        txt <= txt_in;
                        
                    when INITIAL =>
                        it<=initial_transformation(wk, txt(63 downto 0));
                        it2<=initial_transformation(wk, txt(127 downto 64));
                        STATE <= ROUND;
                        
                    when ROUND =>
                        Xmid<=RoundFunction(sk, it);
                        Xmid2<=RoundFunction(sk, it2);                        
                        STATE <= FINAL;
                        
                    when FINAL =>
                        txt<=FinalTransformation(wk, Xmid2) & FinalTransformation(wk, Xmid);
                        STATE <= OUTPUT;
                        
                    when OUTPUT =>
                        txt_out <= txt;
                    when others => txt_out<= txt;
                end case;
            end if;
    end process;
end Behavioral;