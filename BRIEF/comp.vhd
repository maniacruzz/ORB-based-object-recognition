library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp is
  generic (
    width :     positive := 16);
  port (
    --clk, rst, ce : in std_logic;
    in0   : in  std_logic_vector(width-1 downto 0);
    in1   : in  std_logic_vector(width-1 downto 0);
    lt    : out std_logic);
end comp;

architecture UNSIGNED_INPUTS of comp is
begin
--compare : process(clk)
--begin
  --if clk='1' and clk'event then
	--if rst='1' then
	 --   lt<='0';
	--elsif ce='1' then
	    lt <= '1' when unsigned(in0) < unsigned(in1) else '0';
	--end if;
  --end if;
--end process compare;  
end UNSIGNED_INPUTS;

