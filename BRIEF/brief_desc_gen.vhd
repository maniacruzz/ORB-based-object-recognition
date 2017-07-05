
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.Amogh_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity brief_desc_gen is
port(
		smooth_patch : in vector_8bit(1088 downto 0); 
		--test : in vector_8bit(1023 downto 0); 

		clk, rst, ce : in std_logic;
		
		
		desc_256bit : out std_logic_vector(255 downto 0)
	);
end brief_desc_gen;



architecture Behavioral of brief_desc_gen is

signal desc_256bit_reg : unsigned(255 downto 0);

component comp is
  generic (
    width :     positive := 8);
  port (
    in0   : in  std_logic_vector(width-1 downto 0);
    in1   : in  std_logic_vector(width-1 downto 0);
    lt    : out std_logic);
end component;

begin
--unsigned(test(i*4))
--unsigned(test(i*4+1))
--unsigned(test(i*4+2))
--unsigned(test(i*4+3))

--unsigned(test(i*4))+((unsigned(test(i*4+1))-1)*33)
--unsigned(test(i*4+2))+((unsigned(test(i*4+3))-1)*33)
--in=33y+x

desc : for i in 0 to 255 generate
	desc_bit : comp 
		generic map( width => 8)
		port map(
			in0=>smooth_patch((test(i*4))+(test(i*4+1)*33)),
			in1=>smooth_patch((test(i*4+2))+(test(i*4+3)*33)),
			lt=>desc_256bit_reg(i)  );
end generate desc;

process(clk)
begin
   if clk'event and clk='1' then  
      if rst='1' then
	 desc_256bit<=(others=>'0');
      elsif ce = '1' then 
         desc_256bit<=std_logic_vector(desc_256bit_reg);
     end if; 
  end if;
end process;
--


end Behavioral;

