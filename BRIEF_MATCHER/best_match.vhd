library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity best_match is
  generic (
    width :     positive := 9);
  port (
    clk, rst, ce : in std_logic;
    in0   : in  std_logic_vector(width-1 downto 0);
    in1   : in  std_logic_vector(width-1 downto 0);
    index : in  std_logic_vector(9 downto 0);
    best_index : out  std_logic_vector(9 downto 0);
    smallest    : out std_logic_vector(width-1 downto 0));
end best_match;

architecture BHV of best_match is
signal best_index_reg : std_logic_vector(9 downto 0);
begin

small_hamm : process(clk)
begin
  if clk='1' and clk'event then
	if rst='1' then
	    smallest <= (others=>'1');
	    best_index_reg <= (others=>'0');
	elsif ce='1' then
	    if unsigned(in0) < unsigned(in1) then
		smallest <= in0;
		best_index_reg <= index;
	    else 
		smallest <= in1;
		best_index_reg <= best_index_reg;
	    end if;
	    --smallest <= in0 when unsigned(in0) < unsigned(in1) else in1;
	end if;
  end if;
  
  best_index <= best_index_reg;
end process small_hamm;  
end BHV;

