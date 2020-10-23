library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FinalTransformation_tb is
end FinalTransformation_tb;

architecture Behavioral of FinalTransformation_tb is

component FinalTransformation
  Port ( X : in STD_LOGIC_VECTOR(2111 downto 0);
     whitening_key : in STD_LOGIC_VECTOR(63 downto 0);
     ciphertext : out STD_LOGIC_VECTOR(63 downto 0) );
end component;

    signal Xs : STD_LOGIC_VECTOR(2111 downto 0):=(others => '0');
    
    signal wkey : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
    signal ctext : STD_LOGIC_VECTOR(63 downto 0);

begin

    uut: FinalTransformation
         Port map (
                   X => Xs,
                   whitening_key => wkey,
                   ciphertext => ctext
                   );

    proc: process
    begin 
 Xs <= x"003818d1d9a103f35d3846d148a1def3315dd246f5482bde7b3187d2c4f5772b467bf187d5c4b277134617f1bfd57db2bf13f71733bfdf7d30bfd7f7a83369dfab30d6d74ba8bc69ceab53d6784b73bc87ce9d5351786873be87559d9a515868b7bedb55989ae45857b7b1dbd998c4e493570db102d9aec42c93a90ddd0283ae632c79a9e4ddd08320637a797ce4b5d07920b47a2b7c37b53a7943b40b2b3e37a03a3043030bb63e0ca0173007033fb65f0cf317d507073f595f8cf333d59c077359c58c1b33d79c4673c7c5e41b7dd7534609c7c3e4ee7d8a53cd0951c3d1ee4f8a91cd70518ad1e14fef91a3708a8acee138ef3fa3e78a00ce1138223f33e70000001100220033";
 wkey <= x"ccddeeff00112233";  
        wait for 350ns;    
                             
        wait;
    end process;


end Behavioral;
