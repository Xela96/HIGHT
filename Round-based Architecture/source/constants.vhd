library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package constants is

        constant messageLength : integer := 64;
        constant messageBytes : integer := 8;
        constant keyLength : integer := 128;
        constant keyBytes : integer := 16;
        constant wkLength : integer := 64;
        constant wkBytes : integer := 8;
        constant skLength : integer := 1024;
        constant skBytes : integer := 128;
        
        constant parallelMessageLength : integer := 128;
        
        type bidirectional_vector is array (integer range <>, integer range <>) of std_logic_vector(7 downto 0);
        type byte is array (integer range <>) of std_logic_vector(7 downto 0);
        type delta_byte is array (integer range <>) of std_logic_vector(6 downto 0);
        
end package constants;

package body constants is

end package body constants;
